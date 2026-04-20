import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const _sections = [
    _Section(
      title: '1. Veri Sorumlusu',
      body: 'Avialish uygulaması ("Uygulama") kapsamında kişisel verileriniz, 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") uyarınca veri sorumlusu sıfatıyla tarafımızca işlenmektedir.',
    ),
    _Section(
      title: '2. İşlenen Kişisel Veriler',
      body: '• E-posta adresi\n• Uygulama içi kullanım verileri (sınav sonuçları, ders ilerlemesi, rozet kazanımları)\n• Cihaz bilgileri ve IP adresi\n• Google hesabı ile giriş yapılması hâlinde Google tarafından paylaşılan profil bilgileri',
    ),
    _Section(
      title: '3. İşleme Amaçları',
      body: '• Üyelik oluşturma ve kimlik doğrulama\n• Kişiselleştirilmiş öğrenme deneyimi sunma\n• Uygulama performansı ve güvenliğinin sağlanması\n• Yasal yükümlülüklerin yerine getirilmesi\n• Hizmet iyileştirme ve istatistiksel analiz',
    ),
    _Section(
      title: '4. Hukuki Dayanak',
      body: 'Kişisel verileriniz; KVKK\'nın 5. maddesi kapsamında "sözleşmenin kurulması ve ifası", "meşru menfaat" ve "açık rıza" hukuki sebeplerine dayanılarak işlenmektedir.',
    ),
    _Section(
      title: '5. Üçüncü Kişilerle Paylaşım',
      body: 'Kişisel verileriniz; hizmet altyapımızı sağlayan Supabase (bulut veritabanı) ve Google (kimlik doğrulama, reklam) gibi iş ortaklarımızla, yasal zorunluluk durumlarında ise yetkili kamu kurum ve kuruluşlarıyla paylaşılabilir. Bu aktarımlar KVKK\'nın 8. ve 9. maddeleri çerçevesinde gerçekleştirilir.',
    ),
    _Section(
      title: '6. Saklama Süresi',
      body: 'Verileriniz, üyeliğinizin devam ettiği süre boyunca ve üyelik sona erdikten sonra yasal yükümlülükler kapsamında en fazla 3 yıl süreyle saklanır.',
    ),
    _Section(
      title: '7. Haklarınız (KVKK Md. 11)',
      body: 'KVKK\'nın 11. maddesi kapsamında aşağıdaki haklara sahipsiniz:\n• Kişisel verilerinizin işlenip işlenmediğini öğrenme\n• İşlenmişse buna ilişkin bilgi talep etme\n• İşlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme\n• Eksik veya yanlış işlenmişse düzeltilmesini isteme\n• Verilerinizin silinmesini talep etme\n• İşlemeye itiraz etme',
    ),
    _Section(
      title: '8. İletişim',
      body: 'Haklarınızı kullanmak veya sorularınız için: destek@avialish.com adresine e-posta gönderebilirsiniz.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KVKK Aydınlatma Metni'),
        backgroundColor: AppColors.primaryDeep,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Text(
                'Bu metin, 6698 sayılı KVKK kapsamında hazırlanmış olup kişisel verilerinizin nasıl işlendiğine dair bilgi vermektedir.',
                style: TextStyle(fontSize: 13, color: AppColors.primary, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            ..._sections.map((s) => _SectionWidget(section: s)),
          ],
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});
}

class _SectionWidget extends StatelessWidget {
  final _Section section;
  const _SectionWidget({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            section.body,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
          ),
        ],
      ),
    );
  }
}
