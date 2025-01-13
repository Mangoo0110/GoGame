import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_names.dart';


class GradientTextAnimation extends StatefulWidget {
  const GradientTextAnimation({super.key});

  @override
  State<GradientTextAnimation> createState() => _GradientTextAnimationState();
}

class _GradientTextAnimationState extends State<GradientTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Static text
        Text(
          AppNames.nameOfTheApp,
          style: Theme.of(context).textTheme.headlineLarge
        ),
        // Animated overlay
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(-3.5 + 2 * _controller.value, 0),
                  end: Alignment(1 + 2 * _controller.value, 0),
                  colors:  [
                    Colors.transparent,
                    AppColors.context(context).accentColor,
                    AppColors.context(context).accentColor,
                    Colors.transparent,
                  ],
                  stops: const [0.25, 0.5, 0.75, 1.0],
                ).createShader(bounds);
              },
              child:Text(
                AppNames.nameOfTheApp,
                style: Theme.of(context).textTheme.headlineLarge
              ),
            );
          },
        ),
      ],
    );
  }
}