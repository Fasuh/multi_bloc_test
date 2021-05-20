import 'package:flutter/material.dart';
import 'package:testing_ground/common/presentation/widget/any_changeable_button/any_changeable_button.dart';
import 'package:testing_ground/common/presentation/widget/pagewise.dart';
import 'package:testing_ground/test/test_bloc.dart';
import 'package:testing_ground/test/usecases/fetch_num_of_pages_use_case.dart';
import 'package:testing_ground/test/usecases/fetch_page_use_case.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TestBloc testBloc;

  @override
  void initState() {
    testBloc = TestBloc(
      anyFetchUseCase: FetchNumOfPagesUseCase(repository: 3),
      getListUseCase: FetchPageUseCase(repository: ['asdf']),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PagewiseBlocListView(
                bloc: testBloc,
                itemBuilder: (context, state) {
                  if (state is DataPagewiseState) {
                    return Container(
                      child: Text(state.element.toString()),
                    );
                  } else if (state is ErrorPagewiseState) {
                    return Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: AnyChangeableButton(
                button: Container(),
                bloc: testBloc,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    testBloc.close();
    super.dispose();
  }
}
