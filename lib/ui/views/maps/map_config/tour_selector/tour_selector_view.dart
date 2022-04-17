import 'package:flutter/material.dart';
import 'package:historical_guide/ui/views/maps/map_config/widgets/visibility_toggle_button.dart';

class TourSelectorView extends StatelessWidget {
  const TourSelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VisibilityToggleButton(
        onChange: (value) => {},
      ),
    );
  }
}
