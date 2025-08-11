class SpeedTestModel {
  double downloadSpeed = 0.0;
  double uploadSpeed = 0.0;
  String pingResult = 'Loading...';
  String wifiIP = '';
  String wifiProvider = '';
  bool isTestingDownload = false;
  bool isTestingUpload = false;
  bool downloadTested = false;
  bool uploadTested = false;
  bool downloadSuccess = false;
  bool uploadSuccess = false;

  void reset() {
    downloadSpeed = 0.0;
    uploadSpeed = 0.0;
    downloadTested = false;
    uploadTested = false;
    downloadSuccess = false;
    uploadSuccess = false;
    isTestingDownload = false;
    isTestingUpload = false;
  }

  void setDownloadSpeed(double speed) {
    downloadSpeed = speed;
  }

  void setUploadSpeed(double speed) {
    uploadSpeed = speed;
  }

  void setPingResult(String result) {
    pingResult = result;
  }

  void setNetworkInfo(String ip, String provider) {
    wifiIP = ip;
    wifiProvider = provider;
  }

  void setDownloadTesting(bool testing) {
    isTestingDownload = testing;
  }

  void setUploadTesting(bool testing) {
    isTestingUpload = testing;
  }

  void setDownloadTested(bool tested) {
    downloadTested = tested;
  }

  void setUploadTested(bool tested) {
    uploadTested = tested;
  }

  void setDownloadSuccess(bool success) {
    downloadSuccess = success;
  }

  void setUploadSuccess(bool success) {
    uploadSuccess = success;
  }

  bool get isAnyTestRunning => isTestingDownload || isTestingUpload;
  bool get isTestComplete => downloadTested && uploadTested && downloadSuccess && uploadSuccess;
} 