import 'package:flutter/material.dart';
import 'package:historical_guide/ui/widgets/size_detector_widget.dart';

enum ImageDownloadState { idle, gettingURL, downloading, done, error, noImage }

class NetworkImageWidget extends StatefulWidget {
  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.errorWidget = const _ErrorPicture(),
    this.fallbackWidget = const _FallBackPicture(),
    this.loaderWidget = const _LoaderPicture(),
    this.fit = BoxFit.fitHeight,
    this.onLoaded,
  }) : super(key: key);

  final String url;

  final Widget errorWidget;

  final Widget loaderWidget;

  final Widget fallbackWidget;

  final BoxFit fit;

  final Function(Size)? onLoaded;

  @override
  _NetworkImageWidgetState createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget>
    with SingleTickerProviderStateMixin {
  late Image? _networkImage;
  late Widget loaderWidget;
  late Widget errorWidget;
  late Widget fallbackWidget;

  ImageDownloadState _imageDownloadState = ImageDownloadState.idle;

  late AnimationController controller;
  late Animation<double> animation;

  void _setImageData(dynamic url) {
    _networkImage = Image.network(
      url,
      fit: widget.fit,
    );
    _networkImage!.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((_, __) {
      if (mounted) {
        setState(() => _imageDownloadState = ImageDownloadState.done);
        controller.forward();
      }
    }));
    if (_imageDownloadState != ImageDownloadState.done) {
      _imageDownloadState = ImageDownloadState.downloading;
    }
  }

  void _setError() {
    if (mounted) {
      setState(() => _imageDownloadState = ImageDownloadState.error);
    }
  }

  @override
  void initState() {
    loaderWidget = widget.loaderWidget;
    errorWidget = widget.errorWidget;
    fallbackWidget = widget.fallbackWidget;
    controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    _setImageData(widget.url);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_imageDownloadState) {
      case ImageDownloadState.idle:
      case ImageDownloadState.gettingURL:
      case ImageDownloadState.downloading:
        return loaderWidget;
      case ImageDownloadState.error:
        return errorWidget;
      case ImageDownloadState.done:
        return SizeDetectorWidget(
          onChange: (size) => widget.onLoaded?.call(size),
          child: FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
            child: _networkImage,
          ),
        );
      case ImageDownloadState.noImage:
        return fallbackWidget;
      default:
        return errorWidget;
    }
  }
}

class _FallBackPicture extends StatelessWidget {
  const _FallBackPicture();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
    );
  }
}

class _ErrorPicture extends StatelessWidget {
  const _ErrorPicture();
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }
}

class _LoaderPicture extends StatelessWidget {
  const _LoaderPicture();
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
