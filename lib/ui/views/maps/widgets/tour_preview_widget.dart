import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_state.dart';
import '../../../widgets/pointer_interceptor/web.dart';
import '../../../widgets/round_icon_button.dart';

class TourPreviewWidget extends StatefulWidget {
  const TourPreviewWidget({
    Key? key,
    this.selectedTour,
  }) : super(key: key);

  static const widgetHeight = 90.0;

  final Tour? selectedTour;

  @override
  State<TourPreviewWidget> createState() => _TourPreviewWidgetState();
}

class _TourPreviewWidgetState extends State<TourPreviewWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -1.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  void didUpdateWidget(covariant TourPreviewWidget oldWidget) {
    if (oldWidget.selectedTour != widget.selectedTour) {
      if (widget.selectedTour != null) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: SlideTransition(
        position: _offsetAnimation,
        child: PointerInterceptor(
          child: Container(
            padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
            decoration: const BoxDecoration(
              color: kColorWhite,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  offset: Offset(0, 6),
                  blurRadius: 10,
                )
              ],
            ),
            width: 300,
            // height: TourPreviewWidget.widgetHeight,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.selectedTour?.name ?? 'No tour selected'),
                      Text('Tourlänge: ${widget.selectedTour?.length} km'),
                      Text('${widget.selectedTour?.stations.length} Stationen'),
                    ],
                  ),
                ),
                RoundIconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onTap: () {
                    if (widget.selectedTour != null) {
                      context.read<AppState>().pushPage(
                            name: 'tour_details',
                            arguments:
                                TourDetailArguments(widget.selectedTour!.id),
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
