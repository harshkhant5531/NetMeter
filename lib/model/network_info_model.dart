class NetworkInfoModel {
  String wifiName = 'Fetching...';
  String wifiBSSID = 'Fetching...';
  String wifiIP = 'Fetching...';
  String networkType = 'Detecting...';
  String ispProvider = 'Fetching...';
  String connectionStatus = 'Checking...';
  bool isLoading = true;

  void setWifiInfo(String name, String bssid) {
    wifiName = name;
    wifiBSSID = bssid;
  }

  void setNetworkType(String type) {
    networkType = type;
  }

  void setConnectionStatus(String status) {
    connectionStatus = status;
  }

  void setIP(String ip) {
    wifiIP = ip;
  }

  void setISPProvider(String provider) {
    ispProvider = provider;
  }

  void setLoading(bool loading) {
    isLoading = loading;
  }

  void reset() {
    wifiName = 'Fetching...';
    wifiBSSID = 'Fetching...';
    wifiIP = 'Fetching...';
    networkType = 'Detecting...';
    ispProvider = 'Fetching...';
    connectionStatus = 'Checking...';
    isLoading = true;
  }
} 