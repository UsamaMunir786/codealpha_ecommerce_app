import 'package:flutter/material.dart';
import '../../../services/assets_manger.dart';
import '../../../widget/empty_widget.dart';
import '../../../widget/title_text.dart';
import 'oders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TitleText(
            label: 'Placed orders',
          ),
        ),
        body: isEmptyOrders
            ? EmptyWidget(
                imageUrl: AssetsManager.order,
                title: "No orders has been placed yet",
                subtitle: "",
                
              )
            : ListView.separated(
                itemCount: 15,
                itemBuilder: (ctx, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: OrdersWidgetFree(),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ));
  }
}