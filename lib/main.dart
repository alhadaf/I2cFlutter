import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/event_provider.dart';
import 'providers/attendee_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/badge_provider.dart';
import 'screens/event_selection_screen.dart';
import 'services/api_service.dart';
import 'services/sync_service.dart';
import 'services/connectivity_service.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'models/brother_printer.dart';

// Global navigator key for showing dialogs from providers
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register Hive adapters for Brother printer models
  Hive.registerAdapter(BrotherPrinterAdapter());
  Hive.registerAdapter(PrinterCapabilitiesAdapter());
  Hive.registerAdapter(LabelSizeAdapter());
  Hive.registerAdapter(PrinterConnectionTypeAdapter());
  Hive.registerAdapter(PrinterStatusAdapter());
  
  // Initialize SharedPreferences
  await SharedPreferences.getInstance();
  
  runApp(const EventCheckInApp());
}

class EventCheckInApp extends StatelessWidget {
  const EventCheckInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => SyncService()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => AttendeeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BadgeProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const EventSelectionScreen(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
      ),
    );
  }
}