enum PetType { dog, cat, bird, rabbit }

class Pet {
  final String name;
  final PetType type;
  final int age;
  final String imagePath;

  Pet({
    required this.name, 
    required this.type, 
    required this.age, 
    required this.imagePath
  });
}