import 'package:flutter/material.dart';
import 'package:historical_guide/ui/views/maps/map_config/widgets/visibility_toggle_button.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/map_service.dart';

class TourSelectorView extends StatelessWidget {
  const TourSelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VisibilityToggleButton(
        visible: context.read<MapService>().toursVisibility,
        onChange: (value) {
          context.read<MapService>().toursVisibility = value;
        },
      ),
    );
  }
}
