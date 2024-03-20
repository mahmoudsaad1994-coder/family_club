import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model/post_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/cubits/layout_cubit/cubit.dart';
import '../../shared/cubits/layout_cubit/states.dart';
import '../../shared/style/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return (cubit.posts.isNotEmpty && cubit.userModel != null)
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5,
                        margin: const EdgeInsets.all(8),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            const Image(
                              width: double.infinity,
                              image: NetworkImage(
                                  'https://img.freepik.com/free-photo/excited-curly-haired-girl-sunglasses-pointing-right-showing-way_176420-20192.jpg?w=996&t=st=1709222732~exp=1709223332~hmac=97e4896259c9234bded3b91d0d881740b6d650b098a6b108e1b3d39b868bf715'),
                              fit: BoxFit.cover,
                              height: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'communicate with friends',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => buildPostItem(
                            context, cubit.posts[index], index, cubit),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: cubit.posts.length,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  buildPostItem(
    context,
    PostModel model,
    int index,
    SocialCubit cubit,
  ) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${model.name}',
                          style: const TextStyle(height: 1.4),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: defaultColor,
                        )
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(height: 1.4, color: Colors.grey),
                    ),
                  ],
                )),
                const SizedBox(width: 15),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 16,
                    ))
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
            Text(
              '${model.text}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Wrap(
                children: [
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#software',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#Flutter_developer',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#Lindkedin',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#dart',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#mobile_development',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 0),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#iT',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#agile',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsetsDirectional.only(end: 4),
                    child: MaterialButton(
                      onPressed: () {},
                      minWidth: 1,
                      height: 25,
                      padding: EdgeInsets.zero,
                      child: Text(
                        '#software_development',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (model.postImage != '')
              Container(
                width: double.infinity,
                height: 140,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage('${model.postImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 8.0, bottom: 5, top: 5),
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Chat,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '1 comment',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        end: 8.0, bottom: 5, top: 5),
                    child: Row(
                      children: [
                        Text(
                          '${SocialCubit.get(context).likes[index]}',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            cubit.likePost(cubit.postIdList[index], index);
                          },
                          icon: Icon(
                            cubit.isLiked(cubit.postIdList[index])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
              margin: const EdgeInsetsDirectional.only(bottom: 10),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      buildCommentBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              NetworkImage('${cubit.userModel!.image}'),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'write your comment ...',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(height: 1.4, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  buildCommentBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: double.infinity,
            ));
  }
}
