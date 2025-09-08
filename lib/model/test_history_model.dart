class TestHistoryEntry {
  final DateTime dateTime;
  final double downloadSpeed;
  final double uploadSpeed;
  final double ping;
  final double jitter; // Add jitter field
  final bool downloadSuccess;
  final bool uploadSuccess;

  TestHistoryEntry({
    required this.dateTime,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
    required this.jitter, // Add jitter parameter
    required this.downloadSuccess,
    required this.uploadSuccess,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
      'ping': ping,
      'jitter': jitter, // Add jitter to JSON
      'downloadSuccess': downloadSuccess,
      'uploadSuccess': uploadSuccess,
    };
  }

  factory TestHistoryEntry.fromJson(Map<String, dynamic> json) {
    return TestHistoryEntry(
      dateTime: DateTime.parse(json['dateTime']),
      downloadSpeed: json['downloadSpeed']?.toDouble() ?? 0.0,
      uploadSpeed: json['uploadSpeed']?.toDouble() ?? 0.0,
      ping: json['ping']?.toDouble() ?? 0.0,
      jitter: json['jitter']?.toDouble() ?? 0.0, // Add jitter from JSON
      downloadSuccess: json['downloadSuccess'] ?? false,
      uploadSuccess: json['uploadSuccess'] ?? false,
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final testDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (testDate == today) {
      return 'Today';
    } else if (testDate == yesterday) {
      return 'Yesterday';
    } else {
      final difference = today.difference(testDate).inDays;
      return '$difference days ago';
    }
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class TestHistory {
  List<TestHistoryEntry> entries = [];

  void addEntry(TestHistoryEntry entry) {
    entries.insert(0, entry); // Add to beginning
    if (entries.length > 50) { // Keep only last 50 entries
      entries = entries.take(50).toList();
    }
  }

  List<TestHistoryEntry> getRecentEntries(int count) {
    return entries.take(count).toList();
  }

  double getAverageDownloadSpeed() {
    if (entries.isEmpty) return 0.0;
    final successfulTests = entries.where((e) => e.downloadSuccess).toList();
    if (successfulTests.isEmpty) return 0.0;
    final sum = successfulTests.fold(0.0, (sum, entry) => sum + entry.downloadSpeed);
    return sum / successfulTests.length;
  }

  double getAverageUploadSpeed() {
    if (entries.isEmpty) return 0.0;
    final successfulTests = entries.where((e) => e.uploadSuccess).toList();
    if (successfulTests.isEmpty) return 0.0;
    final sum = successfulTests.fold(0.0, (sum, entry) => sum + entry.uploadSpeed);
    return sum / successfulTests.length;
  }

  double getAveragePing() {
    if (entries.isEmpty) return 0.0;
    final sum = entries.fold(0.0, (sum, entry) => sum + entry.ping);
    return sum / entries.length;
  }

  double getAverageJitter() {
    if (entries.isEmpty) return 0.0;
    final sum = entries.fold(0.0, (sum, entry) => sum + entry.jitter);
    return sum / entries.length;
  }

  List<Map<String, dynamic>> toJsonList() {
    return entries.map((entry) => entry.toJson()).toList();
  }

  void fromJsonList(List<dynamic> jsonList) {
    entries = jsonList
        .map((json) => TestHistoryEntry.fromJson(json as Map<String, dynamic>))
        .toList();
  }
} 