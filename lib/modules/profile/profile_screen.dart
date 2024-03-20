import 'package:chat_with_me/shared/components/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';
import '../edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = SocialCubit.get(context).userModel;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 190,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              image: DecorationImage(
                                image: NetworkImage('${userModel!.cover}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 64,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage('${userModel.image}'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '${userModel.name}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${userModel.bio}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '50',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  'Picture',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '480',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  'Followings',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '4',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(defaultColor),
                              side: MaterialStateProperty.all(const BorderSide(
                                color: defaultColor,
                              ))),
                          icon: const Icon(IconBroken.Image),
                          label: const Text('Add Photos'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            navigateTo(context, const EditProfileScreen());
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(defaultColor),
                              side: MaterialStateProperty.all(const BorderSide(
                                color: defaultColor,
                              ))),
                          icon: const Icon(IconBroken.Edit),
                          label: const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            FirebaseMessaging.instance
                                .unsubscribeFromTopic('announ');
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(defaultColor),
                              side: MaterialStateProperty.all(const BorderSide(
                                color: defaultColor,
                              ))),
                          child: const Text('unSubscribe'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            FirebaseMessaging.instance
                                .subscribeToTopic('announ');
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(defaultColor),
                              side: MaterialStateProperty.all(const BorderSide(
                                color: defaultColor,
                              ))),
                          child: const Text('Subscribe'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
