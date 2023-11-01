class Character {
  final String name, movieName, description, image, logo;
  final int color;
  final List<String> clips;

  Character(
      {required this.name,
      required this.logo,
      required this.movieName,
      required this.description,
      required this.image,
      required this.color,
      required this.clips});
}
