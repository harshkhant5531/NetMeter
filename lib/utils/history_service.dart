import '../utils/import_export.dart';

class HistoryService {
  static const String _historyKey = 'speed_test_history';
  
  static Future<void> saveTestHistory(TestHistory history) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = history.toJsonList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_historyKey, jsonString);
  }
  
  static Future<TestHistory> loadTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);
    
    if (jsonString == null) {
      return TestHistory();
    }
    
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final history = TestHistory();
      history.fromJsonList(jsonList);
      return history;
    } catch (e) {
      // If there's an error parsing, return empty history
      return TestHistory();
    }
  }
  
  static Future<void> addTestEntry(TestHistoryEntry entry) async {
    final history = await loadTestHistory();
    history.addEntry(entry);
    await saveTestHistory(history);
  }
  
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
} 