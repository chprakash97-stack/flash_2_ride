class FlashPassModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final int totalRides;
  final double discountPerRide;
  final int validityDays;
  bool isPurchased;

  FlashPassModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.totalRides,
    required this.discountPerRide,
    required this.validityDays,
    this.isPurchased = false,
  });
}
