import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';

import 'map_bloc/bloc.dart';

class MapWidget extends StatelessWidget {
  final List<Image> leftImages;
  final List<Image> leftImagesH;
  final List<Image> rightImages;
  final List<Image> rightImagesH;

  const MapWidget(
    this.leftImages,
    this.leftImagesH,
    this.rightImages,
    this.rightImagesH,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      bloc: BlocProvider.of<MapBloc>(context),
      builder: (context, state) {
        if (state is MapInit || state is MapLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MapLoaded) {
          return this._getMap(state.levels, state.selectedLevelID);
        }

        return null;
      },
    );
  }

  Widget _getMap(List<Level> levels, int selectedLevelID) {
    var size = 30.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          reverse: true,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size,
              ),
              this._getLevels(constraints.maxWidth, levels, selectedLevelID),
              SizedBox(
                height: size * 2 + 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getLevels(double width, List<Level> levels, int selectedLevelID) {
    var items = List<Widget>();

    var houseCount = levels.length;

    for (int i = houseCount; i > 0; i--) {
      var num = i - 1;
      var level = levels[num % levels.length];
      items.add(this._getLevel(
          level, num % 6, num % 2 == 1, level.id == selectedLevelID));
    }

    return Stack(
      children: <Widget>[
        CustomPaint(
          size: Size(width, width * levels.length / 2),
          painter: _RoadPainter(houseCount, width),
        ),
        Column(
          children: items,
        ),
      ],
    );
  }

  Widget _getLevel(Level level, int imageNum, bool isRight, bool isSelected) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
        child: House(
          level: level,
          image: isRight
              ? this.rightImages[imageNum].image
              : this.leftImages[imageNum].image,
          imageH: isRight
              ? this.rightImagesH[imageNum].image
              : this.leftImagesH[imageNum].image,
          isRight: isRight,
          isSelected: isSelected,
        ),
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  final int count;
  final double width;

  _RoadPainter(this.count, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final color = Color.fromARGB(255, 167, 165, 168);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 2000
      ..strokeCap = StrokeCap.square;
    // наклон тропинки (перспектива)
    final angle = 1.75;
    // длина недостоющей домашней тропики (растояние от главной дороги до картинки)
    var pathStart = width * 0.053;
    // сдвиг конца домашней тропинки (перекресток с главной дорогой) от центра экрана
    var pathEnd = width * 0.037;
    // радиус округления углов
    var round = width / 70;

    // старт тропики у 1-ого лвла (нижний уровень)
    var prevPoint =
        Offset(width / 2 + pathEnd * angle, width * count / 2 - pathEnd);

    // рисуем поворот от 1-ого домика на главную тропинку
    var from = Offset(prevPoint.dx + round * angle, prevPoint.dy - round);
    var to = Offset(prevPoint.dx - round * angle, prevPoint.dy - round);
    canvas.drawPath(this._drawCurve(from, to, prevPoint), paint);

    // для каждого уровня
    for (var i = 1; i <= count; i++) {
      // знак, который отвечает за то, чтобы дорога была слева или справа (с противоположной стороны от здания)
      var sign = i % 2 == 0 ? -1 : 1;
      // максимальная удаленность тропинки от центра
      var maxDistance = sign * width * angle / 4;

      // находим следующую точку главной тропикни
      Offset nextPoint;
      if (i == count) {
        // если домик последний - точка будет на повороте к последнему дому
        nextPoint = Offset(width / 2 + pathEnd * angle * sign,
            width * (count - i + 1) / 2 - pathEnd);
      } else {
        // если домик не последний - точка будет на противоположной стороне экрана
        nextPoint =
            Offset(width / 2 + maxDistance, width * (count - i + 0.5) / 2);
      }

      // обрезаем линию (сдвигаем начальную и конечную точки) на размер округления
      from = Offset(prevPoint.dx + round * angle * sign, prevPoint.dy - round);
      to = Offset(nextPoint.dx - round * angle * sign, nextPoint.dy + round);
      // рисуем сегмент главной тропинки
      canvas.drawLine(from, to, paint);

      // рисуем скругление
      from = to;
      to = Offset(nextPoint.dx - round * angle * sign, nextPoint.dy - round);
      canvas.drawPath(this._drawCurve(from, to, nextPoint), paint);

      // находим точки тропинки от домика текущего лвла
      // стартовая точка всегда на одном месте - где заканчивается тропинка у ассета
      var houseStartPoint = Offset(
          width / 2 + (pathEnd - pathStart) * angle * sign,
          width * (count - i + 1) / 2 - pathEnd - pathStart);
      Offset houseEndPoint;
      if (i == 1 || i == count) {
        // если домик первый или последний - точку надо сдвинуть на размер скругления ближе к дому
        houseEndPoint = Offset(width / 2 + (pathEnd - round) * angle * sign,
            width * (count - i + 1) / 2 - pathEnd - round);
      } else {
        // если домик не первый и не последний - точка будет на главной тропинке
        houseEndPoint = Offset(width / 2 + pathEnd * angle * sign,
            width * (count - i + 1) / 2 - pathEnd);
      }
      canvas.drawLine(houseEndPoint, houseStartPoint, paint);

      prevPoint = nextPoint;
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }

  Path _drawCurve(Offset from, Offset to, Offset target) {
    var res = Path();
    res.moveTo(from.dx, from.dy);
    res.cubicTo(target.dx, target.dy, target.dx, target.dy, to.dx, to.dy);

    return res;
  }
}

class House extends StatefulWidget {
  final Level level;
  final ImageProvider image;
  final ImageProvider imageH;
  final bool isRight;
  final bool isSelected;

  const House(
      {Key key,
      this.level,
      this.image,
      this.imageH,
      this.isRight,
      this.isSelected})
      : super(key: key);

  @override
  _HouseState createState() => _HouseState();
}

class _HouseState extends State<House> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  var _pressed = false;

  @override
  void initState() {
    super.initState();
    this._animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    this._animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            this._animationController.reverse();
          } else if (status == AnimationStatus.dismissed && _pressed) {
            this._animationController.forward();
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    var selection = widget.isSelected
        ? FractionallySizedBox(
            widthFactor: 0.3,
            heightFactor: 0.87,
            child: SvgPicture.asset(
              'assets/map/marker_${widget.isRight ? 'right' : 'left'}.svg',
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          )
        : null;

    var layers = List<Widget>();
    if (this._animation.value == 0) {
      layers.add(
        Image(
          image: widget.image,
          fit: BoxFit.fitHeight,
        ),
      );
    } else {
      layers.add(
        Image(
          image: widget.image,
          fit: BoxFit.fitHeight,
        ),
      );
      layers.add(
        Opacity(
          opacity: this._animation.value,
          child: Image(
            image: widget.imageH,
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    }

    layers.add(Row(
      children: <Widget>[
        Expanded(
          flex: widget.isRight ? 2 : 1,
          child: Container(
            alignment: Alignment.topCenter,
            child: widget.isRight ? selection : null,
          ),
        ),
        AspectRatio(
          aspectRatio: 0.4,
          child: SvgPicture.asset(
            'assets/map/stars_${widget.level.number % 4}.svg',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        Expanded(
          flex: widget.isRight ? 1 : 2,
          child: Container(
            alignment: Alignment.topCenter,
            child: widget.isRight ? null : selection,
          ),
        ),
      ],
    ));

    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: layers,
        ),
      ),
      onTapDown: (details) {
        this._pressed = true;
        this._animationController.forward();
      },
      onTapUp: (details) {
        this._pressed = false;
        this._animationController.reverse();
        BlocProvider.of<HomeNavigatorBloc>(context)
            .add(NavigateToCameraPredictionPage(
          widget.level,
        ));
        BlocProvider.of<HomeNavigatorBloc>(context).add(NavigateToLevel(
          widget.level,
          widget.image,
          widget.isRight ? Alignment.centerRight : Alignment.centerLeft,
        ));
      },
      onTapCancel: () {
        this._pressed = false;
      },
    );
  }
}
