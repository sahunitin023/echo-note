import 'package:avatar_glow/avatar_glow.dart';
import 'package:echo_note/features/home/bloc/home_bloc.dart';
import 'package:echo_note/models/note_model.dart';
import 'package:echo_note/utility/constants.dart';
import 'package:echo_note/utility/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextToSpeechScreen extends StatefulWidget {
  static const routeName = '/text-to-speech-screen';
  final HomeBloc homeBloc;
  final bool isUpdateScreen;

  const TextToSpeechScreen(
      {super.key, required this.homeBloc, this.isUpdateScreen = false});
  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool available = false;
  bool _speechEnabled = false;
  bool _enableTyping = false;
  bool _didChange = true;
  String lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    bool isInitiated = await _speechToText.initialize();
    setState(() {
      available = isInitiated;
    });
  }

  void _startListening() async {
    final options = SpeechListenOptions(
      cancelOnError: true,
      autoPunctuation: true,
      // partialResults: true,
      enableHapticFeedback: true,
      // listenMode: ListenMode.dictation,
    );
    if (!_speechEnabled) {
      if (available) {
        setState(() {
          _speechEnabled = true;
        });
        _speechToText.listen(
          listenOptions: options,
          onResult: (result) {
            setState(() {
              _descriptionController.text = result.recognizedWords;
            });
            if (result.finalResult) {
              _stopListening();
            }
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please Allow access to Microphone!!'),
            backgroundColor: AppColors.favourite,
            action: SnackBarAction(
              label: 'Allow',
              onPressed: () => _initSpeech(),
            ),
          ),
        );
      }
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_didChange) {
      final info = ModalRoute.of(context)?.settings.arguments;
      if (info != null) {
        final infoMap = info as NoteModel;
        _titleController.text = infoMap.title;
        _descriptionController.text = infoMap.description;
      }
      _didChange = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _speechToText.cancel();
    super.dispose();
  }

  void saveAndClose() {
    if (_titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty) {
      NoteModel newNote = NoteModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dateTime: DateTime.now(),
      );
      if (widget.isUpdateScreen) {
        NoteModel oldNote =
            ModalRoute.of(context)?.settings.arguments as NoteModel;
        newNote.isFavourite = oldNote.isFavourite;
        widget.homeBloc.add(
          HomeNoteUpdateEvent(
            oldNote: oldNote,
            newNote: newNote,
          ),
        );
        Navigator.pop(context);
      } else {
        widget.homeBloc.add(HomeAddNoteSavedEvent(note: newNote));
      }
      Navigator.pop(context);
      SnackBarWidget(
        context: context,
        label:
            'Note ${widget.isUpdateScreen ? "updated" : "added"} successfully',
        color: Colors.grey[200]!,
      ).show();
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
      body: SingleChildScrollView(
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
                  onTap: () =>
                      _speechEnabled ? _stopListening() : _startListening(),
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
