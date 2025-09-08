import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/test_history_model.dart';
import '../utils/history_service.dart';

class DailyUsageScreen extends StatefulWidget {
  const DailyUsageScreen({super.key});

  @override
  State<DailyUsageScreen> createState() => _DailyUsageScreenState();
}

class _DailyUsageScreenState extends State<DailyUsageScreen> {
  TestHistory _testHistory = TestHistory();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTestHistory();
  }

  Future<void> _loadTestHistory() async {
    try {
      final history = await HistoryService.loadTestHistory();
      setState(() {
        _testHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showClearHistoryDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Clear History',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all test history? This action cannot be undone.',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await HistoryService.clearHistory();
              _loadTestHistory();
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3EADCF), Color(0xFFABE9CD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Usage History',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                                     const Spacer(),
                   PopupMenuButton<String>(
                     icon: const Icon(Icons.more_vert, color: Colors.white),
                     onSelected: (value) {
                       if (value == 'clear') {
                         _showClearHistoryDialog();
                       }
                     },
                     itemBuilder: (context) => [
                       const PopupMenuItem(
                         value: 'clear',
                         child: Row(
                           children: [
                             Icon(Icons.clear_all, color: Colors.red),
                             SizedBox(width: 8),
                             Text('Clear History'),
                           ],
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Summary Cards
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Average Download',
                        '${_testHistory.getAverageDownloadSpeed().toStringAsFixed(2)} Mbps',
                        Icons.download,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        'Average Upload',
                        '${_testHistory.getAverageUploadSpeed().toStringAsFixed(2)} Mbps',
                        Icons.upload,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              
              // History Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Test History',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Last ${_testHistory.entries.length} tests',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // History List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _testHistory.entries.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No test history yet',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Run a speed test to see your history here',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                                                 : RefreshIndicator(
                             onRefresh: _loadTestHistory,
                             color: const Color(0xFF3EADCF),
                             backgroundColor: const Color(0xFF1A1A2E),
                             child: ListView.builder(
                               padding: const EdgeInsets.symmetric(horizontal: 16),
                               itemCount: _testHistory.entries.length,
                               itemBuilder: (context, index) {
                                 final entry = _testHistory.entries[index];
                                 return _buildHistoryCard(entry, index);
                               },
                             ),
                           ),
              ),
            ],
          ),
        ),
             ),
     );
   }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(TestHistoryEntry entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              entry.formattedDate,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              entry.formattedTime,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSpeedIndicator(
                    'Download',
                    '${entry.downloadSpeed.toStringAsFixed(2)} Mbps',
                    Icons.download,
                    entry.downloadSuccess ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSpeedIndicator(
                    'Upload',
                    '${entry.uploadSpeed.toStringAsFixed(2)} Mbps',
                    Icons.upload,
                    entry.uploadSuccess ? Colors.blue : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSpeedIndicator(
                    'Jitter',
                    '${entry.jitter.toStringAsFixed(1)} ms',
                    Icons.swap_horiz,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedIndicator(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


}
