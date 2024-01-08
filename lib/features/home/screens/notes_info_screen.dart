import 'package:echo_note/features/home/bloc/home_bloc.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:echo_note/utility/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotesInfoScreen extends StatelessWidget {
  final NoteModel note;
  final HomeBloc homeBloc;
  const NotesInfoScreen(
      {super.key, required this.note, required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: AppColors.secondary,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat.MMMMEEEEd()
                      .addPattern('h:mm a')
                      .format(note.dateTime),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  Text(
                    note.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => TextToSpeechScreen(
          //       homeBloc: homeBloc,
          //     ),
          //   ),
          // );
        },
        splashColor: AppColors.subTitle,
        backgroundColor: AppColors.iconBackground,
        child: Image.asset(
          "assets/icons/edit.png",
          width: 25,
          color: AppColors.primary,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: BottomAppBar(
            color: AppColors.primary,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text('Do you want to delete note?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  homeBloc.add(HomeNoteDeleteEvent(note: note));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  SnackBarWidget(
                                    context: context,
                                    label: 'Note deleted successfully.',
                                    color: Colors.grey[200]!,
                                  ).show();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    iconSize: 30,
                    splashRadius: 25,
                    icon: Image.asset(
                      "assets/icons/trash.png",
                      width: 30,
                      color: AppColors.secondary,
                    ),
                  ),
                  BlocBuilder(
                    bloc: homeBloc,
                    builder: (context, state) {
                      if (state is HomeSuccessState) {
                        return IconButton(
                          onPressed: () {
                            homeBloc.add(HomeNoteFavouritedEvent(note: note));
                            SnackBarWidget(
                              context: context,
                              label: note.isFavourite
                                  ? 'Note removed from favorites'
                                  : 'Note added to favorite',
                              color: Colors.grey[200]!,
                            ).show();
                          },
                          iconSize: 30,
                          color: note.isFavourite
                              ? AppColors.favourite
                              : AppColors.secondary,
                          splashRadius: 25,
                          icon: Icon(
                            note.isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
