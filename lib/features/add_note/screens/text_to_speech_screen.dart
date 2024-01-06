import 'package:avatar_glow/avatar_glow.dart';
import 'package:echo_note/features/home/bloc/home_bloc.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextToSpeechScreen extends StatefulWidget {
  static const routeName = '/text-to-speech-screen';
  final HomeBloc homeBloc;

  const TextToSpeechScreen({super.key, required this.homeBloc});
  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _enableTyping = false;
  // bool _didChange = true;
  bool _isLoading = false;
  // bool _isFavourite = false;
  // String _id = '';

  void _startListening() async {
    if (!_speechEnabled) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _speechEnabled = true;
          _speechToText.listen(
            cancelOnError: true,
            onResult: (result) {
              setState(() {
                _descriptionController.text = result.recognizedWords;
              });
            },
          );
        });
      }
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  // @override

  // void showDialogMessage() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('An error Occured!'),
  //         content: const Text('Something went wrong!'),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Okay!'),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  void saveAndClose() {
    if (_titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty) {
      NoteModel note = NoteModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dateTime: DateTime.now(),
      );
      widget.homeBloc.add(HomeAddNoteSavedEvent(note: note));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocus = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Note', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: AppColors.secondary,
        actions: [
          IconButton(
            onPressed: saveAndClose,
            icon: Image.asset(
              'assets/icons/save_icon.png',
              height: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        label: 'Title',
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(height: 20),
                      customContainer(
                        child: TextField(
                          style: Theme.of(context).textTheme.labelLarge,
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Add a new title',
                            focusColor: Colors.white,
                            border: _border,
                            focusedBorder: _border,
                            enabledBorder: _border,
                          ),
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            label: 'Description',
                            color: Colors.black,
                            size: 20,
                          ),
                          Column(
                            children: [
                              Switch(
                                activeColor: AppColors.primary,
                                inactiveTrackColor: AppColors.background,
                                activeTrackColor: AppColors.iconBackground,
                                trackOutlineColor:
                                    MaterialStatePropertyAll(AppColors.primary),
                                value: _enableTyping,
                                onChanged: (value) {
                                  setState(() {
                                    _enableTyping = value;
                                  });
                                },
                              ),
                              customText(
                                label: 'Enable Typing',
                                color: AppColors.subTitle,
                                size: 12,
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      customContainer(
                        child: TextField(
                          style: Theme.of(context).textTheme.labelLarge,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Add Description by (voice/type)',
                            focusColor: Colors.white,
                            border: _border,
                            focusedBorder: _border,
                            enabledBorder: _border,
                          ),
                          maxLines: 10,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          readOnly: !_enableTyping,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (isFocus && !_enableTyping)
          ? AvatarGlow(
              glowShape: BoxShape.circle,
              animate: _speechEnabled,
              glowColor: AppColors.iconBackground,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              startDelay: const Duration(microseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                color: Colors.transparent,
                child: GestureDetector(
                  onTapDown: (_) => _startListening(),
                  onTapUp: (_) => _stopListening(),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      _speechEnabled ? Icons.mic : Icons.mic_none,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget customText({
    required String label,
    required Color color,
    required double size,
  }) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
        fontSize: size,
      ),
    );
  }

  Widget customContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: child,
    );
  }

  final OutlineInputBorder _border = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primary),
    borderRadius: const BorderRadius.all(Radius.circular(15)),
  );
}
