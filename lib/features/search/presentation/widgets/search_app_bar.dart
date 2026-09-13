import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(
          top: dimens.space2,
          bottom: dimens.space3,
          left: dimens.space4,
          right: dimens.space4,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderStrong),
            borderRadius: BorderRadius.circular(dimens.radiusMd),
            color: colors.surfaceSunken,
          ),
          child: Row(
            spacing: dimens.space2,
            children: [
              Transform.translate(
                offset: const Offset(0, 2),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(
                    Icons.search,
                    size: 16,
                    color: colors.textTertiary,
                  ),
                ),
              ),

              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,

                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: AppTypography.medium,
                    height: 20 / 15,
                    letterSpacing: -0.1,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '종목명 또는 종목코드',
                    hintStyle: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 15,
                      fontWeight: AppTypography.medium,
                      height: 20 / 15,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: IconButton(
                    onPressed: onClear,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
