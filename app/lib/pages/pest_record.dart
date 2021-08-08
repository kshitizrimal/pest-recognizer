class PestRecord {
  final int id;
  final String name;
  final String date;

  PestRecord({this.id, this.name, this.date});

  int get getId => this.id;
  String get getName => this.name;
  String get getDate => this.date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return '{id: $id, name: $name, date: $date}';
  }
}