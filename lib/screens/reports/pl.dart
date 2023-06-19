import 'package:accouting_software/services/pl_statement_backend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../utils/utitlities.dart';
import '../home/home_screen.dart';

class PLStatement extends StatefulWidget {
  static const String routeName = "PLStatement";

  @override
  State<PLStatement> createState() => _PLStatementState();
}

class _PLStatementState extends State<PLStatement> {
  ValueNotifier<double> statementData = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    final ThemeData th = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: th.colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => HomeScreen()),
              (route) => false),
        ),
        title: Text(
          'P L\nS T A T E M E N T',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          MaterialButton(
            onPressed: null,
            child: Icon(
              Icons.download,
              color: th.colorScheme.secondary,
            ),
          )
        ],
      ),
      body: Container(
          color: th.primaryColor,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  Utilities().toastMessage(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final data = snapshot.data as Map<int, double>;
                  final yrs = data.keys;
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: OutlinedButton(
                                  onPressed: () {
                                    statementData.value =
                                        data[yrs.elementAt(index)] as double;
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    side: BorderSide(
                                        width: 0.5,
                                        color: th.colorScheme.secondary),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      yrs.elementAt(index).toString(),
                                      style: th.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: yrs.length,
                          ),
                        ),
                        Expanded(
                            child: ValueListenableBuilder(
                          builder: (context, value, child) {
                            return Center(child: Text(value.toString()));
                          },
                          valueListenable: statementData,
                        )),
                      ],
                    ),
                  );
                }
              }
              return const Center(
                child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white))),
              );
            },
            future: PLStatementBackend().getData(context),
          )),
    );
  }
}
