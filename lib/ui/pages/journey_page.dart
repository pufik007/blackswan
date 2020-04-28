import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/api/entities/goal.dart';
import 'package:tensorfit/data/app_bloc/app_bloc.dart';
import 'package:tensorfit/ui/pages/journey_bloc/bloc.dart';
import 'package:tensorfit/ui/widgets/login_adapt.dart';

import 'journey_bloc/user_data_type.dart';
import 'journey_bloc/user_gender_type.dart';

class JourneyPage extends StatelessWidget {
  var _controller = FixedExtentScrollController();

  final bool fillUserData;
  final bool isReset;

  JourneyPage(this.fillUserData, this.isReset);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JourneyBloc(
        BlocProvider.of<AppBloc>(context),
        this.fillUserData,
        DateTime.now(),
        60,
        170,
        UserGenderType.Male,
        [],
      ),
      child: LoginAdapt(
        child: this._buildBody(context),
        minAspectRatio: 0.8,
        bgSVGFileName: 'assets/journey/bg.svg',
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var theme = Theme.of(context);
    theme = theme.copyWith(
      accentColor: theme.dialogBackgroundColor,
      /*
      cupertinoOverrideTheme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          pickerTextStyle: TextStyle(color: Colors.blue, fontSize: 12),
        ),
      ),
       */
    );

    return Theme(
      data: theme,
      child: BlocBuilder<JourneyBloc, JourneyState>(
        builder: (context, state) {
          if (state is JourneyDataState) {
            return this._buildUserData(context, state);
          }

          if (state is JourneyGoalState) {
            return this._buildUserGoal(context, state);
          }

          return null;
        },
      ),
    );
  }

  Widget _buildUserData(BuildContext context, JourneyDataState state) {
    var theme = Theme.of(context);

    var selectWidget;
    switch (state.type) {
      case UserDataType.DateOfBirth:
        selectWidget = CupertinoDatePicker(
          initialDateTime: state.dateOfBirth ?? DateTime.now(),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime value) {
            BlocProvider.of<JourneyBloc>(context).add(SelectDateOfBirth(value));
          },
        );
        break;
      case UserDataType.Height:
        var items = this._values(UserDataType.Height);
        if (state.jump) {
          // ignore: invalid_use_of_protected_member
          if (this._controller.positions.length > 0) {
            this._controller.jumpToItem(items.indexOf(state.height));
          } else {
            this._controller = FixedExtentScrollController(initialItem: items.indexOf(state.height));
          }
        }
        selectWidget = Container(
          width: 85,
          child: CupertinoPicker.builder(
            scrollController: this._controller,
            itemExtent: 70,
            childCount: items.length,
            itemBuilder: (context, index) {
              return Center(child: Text('${items[index]}${this._info(UserDataType.Height)}'));
            },
            onSelectedItemChanged: (int index) {
              BlocProvider.of<JourneyBloc>(context).add(SelectHeight(items[index]));
            },
            backgroundColor: Colors.transparent,
          ),
        );
        break;
      case UserDataType.Weight:
        var items = this._values(UserDataType.Weight);
        if (state.jump) {
          // ignore: invalid_use_of_protected_member
          if (this._controller.positions.length > 0) {
            this._controller.jumpToItem(items.indexOf(state.weight));
          } else {
            this._controller = FixedExtentScrollController(initialItem: items.indexOf(state.weight));
          }
        }
        selectWidget = Container(
          width: 85,
          child: CupertinoPicker.builder(
            scrollController: this._controller,
            itemExtent: 70,
            childCount: items.length,
            itemBuilder: (context, index) {
              return Center(child: Text('${items[index]}${this._info(UserDataType.Weight)}'));
            },
            onSelectedItemChanged: (int index) {
              BlocProvider.of<JourneyBloc>(context).add(SelectWeight(items[index]));
            },
            backgroundColor: Colors.transparent,
          ),
        );
        break;
      case UserDataType.Gender:
        var items = this._values(UserDataType.Gender);
        if (state.jump) {
          // ignore: invalid_use_of_protected_member
          if (this._controller.positions.length > 0) {
            this._controller.jumpToItem(items.indexOf(state.gender));
          } else {
            this._controller = FixedExtentScrollController(initialItem: items.indexOf(state.gender));
          }
        }
        selectWidget = Container(
          width: 85,
          child: CupertinoPicker.builder(
            scrollController: this._controller,
            itemExtent: 70,
            childCount: items.length,
            itemBuilder: (context, index) {
              return Center(child: Text(this._gender(items[index])));
            },
            onSelectedItemChanged: (int index) {
              BlocProvider.of<JourneyBloc>(context).add(SelectGender(items[index]));
            },
            backgroundColor: Colors.transparent,
          ),
        );
        break;
    }

    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.dialogBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.focusColor,
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                        offset: Offset(1.0, 3.0),
                      )
                    ],
                  ),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      heightFactor: 0.925,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(this._title(state.type), style: theme.textTheme.subhead),
                                SizedBox(height: 20),
                                Text(this._description(state.type), style: theme.textTheme.body1),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: selectWidget,
                            ),
                          ),
                          this._userDataButton(context, state.type == UserDataType.Gender),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.075,
            child: Center(
              child: DotsIndicator(
                axis: Axis.vertical,
                dotsCount: 4,
                position: UserDataType.values.indexOf(state.type).toDouble(),
                decorator: DotsDecorator(
                  color: theme.focusColor,
                  activeColor: theme.unselectedWidgetColor,
                  spacing: EdgeInsets.all(10.0),
                ),
              ),
            ),
          )
        ],
      ),
      onWillPop: () async {
        if (state.type != UserDataType.values.first) {
          BlocProvider.of<JourneyBloc>(context).add(Prev());
          return false;
        } else {
          return true;
        }
      },
    );
  }

  Widget _buildUserGoal(BuildContext context, JourneyGoalState state) {
    var theme = Theme.of(context);

    return WillPopScope(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('What dreams will we embody?', style: theme.textTheme.title),
                  this._buildGoals(context, state),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: state.valid
                  ? () {
                      BlocProvider.of<JourneyBloc>(context).add(CreateJourney());
                      if (this.isReset) {
                        Navigator.pop(context);
                      }
                    }
                  : null,
              child: Text('Start'),
            ),
          ),
        ],
      ),
      onWillPop: () async {
        if (state.changeUserData) {
          BlocProvider.of<JourneyBloc>(context).add(Prev());
          return false;
        } else {
          return true;
        }
      },
    );
  }

  Widget _buildGoals(BuildContext context, JourneyGoalState state) {
    return AspectRatio(
      aspectRatio: 1,
      child: FractionallySizedBox(
        widthFactor: 0.95,
        heightFactor: 0.95,
        child: LayoutBuilder(
          builder: (context, constraints) {
            var size = constraints.maxHeight * 0.3;
            var center = (constraints.maxHeight - size) / 2;
            var leverage = constraints.maxHeight * 0.33;

            var buttons = List<Widget>();

            var goal = state.goals[0];
            buttons.add(Container(
              margin: EdgeInsets.only(
                left: center,
                top: center,
              ),
              width: size,
              height: size,
              child: this._buildGoal(context, goal, state.selectedGoals.contains(goal.id), state.selectGoals),
            ));
            for (var i = 1; i < 6; i++) {
              goal = state.goals[i];
              buttons.add(Container(
                margin: EdgeInsets.only(
                  left: center + sin(pi * 0.4 * (i - 1)) * leverage,
                  top: center - cos(pi * 0.4 * (i - 1)) * leverage,
                ),
                width: size,
                height: size,
                child: this._buildGoal(context, goal, state.selectedGoals.contains(goal.id), state.selectGoals),
              ));
            }

            return Stack(
              children: buttons,
            );
          },
        ),
      ),
    );
  }

  Widget _buildGoal(BuildContext context, Goal goal, bool selected, bool enabled) {
    var theme = Theme.of(context);

    return RawMaterialButton(
      fillColor: selected ? theme.buttonColor : Colors.grey[300],
      shape: CircleBorder(),
      elevation: 0.0,
      child: Text(
        goal.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? Colors.grey[300] : (enabled ? theme.buttonColor : Colors.grey),
        ),
      ),
      onPressed: enabled || selected
          ? () {
              if (selected) {
                BlocProvider.of<JourneyBloc>(context).add(DeselectGoal(goal.id));
              } else {
                BlocProvider.of<JourneyBloc>(context).add(SelectGoal(goal.id));
              }
            }
          : null,
    );
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

  String _title(UserDataType dataType) {
    switch (dataType) {
      case UserDataType.DateOfBirth:
        return 'Date of birth';
      case UserDataType.Height:
        return 'Height';
      case UserDataType.Weight:
        return 'Weight';
      case UserDataType.Gender:
        return 'Gender';
      default:
        return null;
    }
  }

  String _description(UserDataType dataType) {
    switch (dataType) {
      case UserDataType.Height:
        return 'You can specify an aproximate height.';
      case UserDataType.Weight:
        return 'You can specify an aproximate weight.';
      default:
        return '';
    }
  }

  String _gender(UserGenderType dataType) {
    switch (dataType) {
      case UserGenderType.Male:
        return 'Male';
      case UserGenderType.Female:
        return 'Female';
      case UserGenderType.Common:
        return 'Common';
      default:
        return null;
    }
  }

  Widget _userDataButton(BuildContext context, bool isLast) {
    Widget child;
    if (isLast) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Next'),
          SizedBox(width: 10),
          SvgPicture.asset('assets/journey/next_active.svg', width: 40),
        ],
      );
    } else {
      child = SvgPicture.asset('assets/journey/next_active.svg', width: 40);
    }

    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        if (isLast) {
          BlocProvider.of<JourneyBloc>(context).add(UpdateUser());
        } else {
          BlocProvider.of<JourneyBloc>(context).add(Next());
        }
      },
      child: child,
    );
  }
}