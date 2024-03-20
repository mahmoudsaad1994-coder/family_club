class PostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;

  PostModel({
    required this.name,
    required this.image,
    required this.uId,
    required this.postImage,
    required this.text,
    required this.dateTime,
  });

  //لما استقبل داتا بالماب
  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    uId = json['uId'];
    postImage = json['postImage'];
    text = json['text'];
    dateTime = json['dateTime'];
  }

  //لما ابعت داتا بالماب
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'uId': uId,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
    };
  }
}
