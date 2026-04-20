import 'package:shared_preferences/shared_preferences.dart';

class VocabularyService {
  static const _key = 'learned_terms_v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<Set<String>> getLearnedTerms() async {
    final p = await _prefs;
    return p.getStringList(_key)?.toSet() ?? {};
  }

  Future<void> markLearned(String term) async {
    final p = await _prefs;
    final learned = (p.getStringList(_key) ?? []).toSet()..add(term);
    await p.setStringList(_key, learned.toList());
  }

  Future<void> unmarkLearned(String term) async {
    final p = await _prefs;
    final learned = (p.getStringList(_key) ?? []).toSet()..remove(term);
    await p.setStringList(_key, learned.toList());
  }
}
