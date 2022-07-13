import 'package:flutter/material.dart';

import '../widgets/front_screen/about.dart';
import '../widgets/front_screen/login_form.dart';
import '../widgets/front_screen/signup_form.dart';

class HomeScreen extends StatefulWidget {
  static const String pageId = 'login-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping App'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Log In'),
              Tab(text: 'Sign Up'),
              Tab(text: 'About'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LoginForm(),
            SignupForm(),
            About(),
          ],
        ),
      ),
    );
  }
}
