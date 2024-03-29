import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
const names= [
  'Foo',
  'Bar',
  'Baz',
];
// extension for creating a extension to pick a random string in a list
extension RansommElement<T> on Iterable<T> {
  T getRandonElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
NamesCubit(): super(null);
void pickRandomNames() => emit(names.getRandonElement());
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NamesCubit cubit;
  @override
  void initState() {

    super.initState();
    cubit = NamesCubit();
  }
  @override
  void dispose() {
   cubit.close();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: StreamBuilder<String?>(
       stream: cubit.stream,
        builder: (context, snapshot){
         final button = TextButton(
           onPressed: () =>
             cubit.pickRandomNames(),

           child: Text('Pick a randon name'),
         );
         switch(snapshot.connectionState){
           case ConnectionState.none:
             return button;
           case ConnectionState.waiting:
            return button;
           case ConnectionState.active:
             return Column(
               children: [
                 Text(snapshot.data ?? ''),
                 button,
               ],
             );
           case ConnectionState.done:
            return const SizedBox();

         }
        },
      ),
    );
  }
}


