class AboutMeData {
  final String about;

  AboutMeData(this.about);

  Map<String, dynamic> toJson() {
    return {
      'About': about,
    };
  }
}
