import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends ConsumerWidget {
  final _appRouter = AppRouter();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: themeData(
        currentAppTheme.value == CurrentAppTheme.dark ? darkTheme : lightTheme,
      ),
      darkTheme: themeData(darkTheme),
      themeMode: currentAppTheme.value?.themeMode,
      routerDelegate: _appRouter.delegate(), // Set the router delegate
      routeInformationParser: _appRouter.defaultRouteParser(), // Set the route information parser
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: lightAccent,
      ),
    );
  }
}
