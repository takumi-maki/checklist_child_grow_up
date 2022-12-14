class Account {
  String id;
  String name;
  String email;
  String? imagePath;

  Account({
    required this.id,
    required this.name,
    required this.email,
    this.imagePath,
  });
}