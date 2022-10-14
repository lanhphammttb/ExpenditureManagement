import 'package:expenditure_management/constants/app_styles.dart';
import 'package:flutter/material.dart';

Widget tabBarType({required TabController controller}) {
  return SizedBox(
    height: 45,
    width: 220,
    child: TabBar(
        controller: controller,
        labelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelColor: const Color.fromRGBO(45, 216, 198, 1),
        unselectedLabelStyle: AppStyles.p,
        isScrollable: false,
        indicator: const CircleTabIndicator(color: Colors.black38, radius: 4),
        tabs: const [
          Tab(text: "Chi Tiêu"),
          Tab(text: "Thu Nhập"),
        ]),
  );
}

class CircleTabIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
