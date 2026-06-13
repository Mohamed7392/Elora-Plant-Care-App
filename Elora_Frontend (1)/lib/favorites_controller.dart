class FavoritesController {
  static final List<Map<String, dynamic>> favorites = [];

  static bool isFavorite(String name) {
    return favorites.any((item) => item['name'] == name);
  }

  static void toggleFavorite(Map<String, dynamic> plant) {
    if (isFavorite(plant['name'])) {
      favorites.removeWhere((item) => item['name'] == plant['name']);
    } else {
      favorites.add(plant);
    }
  }
}