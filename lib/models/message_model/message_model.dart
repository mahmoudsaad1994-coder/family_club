class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.text,
  });

  //لما استقبل داتا بالماب
  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  //لما ابعت داتا بالماب
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'dateTime': dateTime,
      'receiverId': receiverId,
    };
  }
}
