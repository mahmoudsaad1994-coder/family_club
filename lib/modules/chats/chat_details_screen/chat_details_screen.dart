import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/message_model/message_model.dart';
import '../../../models/social_user_model/social_user_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/cubits/layout_cubit/cubit.dart';
import '../../../shared/cubits/layout_cubit/states.dart';
import '../../../shared/style/icon_broken.dart';

class ChatDetailsScreen extends StatefulWidget {
  const ChatDetailsScreen({required this.userModel, super.key});

  final SocialUserModel userModel;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  var messageControlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (contex) {
      SocialCubit.get(context).getmessages(receiverId: widget.userModel.uId!);
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.userModel.image!),
              ),
              const SizedBox(width: 15),
              Text(widget.userModel.name!),
            ],
          ),
        ),
        body: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ConditionalBuilder(
                    condition: SocialCubit.get(context).messages.isNotEmpty,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message =
                              SocialCubit.get(context).messages[index];
                          if (SocialCubit.get(context).userModel!.uId ==
                              message.senderId) {
                            return buildMyMessage(message);
                          }
                          return buildOtherMessage(message);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: SocialCubit.get(context).messages.length,
                      ),
                    ),
                    fallback: (context) => const Expanded(
                      child: Center(
                        child: Text('say hi'),
                      ),
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              controller: messageControlor,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message...'),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          color: defaultColor,
                          child: MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).sendMessage(
                                receiverId: widget.userModel.uId!,
                                dateTime: DateTime.now().toString(),
                                text: messageControlor.text,
                              );
                              messageControlor.text = '';
                            },
                            child: const Icon(
                              IconBroken.Send,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }

  buildMyMessage(MessageModel messageModel) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          child: Text(messageModel.text!),
        ),
      );

  buildOtherMessage(MessageModel messageModel) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
            ),
          ),
          child: Text(messageModel.text!),
        ),
      );
}
