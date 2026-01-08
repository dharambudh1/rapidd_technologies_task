import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod/legacy.dart";

final StateNotifierProvider<IndexController, int> indexProvider =
    StateNotifierProvider<IndexController, int>((Ref ref) {
      return IndexController();
    });

final StateNotifierProvider<SearchController, String> searchProvider =
    StateNotifierProvider<SearchController, String>((Ref ref) {
      return SearchController();
    });

class IndexController extends StateNotifier<int> {
  IndexController() : super(0);

  void set(int value) {
    state = value;

    return;
  }
}

class SearchController extends StateNotifier<String> {
  SearchController() : super("");

  void set(String value) {
    state = value;

    return;
  }
}
