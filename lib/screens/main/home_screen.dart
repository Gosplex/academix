import 'package:academix/constants/constants.dart';
import 'package:animated_flutter_widgets/animated_widgets/scroll_widget/animated_gridview_builder.dart';
import 'package:animated_flutter_widgets/enums/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../helpers/helper_functions.dart';
import '../../model/user_model.dart';
import '../ai/chat_screen.dart';
import 'courses_screen.dart';
import 'profile.dart';
import 'single_course_screen.dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  UserModel? userModel;
  bool isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -0.1, end: 0.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var user = firebaseAuth.currentUser;
      var data = await firestore
          .collection('AllUsers')
          .doc(user!.uid)
          .collection("profile")
          .get();

      if (data.docs.isNotEmpty) {
        userModel = UserModel.fromMap(data.docs.first.data());
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // List of Courses
  final List<String> courses = [
    'Calculus',
    'Digital Electronic',
    'Probability & Statistics',
    'Linear Algebra',
    'Programming In Python',
    'Web Technology',
    'Data Structures',
    'Operating Systems',
    'Computer Networks',
  ];

  final List<Color> colors = [
    Constants.primaryColor.withOpacity(0.8),
    Colors.deepPurple.withOpacity(0.8),
  ];

  void exitApp(BuildContext context) {
    SystemNavigator.pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: isLoading
          ? const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: Constants.primaryColor,
                  strokeCap: StrokeCap.round,
                ),
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                HelperFunctions.showConfirmationBottomSheet(
                  context,
                  onPressed1: () {
                    exitApp(context);
                  },
                  onPressed2: () {
                    Navigator.of(context).pop();
                  },
                  icon1: Icons.check,
                  icon2: Icons.clear,
                  title1: 'Yes',
                  title2: 'No',
                  message: 'Are you sure you want to exit?',
                );

                return false;
              },
              child: Scaffold(
                backgroundColor: Constants.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  surfaceTintColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  toolbarHeight: 100, // Adjust the height as needed
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey, ${userModel!.name}!',
                        style: Constants.heading1.copyWith(
                          color: Colors.black.withOpacity(0.9),
                          fontSize: 22,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What do you want to study today?',
                        style: Constants.body.copyWith(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ChatScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.chat_bubble_2,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.bell,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animation.value,
                          child: child,
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ProfileScreen(
                              user: userModel!,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CustomPaint(
                            painter: const DashedCirclePainter(
                                Constants.primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipOval(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(userModel!.photoUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 40.0,
                                  width: 40.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          // color: Constants.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: Constants.primaryColor.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.calendar_month,
                                color: Constants.primaryColor,
                                size: 60,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Learned Today',
                                      style: Constants.heading1.copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          '6/10 ',
                                          style: Constants.body.copyWith(
                                            color: Colors.black,
                                            fontSize: 28,
                                          ),
                                        ),
                                        Text(
                                          'minutes',
                                          style: Constants.body.copyWith(
                                            color: Colors.black,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DashedCircularProgressBar.aspectRatio(
                                aspectRatio: 0.7, // width ÷ height
                                valueNotifier: _valueNotifier,
                                progress: 60,
                                maxProgress: 100,
                                corners: StrokeCap.round,
                                animationDuration: const Duration(seconds: 4),
                                foregroundColor: Constants.primaryColor,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                foregroundStrokeWidth: 5,
                                backgroundStrokeWidth: 5,
                                animation: true,
                                child: Center(
                                  child: ValueListenableBuilder<double>(
                                    valueListenable: _valueNotifier,
                                    builder: (_, double value, __) => Text(
                                      '${value.toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Courses Section Starts Here
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Courses',
                              style: Constants.heading1.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                                letterSpacing: 1.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        CourseScreen(
                                      courses: courses,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                'View All',
                                style: Constants.body.copyWith(
                                  color: Constants.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Courses Section Ends Here
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AnimatedGridViewBuilder(
                          itemCount: courses.length > 6 ? 6 : courses.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio:
                                (size.height - 50 - 25) / (4 * 200),
                          ),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SingleCourseScreen(
                                          courses: courses[index],
                                        ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          var offsetAnimation =
                                              animation.drive(tween);

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Constants.primaryColor
                                          .withOpacity(0.05),
                                      border: Border.all(
                                        color: Constants.primaryColor
                                            .withOpacity(0.1),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/images/google_logo.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    courses[index],
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Constants.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down_circle,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                height: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Test Section Starts
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                        child: Text(
                          'Test Schedules',
                          style: Constants.heading1.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12.0, bottom: 10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/ai_robot.png',
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Let AI choose the best test for you!',
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //  Tabs Start
                      SizedBox(
                        height: 80,
                        child: AnimatedGridViewBuilder(
                          itemCount: colors.length,
                          animationType: ScrollWidgetAnimationType.fadeOut,
                          animationDuration: const Duration(milliseconds: 800),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio:
                                (size.height - 50 - 25) / (4 * 69),
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 70,
                              width: size.width * 0.45,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: colors[index].withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colors[index].withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Text(
                                      'Maths Test',
                                      style: Constants.body.copyWith(
                                        color: colors[index],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Container for type of test
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: colors[index],
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'MCQ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Constants.body.copyWith(
                                            color: Constants.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        CupertinoIcons.clock,
                                        color: Colors.grey[600],
                                        size: 18,
                                      ),
                                      Text(
                                        ' 30 mins',
                                        style: Constants.body.copyWith(
                                          color: colors[index].withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Tabs End

                      // // Banner
                      // Container(
                      //   height: 300,
                      //   width: size.width,
                      //   decoration: const BoxDecoration(
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/images/banner.jpg'),
                      //       fit: BoxFit.contain,
                      //     ),
                      //   ),
                      // ),
                      // // Banner Ends

                      // Recommended TextBooks
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended TextBooks',
                                  style: Constants.heading1.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4.0),
                                      child: Icon(
                                        CupertinoIcons.book,
                                        color: Constants.primaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Free Downloaded E-Books and PDFs',
                                      style: Constants.body.copyWith(
                                        color: Constants.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'View All',
                                style: Constants.body.copyWith(
                                  color: Constants.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Carousel
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 350,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return BookCard(size: size);
                          },
                        ),
                      ),
                      // Daily Tips
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                        child: Text(
                          'Daily Motivation',
                          style: Constants.heading1.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      // Motivation Container
                      FlutterCarousel(
                        options: CarouselOptions(
                          height: 200,
                          showIndicator: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 2),
                          viewportFraction: 1.0,
                          slideIndicator: const CircularSlideIndicator(
                            indicatorBackgroundColor: Constants.primaryColor,
                            indicatorBorderColor: Constants.primaryColor,
                            indicatorRadius: 4,
                          ),
                        ),
                        items: [1, 2, 3, 4, 5].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "“Success is not just about what you accomplish in your life; it's about what you inspire others to do. It's about pushing yourself beyond your limits, venturing into the unknown, and daring to dream the impossible.”",
                                        style: Constants.body.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Paul Halmos',
                                        style: Constants.body.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          // color: Constants.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: Constants.primaryColor.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tell Us what you think',
                                      style: Constants.heading3.copyWith()),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Help us improve our experience with your valuable feedback',
                                    style: Constants.body.copyWith(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Handle button press
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Text(
                                'Give Feedback',
                                style: Constants.body.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      const SizedBox(height: 20),
                      // Happy Studying
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Happy Studying!',
                            style: Constants.heading1.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 14,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),

                      //
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 300,
          width: size.width * 0.45,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Constants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(0),
            image: const DecorationImage(
              image: AssetImage('assets/images/book.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Book Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
          child: Text(
            'Calculus',
            style: Constants.body.copyWith(
              color: Constants.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Book Author
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Text(
            'James Stewart',
            style: Constants.body.copyWith(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  // Constructor
  const DashedCirclePainter(this.color);

  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    double gap = 10;
    double dashWidth = 5;

    for (double i = 0; i < 360; i += gap) {
      double startAngle = i * 3.14 / 180;
      double endAngle = (i + dashWidth) * 3.14 / 180;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
