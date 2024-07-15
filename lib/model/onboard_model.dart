class OnboardModel {
  String title;
  String description;
  String imagePath;

  OnboardModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// List of OnboardModel

List<OnboardModel> onboardData = [
  OnboardModel(
    title: 'Welcome to Academix',
    description:
        'Academix is your ultimate college study companion. It integrates essential tools for exam preparation, curated study materials, and more.',
    imagePath: 'assets/images/1-onboard.png',
  ),
  // OnboardModel(
  //   title: 'Study Made Simple',
  //   description:
  //       'Streamline your learning with interactive tools and resources, including engaging quizzes for effective study reinforcement.',
  //   imagePath: 'assets/animations/2-onboard.json',
  // ),
  // OnboardModel(
  //   title: 'With In-App ChatGPT',
  //   description:
  //       'Get instant, accurate responses to your queries using in-app ChatGPT, a powerful AI chatbot that provides answers to your questions.',
  //   imagePath: 'assets/animations/3-onboard.json',
  // ),
];
