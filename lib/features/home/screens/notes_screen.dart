import 'package:echo_note/utility/constants.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  final bool isFavouriteScreen;
  const NotesScreen({super.key, this.isFavouriteScreen = false});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Search Bar
        Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: TextField(
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Image.asset(
                  'assets/icons/search.png',
                  scale: 23,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: AppColors.primary)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                constraints: const BoxConstraints(maxHeight: 50),
              ),
              onChanged: (title) {
                // bool isEmpty = title.trim().isEmpty;
                // if (isEmpty) {
                //   _getFutureNotes();
                // }
                // Provider.of<Notes>(context, listen: false).searchNotes(title);
              },
            ),
          ),
        ),

        //ListView of NotesItems
      ],
    );
  }
}
