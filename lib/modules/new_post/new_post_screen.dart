import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var textControlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is SocialCreatePostSuccessState) {
        textControlor.text = '';
        SocialCubit.get(context).postImage = null;
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      var cubit = SocialCubit.get(context);
      return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Crete Post',
            actions: [
              defaultTextButton(
                  onPress: () {
                    if (textControlor.text.isNotEmpty) {
                      if (SocialCubit.get(context).postImage == null) {
                        cubit.createNewPost(
                          dateTime: DateTime.now().toString(),
                          text: textControlor.text,
                        );
                      } else {
                        cubit.createNewPostWithImage(
                          dateTime: DateTime.now().toString(),
                          text: textControlor.text,
                        );
                      }
                    } else {
                      showToast(
                          text: 'type anything..', state: ToastStates.warning);
                    }
                  },
                  text: 'post'),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if (state is SocialCreatePostLoadingState)
                  const SizedBox(height: 10),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/confused-frustrated-young-questioned-woman-with-curly-hair-open-mouth-raising-eyebrow-surprise-being-displeased-with-unfair-situation-standing-clueless-upset-yellow-background_1258-81978.jpg?t=st=1709201996~exp=1709205596~hmac=e982139f83054dbcd70a572376409e6d4ed256fab201ca2486845e7d6a147a7b&w=996'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: Text(
                      'Mahmoud Saad',
                      style: TextStyle(height: 1.4),
                    )),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textControlor,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      hintText: 'what\'s on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.removeImageFromPost();
                          },
                          icon: const CircleAvatar(
                              radius: 15,
                              backgroundColor: defaultColor,
                              foregroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: 20,
                              ))),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5),
                            Text('add photo')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('# tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    });
  }
}
