import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'ip_to_location.dart';

class NetworkInfoScreen extends StatefulWidget {
  const NetworkInfoScreen({super.key});

  @override
  State<NetworkInfoScreen> createState() => _NetworkInfoScreenState();
}

class _NetworkInfoScreenState extends State<NetworkInfoScreen> {
  final NetworkInfo _networkInfo = NetworkInfo();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  String wifiName = 'Fetching...';
  String wifiBSSID = 'Fetching...';
  String wifiIP = 'Fetching...';
  String networkType = 'Detecting...';
  String ispProvider = 'Fetching...';
  String mobileCarrier = 'Not Available';
  String connectionStatus = 'Checking...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNetworkDetails();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _loadNetworkDetails();
    });
  }

  Future<void> _loadNetworkDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Permission.location.request();
      await Permission.locationWhenInUse.request();
      await Permission.nearbyWifiDevices.request();

      final connectivityResults = await Connectivity().checkConnectivity();
      
      ConnectivityResult connectivityResult = connectivityResults.isNotEmpty 
          ? connectivityResults.first 
          : ConnectivityResult.none;

      setState(() {
        switch (connectivityResult) {
          case ConnectivityResult.wifi:
            networkType = 'WiFi';
            connectionStatus = 'Connected to WiFi';
            break;
          case ConnectivityResult.mobile:
            networkType = 'Mobile Data';
            connectionStatus = 'Connected to Mobile Network';
            break;
          case ConnectivityResult.ethernet:
            networkType = 'Ethernet';
            connectionStatus = 'Connected via Ethernet';
            break;
          case ConnectivityResult.vpn:
            networkType = 'VPN';
            connectionStatus = 'Connected via VPN';
            break;
          case ConnectivityResult.bluetooth:
            networkType = 'Bluetooth';
            connectionStatus = 'Connected via Bluetooth';
            break;
          case ConnectivityResult.other:
            networkType = 'Other';
            connectionStatus = 'Connected via Other';
            break;
          case ConnectivityResult.none:
            networkType = 'No Connection';
            connectionStatus = 'No Internet Connection';
            break;
        }
      });

      String? ip;
      try {
        ip = await _networkInfo.getWifiIP();
        if (ip == null || ip.isEmpty) {
          ip = await _networkInfo.getWifiIP();
        }
      } catch (e) {
        ip = 'Not Available';
      }

      setState(() {
        wifiIP = ip ?? 'Not Available';
      });

      if (connectivityResult == ConnectivityResult.wifi) {
        try {
          final name = await _networkInfo.getWifiName();
          final bssid = await _networkInfo.getWifiBSSID();
          
          setState(() {
            wifiName = name ?? 'Not Available';
            wifiBSSID = bssid ?? 'Not Available';
          });
        } catch (e) {
          setState(() {
            wifiName = 'Not Available';
            wifiBSSID = 'Not Available';
          });
        }
      } else {
        setState(() {
          wifiName = 'N/A (Not connected to WiFi)';
          wifiBSSID = 'N/A (Not connected to WiFi)';
        });
      }

      await _fetchISPInfo();
    } catch (e) {
      print('Error loading network details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchISPInfo() async {
    try {
      final ipResp = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (ipResp.statusCode == 200) {
        final ip = json.decode(ipResp.body)['ip'];
        final ispResp = await http.get(Uri.parse('https://ipinfo.io/$ip/json'));
        if (ispResp.statusCode == 200) {
          final ispData = json.decode(ispResp.body);
          String provider = ispData['org'] ?? ispData['isp'] ?? 'Unknown';
          provider = provider.replaceFirst(RegExp(r'^AS\d+\s+'), '');
          
          setState(() {
            ispProvider = provider;
          });
        } else {
          setState(() {
            ispProvider = 'Unknown';
          });
        }
      } else {
        setState(() {
          ispProvider = 'Unknown';
        });
      }
    } catch (e) {
      setState(() {
        ispProvider = 'Unknown';
      });
    }
  }

  Widget _buildNetworkTypeIndicator() {
    IconData icon;
    Color color;
    String label;
    
    switch (networkType) {
      case 'WiFi':
        icon = Icons.wifi;
        color = Colors.green;
        label = 'WiFi Connected';
        break;
      case 'Mobile Data':
        icon = Icons.signal_cellular_4_bar;
        color = Colors.blue;
        label = 'Mobile Data Connected';
        break;
      case 'Ethernet':
        icon = Icons.cable;
        color = Colors.orange;
        label = 'Ethernet Connected';
        break;
      case 'VPN':
        icon = Icons.vpn_key;
        color = Colors.purple;
        label = 'VPN Connected';
        break;
      case 'No Connection':
        icon = Icons.signal_wifi_off;
        color = Colors.red;
        label = 'No Internet Connection';
        break;
      default:
        icon = Icons.network_check;
        color = Colors.grey;
        label = 'Unknown Connection';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  connectionStatus,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color gradientStart, Color gradientEnd) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
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
                  Expanded(
                    child: Text(
                      'Network Information',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNetworkDetails,
                  color: Colors.white,
                  backgroundColor: const Color(0xFF3EADCF),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 20),
                      _buildNetworkTypeIndicator(),
                      _buildInfoCard(
                        "Connection Type",
                        networkType,
                        Icons.network_check,
                        const Color(0xFF9C27B0),
                        const Color(0xFFBA68C8),
                      ),
                      _buildInfoCard(
                        "Connection Status",
                        connectionStatus,
                        Icons.signal_cellular_alt,
                        const Color(0xFFFF9800),
                        const Color(0xFFFFB74D),
                      ),
                      _buildInfoCard(
                        "ISP Provider",
                        ispProvider,
                        Icons.business,
                        const Color(0xFF607D8B),
                        const Color(0xFF90A4AE),
                      ),
                      _buildInfoCard(
                        "Device IP",
                        wifiIP,
                        Icons.network_wifi,
                        const Color(0xFF4CAF50),
                        const Color(0xFF81C784),
                      ),
                      if (networkType == 'WiFi') ...[
                        _buildInfoCard(
                          "Wi-Fi Name (SSID)",
                          wifiName,
                          Icons.wifi,
                          const Color(0xFFE91E63),
                          const Color(0xFFF06292),
                        ),
                        _buildInfoCard(
                          "Router MAC (BSSID)",
                          wifiBSSID,
                          Icons.router,
                          const Color(0xFF2196F3),
                          const Color(0xFF64B5F6),
                        ),
                      ] else if (networkType == 'Mobile Data') ...[
                        _buildInfoCard(
                          "Mobile Network",
                          "Cellular Data Connection",
                          Icons.signal_cellular_4_bar,
                          const Color(0xFF00BCD4),
                          const Color(0xFF4DD0E1),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Pull down to refresh",
                          style: GoogleFonts.poppins(
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3EADCF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LocationInfoScreen()),
                            );
                          },
                          icon: const Icon(Icons.location_on),
                          label: Text(
                            "View Location Info",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}