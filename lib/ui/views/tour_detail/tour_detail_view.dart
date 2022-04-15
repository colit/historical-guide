import 'package:flutter/material.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:provider/provider.dart';

class TourDetailView extends StatelessWidget {
  const TourDetailView({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Center(
            child: Text('Detail View "$id"'),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: TextButton(
              onPressed: () {
                final appState = context.read<AppState>();
                appState.selectedPageId = null;
                appState.popPage();
              },
              child: const Text(
                'zurück',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
