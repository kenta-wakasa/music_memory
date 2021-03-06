import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_memory/models/experiment.dart';
import 'package:music_memory/repositories/repository.dart';
import 'package:music_memory/repositories/user_data.dart';
import 'package:music_memory/utils/utils.dart';
import 'package:music_memory/widgets/instruction_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseの初期化
  await Firebase.initializeApp();
  runApp(const MyApp());
}

const locale = Locale("ja", "JP");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData();
    return MaterialApp(
      title: 'Music Memory',
      locale: locale,
      // 中華フォント対策
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [locale],
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.notoSansTextTheme(
          baseTheme.textTheme.copyWith(
            bodyText1: baseTheme.textTheme.bodyText1!.copyWith(fontSize: 18),
            bodyText2: baseTheme.textTheme.bodyText2!.copyWith(fontSize: 14),
            headline5: baseTheme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            headline6: baseTheme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        // AppBar
        appBarTheme: AppBarTheme(
          toolbarHeight: 48,
          centerTitle: true,
          // backwardsCompatibility: false,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.blue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 9,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        cardTheme: const CardTheme(
          elevation: 1,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('実験選択'),
      ),
      body: StreamBuilder<List<Experiment>>(
        stream: Repository.streamExperiment(),
        builder: (context, snapshot) {
          final experimentList = snapshot.data;
          if (experimentList == null) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return ListView.builder(
            itemCount: experimentList.length,
            itemBuilder: (context, index) {
              final experiment = experimentList[index];
              return SizedBox(
                height: 120,
                child: Card(
                  child: InkWell(
                    onTap: () async {
                      UserData.instance.init(experiment);
                      pushPage(
                        context,
                        InstructionPage(experiment: experiment),
                      );
                    },
                    child: Center(
                      child: Text(
                        experiment.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
