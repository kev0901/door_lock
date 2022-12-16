class Player {
  Player(String name, int age, int stat) {
    this.name = name;
    this.age = age;
    this.stat = stat;
  }

  Player(this.name, this.age, this.stat);

  void StrengthOnly() {
    print(this.stat);
  }
  String name;
  int age;
  int stat;
}

void main() {
  const a = Player('Kevin', 24, 7);
  a.StrengthOnly();
}
