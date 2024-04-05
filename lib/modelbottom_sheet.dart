import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelBottomSheet extends StatefulWidget {
  const ModelBottomSheet({Key? key}) : super(key: key);

  @override
  State<ModelBottomSheet> createState() => _ModelBottomSheetState();
}

class _ModelBottomSheetState extends State<ModelBottomSheet> {
  int _minutes = 30;
  int _hours = 00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
              child: Text("Timer:",
                  style: TextStyle(color: Colors.white, fontSize: 20))),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (_minutes > 0) {
                        _minutes--;
                      } else if (_hours > 0) {
                        _hours--;
                        _minutes = 59;
                      }
                    });
                  },
                  icon: const Icon(
                    CupertinoIcons.minus_circle,
                    color: Colors.white,
                    size: 40,
                  )),
              Text(
                  "${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      setState(() {
                        if (_hours < 99) {
                          if (_minutes == 59) {
                            _hours++;
                            _minutes = 0;
                          } else {
                            _minutes++;
                          }
                        }
                      });
                    });
                  },
                  icon: const Icon(
                    CupertinoIcons.plus_circle,
                    color: Colors.white,
                    size: 40,
                  ))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              String number =
                  "${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}";
              Navigator.pop(context, number);
            },
            child: Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text("SET TIMER",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Not Now"))
        ],
      ),
    );
  }
}
