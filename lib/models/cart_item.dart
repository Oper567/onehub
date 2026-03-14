class CartItem {
  final String id;
  final String title;
  final double price;
  final bool isService;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.isService = false,
  });
}
