// Flutter core packages
export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/foundation.dart';
export 'package:flutter/services.dart';
export 'dart:io';
export 'dart:async';
export 'dart:convert';
export 'dart:math';
export 'dart:typed_data';


// External packages
export 'package:gauge_indicator/gauge_indicator.dart';
export 'package:speed_test_dart/speed_test_dart.dart';
export 'package:http/http.dart';
export 'package:dart_ping/dart_ping.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:network_info_plus/network_info_plus.dart' hide NetworkManagerClientFactory;
export 'package:permission_handler/permission_handler.dart' hide ServiceStatus;
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:geolocator/geolocator.dart';
export 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:percent_indicator/percent_indicator.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:share_plus/share_plus.dart';

// Models
export 'package:speed_test/model/network_info_model.dart';
export 'package:speed_test/model/speed_test_model.dart';
export 'package:speed_test/model/test_history_model.dart';

// Controllers
export 'package:speed_test/controller/speed_test_controller.dart';

// Services
export 'package:speed_test/apiservice/apiService.dart';
export 'package:speed_test/utils/history_service.dart';
export 'package:speed_test/utils/notification_service.dart';

// Utils & Constants
export 'package:speed_test/utils/constants.dart';
export 'package:speed_test/utils/string_constant.dart';
export 'package:speed_test/utils/ui_helpers.dart';

// Note: Views and widgets are NOT exported here to avoid circular dependencies
// as they import this file themselves.
