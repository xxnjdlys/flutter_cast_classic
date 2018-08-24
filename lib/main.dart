import 'package:flutter/material.dart';
import 'package:flutter_cast_classic/ui/page/dashboard/dashboard.dart';

void main() => runApp(new CastClassicApp());

class CastClassicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardPage(),
    );
  }
}
