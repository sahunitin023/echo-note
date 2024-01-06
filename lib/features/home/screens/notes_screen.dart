import 'package:echo_note/features/home/bloc/home_bloc.dart';
import 'package:echo_note/features/home/widgets/notes_item_widget.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesScreen extends StatefulWidget {
  final bool isFavouriteScreen;
  final HomeBloc homeBloc;
  const NotesScreen(
      {super.key, this.isFavouriteScreen = false, required this.homeBloc});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    widget.homeBloc.add(HomeInitialEvent());
    super.initState();
  }

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
                bool isEmpty = title.trim().isEmpty;
                if (isEmpty) {
                  widget.homeBloc.add(HomeInitialEvent());
                } else {
                  widget.homeBloc.add(HomeSearchEvent(title: title));
                }
              },
            ),
          ),
        ),
        //ListView of NotesItems
        Expanded(
          child: BlocBuilder(
            bloc: widget.homeBloc,
            builder: (context, state) {
              if (state is HomeSuccessState) {
                List<NoteModel> allNotes = state.notes;
                List<NoteModel> favouriteNotes =
                    allNotes.where((model) => model.isFavourite).toList();
                //For All Notes
                if (!widget.isFavouriteScreen) {
                  if (allNotes.isEmpty) {
                    return const Center(
                      child: Text('No Notes added yet!'),
                    );
                  }
                  return ListView.builder(
                      itemCount: allNotes.length,
                      itemBuilder: (context, index) {
                        return NotesItemWidget(
                            note: allNotes[index], homeBloc: widget.homeBloc);
                      });
                  //For Favourite Notes
                } else {
                  if (favouriteNotes.isEmpty) {
                    return const Center(
                      child: Text('No Favourites added yet!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: favouriteNotes.length,
                    itemBuilder: (context, index) {
                      return NotesItemWidget(
                          note: favouriteNotes[index],
                          homeBloc: widget.homeBloc);
                    },
                  );
                }
              } else {
                return const Center(
                  child: Text('Something went Wrong!!'),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
