import 'dart:io';

import 'package:chat_with_me/shared/cubits/layout_cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/message_model/message_model.dart';
import '../../../models/post_model/post_model.dart';
import '../../../models/social_user_model/social_user_model.dart';
import '../../../modules/chats/user_chats_screen/User_chats_screen.dart';
import '../../../modules/feeds/feeds_screen.dart';
import '../../../modules/login_screen/login_screen.dart';
import '../../../modules/new_post/new_post_screen.dart';
import '../../../modules/profile/profile_screen.dart';
import '../../../modules/users/users_screen.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  // get user data and initial user model
  getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userUId)
        .get()
        .then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print('getUserData error : $error');
      emit(SocialGetUserErrorState(error: error));
    });
  }

  int currentIndex = 0;

  //pages
  List screens = [
    const FeedsScreen(),
    const UserChatsScreen(),
    const NewPostScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ];

  // pages appbar title
  List titles = [
    'Home',
    'Chats',
    'Posts',
    'Users',
    'Profile',
  ];

  //Navigate between pages
  changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  // get profile image from gallery
  File? profileImage;
  var profileImagePicker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile =
        await profileImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  // upload profile image on server
  String? profileImageUrl;

  Future<void> uploadProfileImage() async {
    await firebase_storge.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) async {
      // get url of picture

      await value.ref.getDownloadURL().then((urlValue) {
        emit(SocialUploadProfileImageSuccessState());
        profileImageUrl = urlValue;
      }).catchError((error) {
        print('error from profile get url image $error');
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      print('error from profile upload image $error');
      emit(SocialUploadProfileImageErrorState());
    });
  }

  // get cover image from gallery
  File? coverImage;
  var coverImagePicker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile =
        await coverImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  // upload cover image on server
  String? coverImageUrl;

  Future<void> uploadCoverImage() async {
    await firebase_storge.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) async {
      // get url of picture
      await value.ref.getDownloadURL().then((urlValue) {
        emit(SocialUploadCoverImageSuccessState());
        coverImageUrl = urlValue;
      }).catchError((error) {
        print('error from profile get url image $error');
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      print('error from profile upload image $error');
      emit(SocialUploadCoverImageErrorState());
    });
  }

  //upload cover and profile images on server
  uploadUserImages() async {
    if (coverImage != null) await uploadCoverImage();
    if (profileImage != null) await uploadProfileImage();
  }

  // update user profile
  updateUserData({
    String? name,
    String? bio,
    String? phone,
  }) async {
    emit(SocialUserUpdateLoadingState());
    //upload profile and cover images on firestorge
    await uploadUserImages();
    // update user data on firebasa
    FirebaseFirestore.instance.collection('users').doc(userModel!.uId).update({
      'name': name,
      'phone': phone,
      'bio': bio,
      'image': profileImageUrl ?? userModel!.image,
      'cover': coverImageUrl ?? userModel!.cover,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      print('error from update data $error');
      emit(SocialUserUpdateErrorState());
    });
  }

  // get post image from gallery
  File? postImage;
  var postImagePicker = ImagePicker();

  Future<void> getPostImage() async {
    final pickedFile =
        await postImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(SocialPostImagePickedErrorState());
    }
  }

  // remove image from post
  removeImageFromPost() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  //create post with image
  createNewPostWithImage({
    required String dateTime,
    required String text,
  }) {
    firebase_storge.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      // get url of picture
      value.ref.getDownloadURL().then((urlValue) {
        createNewPost(
          dateTime: dateTime,
          text: text,
          postImage: urlValue,
        );
      }).catchError((error) {
        print('error from profile get url image $error');
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      print('error from profile upload image $error');
      emit(SocialCreatePostErrorState());
    });
  }

  //create post without image
  createNewPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      postImage: postImage ?? '',
      text: text,
      dateTime: dateTime,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      getPosts();
    }).catchError((error) {
      print('error from update data $error');
      emit(SocialCreatePostErrorState());
    });
  }

  //get posts from server
  List<PostModel> posts = [];
  List<String> postIdList = [];
  List<int> likes = [];

  List userLikedID = [];
  Map<String, List> postLikesID = {};

  getPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) async {
      for (var postElement in value.docs) {
        //add likes
        await postElement.reference.collection('likes').get().then((postLikes) {
          //add post likes length
          likes.add(postLikes.docs.length);
          for (var e in postLikes.docs) {
            userLikedID.add(e.id);
          }
          postLikesID.addAll({
            postElement.id: [...userLikedID]
          });
        }).catchError((error) {
          print('error from likes $error');
        });
        //add posts
        posts.add(PostModel.fromJson(postElement.data()));
        //add post id
        postIdList.add(postElement.id);
        userLikedID.clear();
      }
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      print(error);
      emit(SocialGetPostsErrorState(error: error.toString()));
    });
  }

  bool isLiked(String postId) {
    return postLikesID[postId]!.contains(userModel!.uId);
  }

  //post likes
  likePost(String postId, int index) {
    if (postLikesID[postId]!.contains(userModel!.uId)) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userModel!.uId)
          .delete()
          .then((value) {
        updateLikesCount(postId, index);
        emit(SocialPostLikesSuccessState());
      }).catchError((error) {
        emit(SocialPostLikesErrorState(error: error));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userModel!.uId)
          .set({
        'like': true,
      }).then((value) {
        updateLikesCount(postId, index);
        emit(SocialPostLikesSuccessState());
      }).catchError((error) {
        emit(SocialPostLikesErrorState(error: error));
      });
    }
  }

  //update post likes
  updateLikesCount(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((valueLikes) {
      likes[index] = valueLikes.docs.length;
      for (var e in valueLikes.docs) {
        userLikedID.add(e.id);
      }
      postLikesID[postId] = [...userLikedID];
      userLikedID.clear();
      emit(SocialUpdatePostLikesSuccessState());
    }).catchError((error) {
      emit(SocialUpdateLikesErrorState(error: error));
    });
  }

//post comment
// postComment(
//     {required String postId, required String comment, required int index}) {
//   FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .doc(userModel!.uId)
//       .set({
//     'comment': comment,
//   }).then((value) {
//     updateCommentCount(postId, index);
//     emit(SocialPostCommentsSuccessState());
//   }).catchError((error) {
//     emit(SocialPostCommentsErrorState(error: error));
//   });
// }
//
// //update post comment
// updateCommentCount(String postId, int index) {
//   FirebaseFirestore.instance
//       .collection('posts')
//       .doc(postId)
//       .collection('comments')
//       .get()
//       .then((valueComments) {
//     // comments[index] = valueComments.docs.length;
//     emit(SocialUpdatePostLikesSuccessState());
//   }).catchError((error) {
//     emit(SocialUpdateLikesErrorState(error: error));
//   });
// }

  //get all users in chat
  List<SocialUserModel> users = [];

  getUsers() {
    emit(SocialGetAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) async {
      for (var postElement in value.docs) {
        if (postElement.data()['uId'] != userModel!.uId) {
          users.add(SocialUserModel.fromJson(postElement.data()));
        }
      }

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error);
      emit(SocialGetAllUsersErrorState(error: error.toString()));
    });
  }

  //user sign out
  signout(context) {
    emit(SocialUserSignoutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      SocialacheHelper.sharedPreferences.clear();
      userUId = '';
      currentIndex = 0;
      navigateTo(context, const LoginScreen(), backOrNo: false);
      emit(SocialUserSignoutSuccessState());
    }).catchError((error) {
      emit(SocialUserSignoutErrorState(error: error));
    });
  }

  //chat
  sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    //save data for my
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error: error));
    });
    //save data for receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error: error));
    });
  }

  //get messages
  List<MessageModel> messages = [];

  getmessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime') // رتيب الرسايل
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }
}
