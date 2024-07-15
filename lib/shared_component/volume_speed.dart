import 'package:flutter/material.dart';

class VolumeSpeed extends StatelessWidget {
  num dataEx;
  Function setData;
  String type;
  List<ButtonSegment<double>> data;
  VolumeSpeed(
      {super.key,
      required this.dataEx,
      required this.setData,
      required this.type,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$type :",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(0, 2), blurRadius: 1)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SegmentedButton(
                selectedIcon: const Icon(
                  Icons.check,
                  color: Colors.blueGrey,
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.grey
                            .shade300; // Background color for selected segment
                      }
                      return Colors.grey
                          .shade400; // Background color for unselected segments
                    },
                  ),
                ),
                onSelectionChanged: (values) {
                  setData(values);
                },
                segments: data,
                selected: {dataEx}),
          ),
        ],
      ),
    );
  }
}
