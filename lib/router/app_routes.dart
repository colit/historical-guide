abstract class AppRoutePath {}

class MapPath extends AppRoutePath {}

class GuidesPath extends AppRoutePath {}

class GuideDetailPath extends AppRoutePath {
  GuideDetailPath(this.id);
  final String id;
}

class AboutPath extends AppRoutePath {}

class PageNotFoundPath extends AppRoutePath {}
