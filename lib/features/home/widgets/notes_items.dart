import 'package:echo_note/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesItems extends StatelessWidget {
  const NotesItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: AppColors.secondary,
        title: Text(
          "notes.title",
          style: GoogleFonts.mavenPro(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat.MMMMd().format(DateTime.now()),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
          ),
          color: Colors.redAccent,
        ),
        onTap: () {},
      ),
    );
  }
}
