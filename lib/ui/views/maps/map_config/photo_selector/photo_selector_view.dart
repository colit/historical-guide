import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/map_service.dart';
import '../widgets/visibility_toggle_button.dart';

class PhotoSelectorView extends StatelessWidget {
  const PhotoSelectorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VisibilityToggleButton(
        visible: context.read<MapService>().photosVisibility,
        onChange: (value) =>
            context.read<MapService>().photosVisibility = value,
      ),
    );
  }
}
