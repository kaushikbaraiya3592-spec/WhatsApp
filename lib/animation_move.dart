class AnimatedPageRoute extends PageRouteBuilder {
  final Widget page;

  AnimatedPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            final slide = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

            return SlideTransition(
              position: slide,
              child: FadeTransition(
                opacity: fade,
                child: child,
              ),
            );
          },
        );
}
