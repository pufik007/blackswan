import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tensorfit/ui/pages/database.dart';
import 'package:tensorfit/ui/pages/firebase.dart';

import 'journey_bloc/user_data_type.dart';
import 'journey_bloc/user_gender_type.dart';

class ViewGenderPage extends StatefulWidget {
  @override
  _ViewGenderPageState createState() => _ViewGenderPageState();
}

class _ViewGenderPageState extends State<ViewGenderPage> {
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error initializing Firebase');
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                    ),
                    Text(
                      'About you',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Why are we asking this?'),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: GenderForm(
                        firstNameFocusNode: _firstNameFocusNode,
                        lastNameFocusNode: _lastNameFocusNode,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

class GenderForm extends StatefulWidget {
  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;

  GenderForm({
    this.firstNameFocusNode,
    this.lastNameFocusNode,
  });

  @override
  _GenderFormState createState() => _GenderFormState();
}

class _GenderFormState extends State<GenderForm> {
  Duration initialtimer = new Duration();
  int selectitem = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  // final TextEditingController _sexController = TextEditingController();

  final _controllerHeight = FixedExtentScrollController();
  final _controllerWeight = FixedExtentScrollController();
  final _controllerGender = FixedExtentScrollController();

  String _info(UserDataType dataType) {
    switch (dataType) {
      case UserDataType.Height:
        return ' sm';
      case UserDataType.Weight:
        return ' kg';
      default:
        return '';
    }
  }

  List<dynamic> _values(UserDataType dataType) {
    int minValue, maxValue;
    switch (dataType) {
      case UserDataType.DateOfBirth:
        minValue = 18;
        maxValue = 100;
        break;
      case UserDataType.Height:
        minValue = 120;
        maxValue = 240;
        break;
      case UserDataType.Weight:
        minValue = 40;
        maxValue = 120;
        break;
      case UserDataType.Gender:
        return UserGenderType.values;
    }
    var res = List<int>();
    for (int i = minValue; i <= maxValue; i++) {
      res.add(i);
    }
    return res;
  }

  Future<void> bottomSheet(BuildContext context, Widget child,
      {double height}) {
    return showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height / 3, child: child));
  }

  Widget datePicker() {
    return CupertinoDatePicker(
      initialDateTime: DateTime.now(),
      onDateTimeChanged: (DateTime newdate) {
        print(newdate);
        setState(() {
          date = newdate.month.toString() +
              '/' +
              newdate.day.toString() +
              '/' +
              newdate.year.toString() +
              ' ';
        });
      },
      use24hFormat: true,
      maximumDate: DateTime.now(),
      minimumYear: 1930,
      maximumYear: 2021,
      minuteInterval: 1,
      mode: CupertinoDatePickerMode.date,
    );
  }

  Widget weightPicker() {
    var items = _values(UserDataType.Weight).asMap();

    return CupertinoPicker.builder(
      scrollController: this._controllerWeight,
      itemExtent: 70,
      childCount: items.length,
      itemBuilder: (context, index) {
        return Center(
            child: Text('${items[index]}${this._info(UserDataType.Weight)}'));
      },
      onSelectedItemChanged: (int index) {
        setState(
          () {
            weight = '${items[index].toString()} kg';
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  Widget heightPicker() {
    var items = this._values(UserDataType.Height).asMap();

    return CupertinoPicker.builder(
      scrollController: this._controllerHeight,
      itemExtent: 70,
      childCount: items.length,
      itemBuilder: (context, index) {
        return Center(
            child: Text('${items[index]}${this._info(UserDataType.Height)}'));
      },
      onSelectedItemChanged: (int index) {
        setState(
          () {
            height = '${items[index].toString()} sm';
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  bool change = true;

  Widget sexPicker() {
    Map<num, String> dataType = {
      0: 'assets/genderPage/man.png',
      1: 'assets/genderPage/woman.png'
    };

    Map<num, String> _valuesSex = {0: 'man', 1: 'woman'};

    return CupertinoPicker.builder(
      scrollController: this._controllerGender,
      itemExtent: 100,
      childCount: 2,
      itemBuilder: (context, index) {
        return Center(
            child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/genderPage/man.png'),
            ),
          ],
        ));
      },
      onSelectedItemChanged: (int index) {
        setState(
          () {
            sex = '${_valuesSex[index].toString()}';
          },
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  String date;
  String weight;
  String height;
  String sex;
  bool imgWo = true;
  bool imgMa = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.text,
            controller: _nameController,
            focusNode: widget.firstNameFocusNode,
            decoration: InputDecoration(
              labelText: 'First Name',
            ),
            onChanged: (value) {},
          ),
          TextField(
            keyboardType: TextInputType.name,
            controller: _lastNameController,
            focusNode: widget.lastNameFocusNode,
            decoration: InputDecoration(
              labelText: 'Last Name',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: date == null ? 'Date' : '$date',
            ),
            focusNode: AlwaysDisabledFocusNode(),
            controller: _dateController,
            onTap: () {
              bottomSheet(context, datePicker());
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: height == null ? 'Height' : '$height',
            ),
            focusNode: AlwaysDisabledFocusNode(),
            controller: _heightController,
            onTap: () {
              bottomSheet(context, heightPicker());
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: weight == null ? 'Weight' : '$weight',
            ),
            focusNode: AlwaysDisabledFocusNode(),
            controller: _weightController,
            onTap: () {
              bottomSheet(context, weightPicker());
            },
          ),
          TextField(
              decoration: InputDecoration(
                labelText: sex == null ? 'Sex' : '$sex',
              ),
              focusNode: AlwaysDisabledFocusNode(),
              onTap: () {
                bottomSheet(context, sexPicker());
              }),
          ElevatedButton(
            onPressed: () async {
              widget.firstNameFocusNode.unfocus();
              widget.lastNameFocusNode.unfocus();

              await Database.addItem(
                firstName: _nameController.text,
                lastName: _lastNameController.text,
                date: date,
                height: height,
                weight: weight,
                gender: sex,
              );

              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
