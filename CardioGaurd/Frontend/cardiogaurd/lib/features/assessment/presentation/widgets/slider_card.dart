import 'package:cardiogaurd/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BuildSliderCard extends StatefulWidget {
  final String title;
  final double initialValue;
  final String imgpath;
  final double min;
  final double max;
  final String unit;
  final bool badge;
  final double? minst;
  final double? maxst;
  final String? stableLabel;
  final String? unstableLabel;
  final Color? stableColor;
  final Color? unstableColor;
  final ValueChanged<double> onChangedTFF;
  final ValueChanged<double> onChangedsld;

  const BuildSliderCard({
    super.key,
    required this.title,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.unit,
    required this.badge,
    this.minst,
    this.maxst,
    this.stableLabel,
    this.unstableLabel,
    this.stableColor,
    this.unstableColor,
    required this.imgpath,
    required this.onChangedTFF,
    required this.onChangedsld,
  });

  @override
  State<BuildSliderCard> createState() => _BuildSliderCardState();
}

class _BuildSliderCardState extends State<BuildSliderCard> {
  late double currentValue;
  late bool isStable;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    _textController = TextEditingController(
      text: currentValue.toInt().toString(),
    );
    checkStability(currentValue);
  }

  void checkStability(double val) {
    if (widget.minst != null && widget.maxst != null) {
      setState(() {
        isStable = val >= widget.minst! && val <= widget.maxst!;
      });
    } else {
      setState(() {
        isStable = true;
      });
    }
  }

  void _updateValue(double newValue) {
    double clampedValue = newValue.clamp(widget.min, widget.max);

    setState(() {
      currentValue = clampedValue;
      _textController.text = clampedValue.toInt().toString();
      checkStability(clampedValue);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 238, 243, 247),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(widget.imgpath, width: 28, height: 28),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (widget.badge)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isStable
                        ? MyColors.mintBackground
                        : MyColors.alertBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        isStable
                            ? (widget.stableLabel ?? 'stable')
                            : (widget.unstableLabel ?? 'instable'),
                        style: TextStyle(
                          color: isStable
                              ? (widget.stableColor ?? MyColors.trendGreen)
                              : (widget.unstableColor ?? MyColors.alertRed),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isStable ? Icons.check_circle : Icons.crisis_alert,
                        size: 14,
                        color: isStable
                            ? (widget.stableColor ?? MyColors.trendGreen)
                            : (widget.unstableColor ?? MyColors.alertRed),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TEXT FIELD INPUT
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: MyColors.actionBlue,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    double? parsed = double.tryParse(val);
                    if (parsed != null) {
                      setState(() {
                        currentValue = parsed.clamp(widget.min, widget.max);
                        checkStability(currentValue);
                        widget.onChangedTFF(currentValue.toDouble());
                      });
                    }
                  },
                ),
              ),
              Text(
                widget.unit,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF1E3A8A).withOpacity(0.1),
              inactiveTrackColor: Colors.grey[200],
              thumbColor: const Color(0xFF1E3A8A),
              trackHeight: 6,
              overlayColor: const Color(0xFF1E3A8A).withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: currentValue.clamp(widget.min, widget.max),
              min: widget.min,
              max: widget.max,
              onChanged: (val) {
                _updateValue(val);
                widget.onChangedsld(currentValue.toDouble());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.min.toInt()}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  '${widget.max.toInt()}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:cardiogaurd/core/constants/my_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:cardiogaurd/presentation/screens/inputs.dart';

// class buildSliderCard extends StatefulWidget {
//   final String title;
//   double value;
//   final String imgpath;
//   final double min;
//   final double max;
//   final String unit;
//   final bool badge;
//   bool stable = true;
//   final double? minst;
//   final double? maxst;

//   buildSliderCard({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.min,
//     required this.max,
//     required this.unit,
//     required this.badge,
//     this.minst,
//     this.maxst, 
//     required this.imgpath,
//   });

//   @override
//   State<buildSliderCard> createState() => _buildSliderCardState();
// }

// class _buildSliderCardState extends State<buildSliderCard> {
//   void setStable(double? min, double? max, double? val) {
//     if (val != null && min != null && max != null) {
//       if (val >= double.parse(min.toString()) &&
//           val <= double.parse(max.toString()))
//         widget.stable = true;
//       else
//         widget.stable = false;
//     } else {
//       widget.stable = true;
//     }
//   }

//   TextEditingController inputnum = new TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 238, 243, 247),
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Image.asset(widget.imgpath, width: 28, height: 28),
//                   const SizedBox(width: 8),
//                   Text(
//                     widget.title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//               widget.badge
//                   ? Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: widget.stable
//                             ? MyColors.mintBackground
//                             : MyColors.alertBackground,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           Text(
//                             widget.stable ? 'stable' : 'instable',
//                             style: TextStyle(
//                               color: widget.stable
//                                   ? MyColors.trendGreen
//                                   : MyColors.alertRed,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Icon(
//                             widget.stable
//                                 ? Icons.check_circle
//                                 : Icons.crisis_alert,
//                             size: 14,
//                             color: widget.stable
//                                 ? MyColors.trendGreen
//                                 : MyColors.alertRed,
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '${widget.value.toInt()}',
//                 style: const TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: MyColors.actionBlue,
//                 ),
//               ),
//               // SizedBox(
//               //   width: 80,
//               //   child: TextFormField(
//               //     initialValue: '${widget.value.toInt()}',
//               //     style: TextStyle(
//               //       color: MyColors.actionBlue,
//               //       fontSize: 32,
//               //       fontWeight: FontWeight.bold,
//               //     ),
//               //     decoration: InputDecoration(
//               //       border: InputBorder.none,
//               //       contentPadding: EdgeInsets.symmetric(vertical: 0),
//               //     ),
//               //     keyboardType: TextInputType.number,
//               //     // controller: inputnum,
//               //     // onEditingComplete: () {
//               //     // widget.value = double.parse(inputnum.toString());
//               //     // setStable(widget.minst , widget.maxst , widget.value);
//               //     // },
//               //   ),
//               // ),
//               Text(
//                 widget.unit,
//                 style: TextStyle(color: Colors.grey[600], fontSize: 14),
//               ),
//             ],
//           ),
//           SliderTheme(
//             data: SliderThemeData(
//               activeTrackColor: const Color(0xFF1E3A8A).withOpacity(0.1),
//               inactiveTrackColor: Colors.grey[200],
//               thumbColor: const Color(0xFF1E3A8A),
//               trackHeight: 6,
//               overlayColor: const Color(0xFF1E3A8A),
//               thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
//             ),
//             child: Slider(
//               value: widget.value,
//               min: widget.min,
//               max: widget.max,
//               onChanged: (val) {
//                 setState(() {
//                   widget.value = val;
//                   setStable(widget.minst, widget.maxst, val);
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${widget.min.toInt()}',
//                   style: TextStyle(color: Colors.grey[400], fontSize: 12),
//                 ),
//                 Text(
//                   '${widget.max.toInt()}',
//                   style: TextStyle(color: Colors.grey[400], fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
