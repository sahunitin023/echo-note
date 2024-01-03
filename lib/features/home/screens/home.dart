import 'package:echo_note/features/add_note/screens/text_to_speech_screen.dart';
import 'package:echo_note/features/home/screens/notes_screen.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<String> appBarTitle = ['All Notes', 'Favourite Notes'];
  List<Widget> screens = [
    NotesScreen(),
    NotesScreen(
      isFavouriteScreen: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appBarTitle[_selectedIndex],
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: AppColors.secondary,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: FlashyTabBar(
            height: 55,
            backgroundColor: AppColors.primary,
            animationCurve: Curves.linear,
            selectedIndex: _selectedIndex,
            iconSize: 30,
            showElevation: false, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _selectedIndex = index;
            }),
            items: [
              FlashyTabBarItem(
                activeColor: AppColors.secondary,
                icon: Image.asset(
                  "assets/icons/doc_icon_off.png",
                  width: 30,
                ),
                title: const Text(
                  'Notes',
                ),
              ),
              FlashyTabBarItem(
                activeColor: AppColors.secondary,
                icon: Image.asset(
                  "assets/icons/favourite_icon_off.png",
                  width: 30,
                ),
                title: const Text(
                  'Favourite',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        // shape: const CircleBorder(),
        elevation: 10,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TextToSpeechScreen(),
            ),
          );
        },
        splashColor: AppColors.subTitle,
        backgroundColor: AppColors.iconBackground,
        child: Icon(
          Icons.add,
          color: AppColors.primary,
          size: 25,
        ),
      ),
      body: screens[_selectedIndex],
    );
  }
}
