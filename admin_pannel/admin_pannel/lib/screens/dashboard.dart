import 'package:pure_dart_ui/pure_dart_ui.dart';

import 'package:admin_pannel/models/dashboard_btn_model.dart';
import 'package:admin_pannel/provider/theme_provider.dart';
import 'package:admin_pannel/services/assets_manger.dart';
import 'package:admin_pannel/widget/dashboar_btn_widget.dart';
import 'package:admin_pannel/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: TitleText(label: 'Dashboard Screen'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        actions: [
          IconButton(
          onPressed: (){
            themeProvider.setDarkTheme(themevalue: !themeProvider.getIsDarkTheme);
          },
           icon: Icon(
            themeProvider.getIsDarkTheme ? Icons.light_mode : Icons.dark_mode
           ))
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2, 
        childAspectRatio: 0.8,
        children: List.generate(
          3, 
          (index) => Padding(padding: EdgeInsets.all(8),
          child: DashboarBtnWidget(
            title: DashboardButtonsModel.dashboardBtnList(context)[index].text, 
            imagePath: DashboardButtonsModel.dashboardBtnList(context)[index].imagePath, 
            onPressed: DashboardButtonsModel.dashboardBtnList(context)[index].onPressed,
            ),
          ),
          ),
        ),
    );
  }
}