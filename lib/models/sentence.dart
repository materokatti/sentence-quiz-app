class Sentence {
  final int? id;
  final String nativeSentence;
  final String answer;

  Sentence({
    this.id,
    required this.nativeSentence,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nativeSentence': nativeSentence,
      'answer': answer,
    };
  }

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map['id'] as int?,
      nativeSentence: map['nativeSentence'] as String,
      answer: map['answer'] as String,
    );
  }
}
