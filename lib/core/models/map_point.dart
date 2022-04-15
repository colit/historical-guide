class MapPoint {
  MapPoint({required this.id, this.itemsCount = 1});
  final int id;
  final int itemsCount;

  bool get isCluster => itemsCount > 1;
}
