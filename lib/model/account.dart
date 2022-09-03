class Account {
  String id;
  String name;
  String imagePath;
  String userId;
  String selfIntroduction;
  DateTime? createdTime;
  DateTime? updatedTime;

  Account({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.userId,
    required this.selfIntroduction,
    this.createdTime,
    this.updatedTime,
  });
}