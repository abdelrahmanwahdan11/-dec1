import 'dart:convert';

class JournalEntry {
  final String id;
  final String titleEn;
  final String titleAr;
  final String noteEn;
  final String noteAr;
  final DateTime createdAt;
  final String imageUrl;
  final String mood;
  final bool favorite;

  JournalEntry({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.noteEn,
    required this.noteAr,
    required this.createdAt,
    required this.imageUrl,
    required this.mood,
    this.favorite = false,
  });

  JournalEntry copyWith({bool? favorite}) {
    return JournalEntry(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      noteEn: noteEn,
      noteAr: noteAr,
      createdAt: createdAt,
      imageUrl: imageUrl,
      mood: mood,
      favorite: favorite ?? this.favorite,
    );
  }

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;
  String localizedNote(String code) => code == 'ar' ? noteAr : noteEn;

  Map<String, dynamic> toMap() => {
        'id': id,
        'titleEn': titleEn,
        'titleAr': titleAr,
        'noteEn': noteEn,
        'noteAr': noteAr,
        'createdAt': createdAt.toIso8601String(),
        'imageUrl': imageUrl,
        'mood': mood,
        'favorite': favorite,
      };

  static JournalEntry fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      titleEn: map['titleEn'] as String,
      titleAr: map['titleAr'] as String,
      noteEn: map['noteEn'] as String,
      noteAr: map['noteAr'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      imageUrl: map['imageUrl'] as String,
      mood: map['mood'] as String,
      favorite: map['favorite'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());
  static JournalEntry fromJson(String source) => fromMap(jsonDecode(source));
}
