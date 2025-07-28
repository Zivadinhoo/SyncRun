// class TrainingDay {
//   final int id;
//   final String? name; // npr: "Easy Run"
//   final String? description; // "Run 5km at easy pace"
//   final double? distance; // 5.0
//   final int? duration; // u minutima
//   final DateTime? date;

//   TrainingDay({
//     required this.id,
//     this.name,
//     this.description,
//     this.distance,
//     this.duration,
//     this.date,
//   });

//   factory TrainingDay.fromJson(Map<String, dynamic> json) {
//     return TrainingDay(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       distance: (json['distance'] as num?)?.toDouble(),
//       duration: json['duration'] as int?,
//       date:
//           json['date'] != null
//               ? DateTime.parse(json['date'])
//               : null,
//     );
//   }
// }
