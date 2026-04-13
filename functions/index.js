const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Iyzipay = require('iyzipay');

admin.initializeApp();

// ── iyzipay instance ──────────────────────────────────────────────────────────
function getIyzipay() {
  const cfg = functions.config().iyzico || {};
  return new Iyzipay({
    apiKey:    cfg.api_key    || process.env.IYZICO_API_KEY,
    secretKey: cfg.secret_key || process.env.IYZICO_SECRET_KEY,
    uri: (cfg.sandbox === 'true')
      ? 'https://sandbox-api.iyzipay.com'
      : 'https://api.iyzipay.com',
  });
}

// ── Plan fiyatları (USD) ──────────────────────────────────────────────────────
const PLANS = {
  pilot:      { monthly: '50.00', annual: '420.00' },
  cabin_crew: { monthly: '25.00', annual: '210.00' },
  amt:        { monthly: '25.00', annual: '210.00' },
  student:    { monthly: '10.00', annual: '84.00'  },
};

// ── 1. Ödeme sayfası oluştur (Flutter tarafından çağrılır) ────────────────────
exports.createIyzicoCheckout = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Giriş yapılmamış.');
  }

  const { planKey, annual, email, name } = data;

  if (!PLANS[planKey]) {
    throw new functions.https.HttpsError('invalid-argument', 'Geçersiz plan.');
  }

  const price  = annual ? PLANS[planKey].annual : PLANS[planKey].monthly;
  const uid    = context.auth.uid;
  const convId = `${uid}_${Date.now()}`;

  // Firestore'a bekleyen ödeme kaydet
  await admin.firestore().collection('pendingPayments').doc(convId).set({
    uid,
    planKey,
    annual: !!annual,
    price,
    status: 'pending',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const firstName = name ? name.split(' ')[0] : 'User';
  const lastName  = name && name.split(' ').length > 1
    ? name.split(' ').slice(1).join(' ')
    : 'User';

  const request = {
    locale: 'tr',
    conversationId: convId,
    price,
    paidPrice: price,
    currency:  'USD',
    basketId:  convId,
    paymentGroup: 'SUBSCRIPTION',
    callbackUrl: 'https://us-central1-fliq-1638d.cloudfunctions.net/iyzicoCallback',
    buyer: {
      id:                  uid,
      name:                firstName,
      surname:             lastName,
      email:               email || 'user@avialish.com',
      identityNumber:      '11111111111', // dijital ürün — TC zorunlu değil
      registrationAddress: 'Turkey',
      city:                'Istanbul',
      country:             'Turkey',
      ip:                  '85.34.78.112',
    },
    shippingAddress: {
      contactName: `${firstName} ${lastName}`,
      city:        'Istanbul',
      country:     'Turkey',
      address:     'Turkey',
    },
    billingAddress: {
      contactName: `${firstName} ${lastName}`,
      city:        'Istanbul',
      country:     'Turkey',
      address:     'Turkey',
    },
    basketItems: [{
      id:       `${planKey}_${annual ? 'annual' : 'monthly'}`,
      name:     `Avialish Premium - ${planKey} (${annual ? 'Yıllık' : 'Aylık'})`,
      category1: 'Education',
      itemType:  'VIRTUAL',
      price,
    }],
  };

  return new Promise((resolve, reject) => {
    getIyzipay().checkoutFormInitialize.create(request, (err, result) => {
      if (err) {
        console.error('iyzico error:', err);
        reject(new functions.https.HttpsError('internal', err.message));
        return;
      }
      if (result.status !== 'success') {
        console.error('iyzico result:', result);
        reject(new functions.https.HttpsError('internal', result.errorMessage || 'iyzico hatası'));
        return;
      }
      resolve({ paymentPageUrl: result.paymentPageUrl, token: result.token });
    });
  });
});

// ── 2. iyzico ödeme sonucu (iyzico tarafından çağrılır) ───────────────────────
exports.iyzicoCallback = functions.https.onRequest(async (req, res) => {
  const token = req.body.token;

  if (!token) {
    res.redirect('https://avialish.com?payment=error');
    return;
  }

  try {
    const result = await new Promise((resolve, reject) => {
      getIyzipay().checkoutForm.retrieve(
        { locale: 'tr', token },
        (err, r) => err ? reject(err) : resolve(r),
      );
    });

    if (result.paymentStatus === 'SUCCESS') {
      const convId      = result.conversationId;
      const pendingRef  = admin.firestore().collection('pendingPayments').doc(convId);
      const pendingSnap = await pendingRef.get();

      if (pendingSnap.exists) {
        const { uid, planKey, annual } = pendingSnap.data();

        // Kullanıcıyı premium yap
        await admin.firestore().collection('users').doc(uid).update({
          isPremium:           true,
          premiumPlan:         planKey,
          premiumPeriod:       annual ? 'annual' : 'monthly',
          premiumActivatedAt:  admin.firestore.FieldValue.serverTimestamp(),
          premiumIyzicoToken:  token,
        });

        await pendingRef.update({ status: 'completed' });
      }

      res.redirect('https://avialish.com?payment=success');
    } else {
      res.redirect('https://avialish.com?payment=failed');
    }
  } catch (err) {
    console.error('Callback error:', err);
    res.redirect('https://avialish.com?payment=error');
  }
});
