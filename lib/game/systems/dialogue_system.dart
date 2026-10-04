class DialogueLine {
  final String speaker;
  final String text;
  final String? choiceA;
  final String? choiceB;

  DialogueLine({
    required this.speaker,
    required this.text,
    this.choiceA,
    this.choiceB,
  });
}

class DialogueSystem {
  final Map<String, List<DialogueLine>> _dialogues = {
    'intro': [
      DialogueLine(
        speaker: 'الراوي',
        text: 'في عالم مليء بالظلام... بطل وحيد يقف ضد قوى الشر.',
      ),
      DialogueLine(
        speaker: 'البطل',
        text: 'سأستعيد النور... مهما كان الثمن!',
      ),
      DialogueLine(
        speaker: 'الراوي',
        text: 'هل أنت مستعد للرحلة؟',
        choiceA: 'نعم، هيا بنا!',
        choiceB: 'لست مستعدًا بعد',
      ),
    ],
  };

  List<DialogueLine>? getDialogue(String key) => _dialogues[key];
}
