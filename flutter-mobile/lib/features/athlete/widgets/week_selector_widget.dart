import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/athlete/providers/selected_week_provider.dart';

class WeekSelectorWidget extends ConsumerStatefulWidget {
  final int currentWeek;
  final int totalWeeks;
  final void Function(int)? onArrowPressed;

  const WeekSelectorWidget({
    super.key,
    required this.currentWeek,
    required this.totalWeeks,
    this.onArrowPressed,
  });

  @override
  ConsumerState<WeekSelectorWidget> createState() =>
      _WeekSelectorWidgetState();
}

class _WeekSelectorWidgetState
    extends ConsumerState<WeekSelectorWidget> {
  PageController? _pageController;

  bool get isControlled => widget.onArrowPressed != null;

  @override
  void initState() {
    super.initState();
    if (!isControlled) {
      _pageController = PageController(
        initialPage: widget.currentWeek,
      );
    }
  }

  void _handleWeekChange(int weekIndex) {
    if (isControlled) {
      widget.onArrowPressed!(weekIndex);
    } else {
      _pageController?.animateToPage(
        weekIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      ref.read(selectedWeekProvider.notifier).state =
          weekIndex;
    }
  }

  @override
  void didUpdateWidget(
    covariant WeekSelectorWidget oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (!isControlled &&
        oldWidget.currentWeek != widget.currentWeek) {
      _pageController?.jumpToPage(widget.currentWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _WeekArrowButton(
          icon: Icons.chevron_left,
          onTap:
              widget.currentWeek > 0
                  ? () => _handleWeekChange(
                    widget.currentWeek - 1,
                  )
                  : null,
          isDark: isDark,
        ),
        Expanded(
          child: SizedBox(
            height: 32,
            child:
                isControlled
                    ? Center(
                      child: Text(
                        "Week ${widget.currentWeek + 1} of ${widget.totalWeeks}",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color:
                              isDark
                                  ? Colors.grey[200]
                                  : Colors.grey[800],
                        ),
                      ),
                    )
                    : PageView.builder(
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: widget.totalWeeks,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(
                            "Week ${index + 1} of ${widget.totalWeeks}",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color:
                                      isDark
                                          ? Colors.grey[200]
                                          : Colors
                                              .grey[800],
                                ),
                          ),
                        );
                      },
                    ),
          ),
        ),
        _WeekArrowButton(
          icon: Icons.chevron_right,
          onTap:
              widget.currentWeek < widget.totalWeeks - 1
                  ? () => _handleWeekChange(
                    widget.currentWeek + 1,
                  )
                  : null,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _WeekArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDark;

  const _WeekArrowButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color:
              onTap != null
                  ? Colors.grey.withOpacity(0.15)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 24,
          color:
              onTap != null
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.grey[400],
        ),
      ),
    );
  }
}
