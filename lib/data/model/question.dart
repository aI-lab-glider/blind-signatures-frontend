class Question {
  int id;
  int pollID;
  String questionText;
  Map<String, int> answers;

  Question({
    required this.id,
    required this.pollID,
    required this.questionText,
    required this.answers
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> answersList = json["answer_set"]
        .split("; ")
        .map((item) => item.substring( 1, item.length-1))
        .toList().cast<String>();
    List<int> answersCountsList = json["answer_count"]
        .split("; ")
        .map((item) => item.substring( 1, item.length-1))
        .map((item) => int.tryParse(item) ?? 0)
        .toList().cast<int>();
    Map<String, int> answers = Map.fromIterables(answersList, answersCountsList);
    return Question(
        id: json["id"],
        pollID: json["poll"],
        questionText: json["question_text"],
        answers: answers);
  }
}