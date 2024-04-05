import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibrate/extraa.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration_type/util/enum/enuns_vibrations.dart';
import 'package:vibration_type/vibration_type.dart';

import 'modelbottom_sheet.dart';

class Vibrationss extends StatefulWidget {
  const Vibrationss({Key? key}) : super(key: key);

  @override
  State<Vibrationss> createState() => _VibrationssState();
}

class _VibrationssState extends State<Vibrationss> {
  bool play = false;
  bool isstackup = false;
  int selectedButtonIndex = 0;

  AudioPlayer audioPlayer = AudioPlayer();

  List<String> buttonLabels = [
    "Breeze",
    "Heart Beat",
    "Waves",
    "Monsoon",
    "Volcano",
    "Tsunami",
    "Tornado",
    "Lava",
    "Storm"
  ];

  List<List<int>> vibrationPatterns = [
    [100, 49, 30, 0, 35, 20, 30, 0, 49, 20, 49, 20, 30, 0, 100, 332],
    [100, 200, 800, 0],
    [100, 102, 100, 0, 150, 303, 100, 0, 49, 983, 100, 0, 100, 332],
    [500, 1000, 800, 1500, 800, 2000, 500, 2500, 800, 3000],
    [500, 1000, 500, 1500, 500, 2000, 500, 2500, 500, 3000],
    [500, 400, 500, 4000, 200, 2000, 250, 1000, 100, 200],
    [50, 100, 150, 300, 450, 900, 750, 1500, 1100, 2500, 800, 50],
    [50, 50, 150, 70, 450, 500, 750, 150, 1100, 1500, 800, 300],
    [400, 500, 150, 40, 750, 1000, 450, 30, 1100, 1500, 30, 50],
  ];

  void vibratePattern(int index) {
    Vibration.vibrate(
      pattern: vibrationPatterns[index],
      repeat: 1,
    );
  }

  int selectedIndex = 0;

  // void handleSelection(int index) {
  //   setState(() {
  //     if (selectedIndex == index) {
  //       selectedIndex = 0;
  //     } else {
  //
  //       selectedIndex = index;
  //     }
  //   });
  // }

  int intensity = 0;

  void handleSelection(int index) {
    setState(() {
      selectedIndex = index;
      if (selectedIndex == 0) {
        intensity = 70;
      } else if (selectedIndex == 1) {
        intensity = 150;
      } else if (selectedIndex == 2) {
        intensity = 255;
      }
    });
  }

  Widget buildButton(int index, String text) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        handleSelection(index);
        print("$intensity Hello na jane number likho");
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: isSelected ? Colors.red : Colors.red.shade900,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    audioPlayer.setSourceAsset("audio/audiobuddha.mp3");
    VibrationType().impactVibration(ImpactVibrationType.soft);
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    Vibration.cancel();
    super.dispose();
  }

  String timer = "";
  bool status1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Vibrate"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isstackup = !isstackup;
                });
              },
              child: Icon(
                  !isstackup ? CupertinoIcons.lock_open_fill : Icons.lock,
                  color: isstackup ? Colors.red : Colors.black,
                  size: 30),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      play = !play;
                    });
                    if (play) {
                      if (timer.isEmpty) {
                        vibratePattern(selectedButtonIndex);
                      } else {
                        vibratePattern(selectedButtonIndex);
                        int hour = int.parse(timer.split(":")[0]);
                        int minute = int.parse(timer.split(":")[1]);
                        Future.delayed(
                          Duration(hours: hour, minutes: minute),
                          () {
                            Vibration.cancel();
                            setState(() {
                              play = false;
                            });
                          },
                        );
                      }
                      setState(() {});
                    } else {
                      Vibration.cancel();
                    }
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(75),
                    ),
                    child: Icon(
                      play ? Icons.pause : CupertinoIcons.power,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () async {
                      final valueof = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            height: 300,
                            child: const ModelBottomSheet(),
                          );
                        },
                      );
                      setState(() {
                        timer = valueof;
                      });
                    },
                    child: Text(timer.isEmpty ? "Set Timer" : timer)),
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black12, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Music",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            status1 = !status1;
                          });
                          if (status1) {
                            audioPlayer.play(AssetSource(
                                "audio/audiobuddha.mp3"));
                          } else {
                            audioPlayer.stop();
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 35,
                          decoration: BoxDecoration(
                              color: status1 ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(30)),
                          child: Align(
                            alignment: status1
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: CircleAvatar(
                                backgroundColor:
                                    status1 ? Colors.white : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "INTENSITY",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton(0, "Soft"),
                    buildButton(1, "Medium"),
                    buildButton(2, "Hard"),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "MODES",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => TrackPad(),));
                }, child: Text("trancpade")),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                    ),
                    itemCount: buttonLabels.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Vibration.cancel();
                              setState(() {
                                play = false;
                                selectedButtonIndex = index;
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: selectedButtonIndex == index
                                    ? Colors.red
                                    : Colors.red.shade800,
                                borderRadius: BorderRadius.circular(75),
                                border: Border.all(
                                  color: selectedButtonIndex == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              buttonLabels[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Visibility(
                visible: isstackup,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black26,
                ))
          ],
        ),
      ),
    );
  }
  void callNativeMethod() async {
    // Call the platform method via the method channel
    try {
      // Invoke the platform method
      await VibrationService.vibrate(50);
    } on PlatformException catch (e) {
      // Handle any platform exceptions
      print("Failed to call native method: ${e.message}");
    }
  }
}
class VibrationService {
  static const MethodChannel _channel = MethodChannel('vibration');

  static Future<void> vibrate(double intensity) async {
    try {
      await _channel.invokeMethod('vibrate', {'intensity': intensity});
    } on PlatformException catch (e) {
      // Handle platform exceptions (e.g., permission errors)
      print("Error vibrating: ${e.message}");
    }
  }
}

