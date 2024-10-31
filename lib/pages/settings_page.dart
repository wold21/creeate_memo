import 'package:create_author/components/dialog/delete_dialog.dart';
import 'package:create_author/components/setting_menu.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:create_author/config/state/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    final themeColor = Theme.of(context).extension<CustomTheme>()!;

    void showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteDialog();
        },
      );
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 20.0, right: 25.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Theme'),
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(10),
                        isSelected: [
                          themeState.isThemeToggle,
                          !themeState.isThemeToggle,
                        ],
                        onPressed: (index) {
                          themeState.toggleTheme(); // 테마 변경
                        },
                        children: const [
                          Icon(Icons.light_mode_rounded),
                          Icon(Icons.dark_mode_rounded),
                        ],
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text('Language'),
                //       ToggleButtons(children: [
                //         Text('Kor'),
                //         Text('Eng'),
                //       ], isSelected: [
                //         true,
                //         false
                //       ])
                //     ],
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    showDeleteConfirmationDialog(context);
                  },
                  child: SettingMenu(
                    icon: Icon(Icons.restore_rounded),
                    itemName: 'Reset Records',
                  ),
                ),
                SettingMenu(
                  icon: Icon(Icons.delete_rounded),
                  itemName: 'Trash',
                ),
                SettingMenu(
                  icon: Icon(Icons.feedback),
                  itemName: 'Report & Feedback',
                ),
                SettingMenu(
                  icon: Icon(Icons.info_outline_rounded),
                  itemName: 'About',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
