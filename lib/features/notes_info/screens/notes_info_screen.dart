import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:echo_note/utility/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesInfoScreen extends StatelessWidget {
  final NoteModel note;
  const NotesInfoScreen({super.key, required this.note});

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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      DateFormat.MMMMEEEEd()
                          .addPattern('h:mm a')
                          .format(note.dateTime),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
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
                    style: Theme.of(context).textTheme.titleMedium,
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
        child: Icon(
          Icons.add,
          color: AppColors.primary,
          size: 25,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: BottomAppBar(
            color: AppColors.primary,
            // shape: const CircularNotchedRectangle(),
            // notchMargin: 10,
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
                              content:
                                  const Text('Do you want to delete note?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    SnackBarWidget(
                                      context: context,
                                      label: 'Note deleted successfully.',
                                      color: Colors.grey[200]!,
                                    ).show();
                                    Navigator.of(context).pop();
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
                        "assets/icons/favourite_icon_off.png",
                        width: 30,
                      )),
                  IconButton(
                    onPressed: () {
                      SnackBarWidget(
                        context: context,
                        label: note.isFavourite
                            ? 'Note added to favorite'
                            : 'Note removed from favorites',
                        color: Colors.grey[200]!,
                      ).show();
                    },
                    iconSize: 30,
                    color: Colors.red,
                    splashRadius: 25,
                    icon: Image.asset(
                      "assets/icons/favourite_icon_off.png",
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
