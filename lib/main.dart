import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final signIn = GoogleSignIn();
  GoogleSignInAccount? account;

  @override
  void initState() {
    _checkSignIn();
    super.initState();
  }

  Future<void> _checkSignIn() async {
    if (await signIn.isSignedIn()) {
      var result = await signIn.signInSilently();
      setState(() {
        account = result;
      });
    }
  }

  Future<void> _signIn() async {
    var result = await signIn.signIn();
    setState(() {
      account = result;
    });
  }

  Future<void> _signOut() async {
    var result = await signIn.signOut();
    setState(() {
      account = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? bodyWidget;
    if (account == null) {
      bodyWidget = ElevatedButton(
        onPressed: () => _signIn(),
        child: const Text("구글 로그인"),
      );
    } else {
      bodyWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AccountWidget(account: account!),
          ElevatedButton(
            onPressed: () => _signOut(),
            child: const Text("구글 로그아웃"),
          )
        ],
      );
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: bodyWidget,
        ),
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({Key? key, required this.account}) : super(key: key);
  final GoogleSignInAccount account;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(account.photoUrl ?? ""),
        const SizedBox(height: 8),
        Text(account.displayName ?? "NONAME"),
      ],
    );
  }
}
