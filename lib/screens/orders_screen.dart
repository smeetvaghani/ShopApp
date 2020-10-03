import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widget/app_drawer.dart';
import '../widget/order_iteam.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

// class _OrdersScreenState extends State<OrdersScreen> {
//   // var _isLoding = false;
  // //fatching is doing using init or diddependecy itin pro overview screen
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoding = true;
  //     });
  //     await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoding = false;
  //     });
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, datasnapshot) {
          if (datasnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (datasnapshot.error != null) {
              return Center(
                child: Text("errr"),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderdata, child) => ListView.builder(
                  itemBuilder: (ctx, ind) => OrderIteam(orderdata.orders[ind]),
                  itemCount: orderdata.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

// // with staful widget
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'package:shop/providers/orders.dart' show Orders;
// import 'package:shop/widget/app_drawer.dart';
// import '../widget/order_iteam.dart';

// class OrdersScreen extends StatefulWidget {
//   static const routeName = "/orders";

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoding = false;
//   //fatching is doing using init or diddependecy itin pro overview screen
//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//         _isLoding = true;
//       });
//       await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
//       setState(() {
//         _isLoding = false;
//       });
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orderdata = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Your Cart"),
//       ),
//       drawer: AppDrawer(),
//       body: _isLoding
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemBuilder: (ctx, ind) => OrderIteam(orderdata.orders[ind]),
//               itemCount: orderdata.orders.length,
//             ),
//     );
//   }
// }
