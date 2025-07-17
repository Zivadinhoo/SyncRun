// import 'package:flutter/material.dart';
// import 'package:frontend/features/models/training_day.dart';
// import 'package:frontend/features/onboarding/models/ai_plan.dart';
// import 'package:intl/intl.dart';

// class TrainingDayCard extends StatelessWidget {
//   final TrainingDay trainingDay;
//   final VoidCallback? onTap;

//   const TrainingDayCard({
//     super.key,
//     required this.trainingDay,
//     this.onTap,
//   });

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Icons.check_circle;
//       case 'missed':
//         return Icons.cancel;
//       default:
//         return Icons.schedule;
//     }
//   }

//   Color _getStatusColor(
//     BuildContext context,
//     String status,
//   ) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'missed':
//         return Colors.redAccent;
//       default:
//         return Theme.of(
//           context,
//         ).colorScheme.onSurface.withOpacity(0.5);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final formattedDate = DateFormat(
//       'EEE · MMM d',
//     ).format(trainingDay.date);

//     return Container(
//       margin: const EdgeInsets.symmetric(
//         horizontal: 8,
//         vertical: 6,
//       ),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: _getStatusColor(
//             context,
//             trainingDay.status,
//           ).withOpacity(0.3),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             _getStatusIcon(trainingDay.status),
//             color: _getStatusColor(
//               context,
//               trainingDay.status,
//             ),
//             size: 28,
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   trainingDay.title,
//                   style: theme.textTheme.titleMedium
//                       ?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(height: 4),
//                 if (trainingDay.description.isNotEmpty)
//                   Text(
//                     trainingDay.description,
//                     style: theme.textTheme.bodySmall
//                         ?.copyWith(
//                           color: theme
//                               .textTheme
//                               .bodySmall
//                               ?.color
//                               ?.withOpacity(0.7),
//                         ),
//                   ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.calendar_today,
//                       size: 14,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       formattedDate,
//                       style: theme.textTheme.bodySmall
//                           ?.copyWith(
//                             color: theme
//                                 .textTheme
//                                 .bodySmall
//                                 ?.color
//                                 ?.withOpacity(0.6),
//                           ),
//                     ),
//                     const SizedBox(width: 12),
//                     if (trainingDay.tss != null)
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.bolt,
//                             size: 14,
//                             color: Colors.orange,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'TSS ${trainingDay.tss!.toStringAsFixed(0)}',
//                             style: theme.textTheme.bodySmall
//                                 ?.copyWith(
//                                   color: theme
//                                       .textTheme
//                                       .bodySmall
//                                       ?.color
//                                       ?.withOpacity(0.6),
//                                 ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (!trainingDay.isCompleted && onTap != null)
//             IconButton(
//               icon: const Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 20,
//               ),
//               onPressed: onTap,
//               tooltip: 'Go to Training',
//               color: theme.colorScheme.primary,
//             ),
//         ],
//       ),
//     );
//   }
// }
