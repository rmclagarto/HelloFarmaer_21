class Message {
  final String sender;
  final String? text;
  final String? imagePath;
  final DateTime time;

  Message({
    required this.sender,
    this.text,
    this.imagePath,
    required this.time,
  });
}
