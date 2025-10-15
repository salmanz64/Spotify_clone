import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodal/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();

  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    songNameController.dispose();
    artistController.dispose();
  }

  Color selectedColor = Pallete.cardColor;
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((val) => val?.isLoading == true),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Song"),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedAudio != null &&
                  selectedImage != null) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .uploadSong(
                      selectedThumbnail: selectedImage!,
                      selectedAudio: selectedAudio!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      selectedColor: selectedColor,
                    );
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body:
          isLoading
              ? const Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        selectedImage != null
                            ? SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            : GestureDetector(
                              onTap: selectImage,
                              child: DottedBorder(
                                options: RectDottedBorderOptions(
                                  color: Pallete.borderColor,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: [10, 5],
                                  padding: EdgeInsets.all(16),
                                ),

                                child: SizedBox(
                                  height: 120,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.folder_open, size: 40),
                                      Text("Select the Thumbnail to your song"),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                        SizedBox(height: 40),
                        selectedAudio != null
                            ? AudioWave(path: selectedAudio!.path)
                            : CustomField(
                              hintText: 'Pick Song',
                              readOnly: true,
                              onTap: selectAudio,
                              controller: songNameController,
                            ),
                        SizedBox(height: 20),
                        CustomField(
                          hintText: 'Artist',
                          controller: artistController,
                        ),
                        SizedBox(height: 20),
                        CustomField(
                          hintText: 'Song Name',
                          controller: songNameController,
                        ),
                        SizedBox(height: 20),
                        ColorPicker(
                          pickersEnabled: {ColorPickerType.wheel: true},
                          onColorChanged: (color) {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          color: selectedColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
