// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/features/athlete/providers/selected_week_provider.dart';

// class WeekSectionWidget extends ConsumerStatefulWidget {
//   final int currentWeek;
//   final int totalWeeks;

//   const WeekSectionWidget({
//     super.key,
//     required this.currentWeek,
//     required this.totalWeeks,
//   });

//   @override
//   ConsumerState<WeekSectionWidget> createState() =>
//       _WeekSectionWidgetState();
// }

// class _WeekSectionWidgetState
//     extends ConsumerState<WeekSectionWidget> {
//   late final PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       initialPage: widget.currentWeek,
//     );
//   }

//   void _animateToWeek(int weekIndex) {
//     _pageController.animateToPage(
//       weekIndex,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//     ref.read(selectedWeekProvider.notifier).state =
//         weekIndex;
//   }

//   @override
//   void didUpdateWidget(
//     covariant WeekSectionWidget oldWidget,
//   ) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.currentWeek != widget.currentWeek) {
//       _pageController.jumpToPage(widget.currentWeek);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark =
//         Theme.of(context).brightness == Brightness.dark;

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _ArrowButton(
//           icon: Icons.chevron_left,
//           onTap:
//               widget.currentWeek > 0
//                   ? () =>
//                       _animateToWeek(widget.currentWeek - 1)
//                   : null,
//           isDark: isDark,
//         ),
//         Expanded(
//           child: SizedBox(
//             height: 32,
//             child: PageView.builder(
//               controller: _pageController,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.totalWeeks,
//               itemBuilder: (context, index) {
//                 return Center(
//                   child: Text(
//                     "Week ${index + 1} of ${widget.totalWeeks}",
//                     style: Theme.of(
//                       context,
//                     ).textTheme.labelLarge?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       letterSpacing: 0.5,
//                       color:
//                           isDark
//                               ? Colors.grey[200]
//                               : Colors.grey[800],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         _ArrowButton(
//           icon: Icons.chevron_right,
//           onTap:
//               widget.currentWeek < widget.totalWeeks - 1
//                   ? () =>
//                       _animateToWeek(widget.currentWeek + 1)
//                   : null,
//           isDark: isDark,
//         ),
//       ],
//     );
//   }
// }

// class _ArrowButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback? onTap;
//   final bool isDark;

//   const _ArrowButton({
//     required this.icon,
//     required this.onTap,
//     required this.isDark,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color:
//               onTap != null
//                   ? Colors.grey.withOpacity(0.15)
//                   : Colors.transparent,
//           shape: BoxShape.circle,
//         ),
//         padding: const EdgeInsets.all(8),
//         child: Icon(
//           icon,
//           size: 24,
//           color:
//               onTap != null
//                   ? (isDark ? Colors.white : Colors.black)
//                   : Colors.grey[400],
//         ),
//       ),
//     );
//   }
// }
