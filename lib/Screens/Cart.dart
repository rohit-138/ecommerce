// ignore_for_file: prefer_const_constructors

import 'package:ecommerce/Screens/CartAppBar.dart';
import 'package:ecommerce/Screens/CartItems.dart';
import 'package:ecommerce/Screens/CartNavigation.dart';
import 'package:ecommerce/Screens/checkoutpage.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:ecommerce/Controller/CartController.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../Static/Constants.dart';
import '../Static/UiData.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _razorpay = Razorpay();
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("-----------------------------------------------------------successful payment done-----------------------------------------------------");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        "----------------------------------------------------------------------------- payment failed      --------------------------------------------------------------------------\n");
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print(" external walled selected");
  }

  List<Widget> dynamicList = [];
  final CartController cartController = Get.put(CartController());

  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    var items = cartController.CartProducts;
    return Obx(() {
      if (cartController.CartItemCount == 0) {
        return ListView(
          children: [
            CartAppBar(),
            Container(
              width: UiData.getScreenWidth(context),
              height: UiData.getScreenHeight(context) * 0.2,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: UiData.getScreenWidth(context) * 0.01,
                  vertical: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Your Cart is Empty",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ],
        );
      } else {
        return ListView(
          children: [
            const CartAppBar(),
            Container(
              // height: 700,
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  topLeft: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  const CartItemSamples(),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          (_isVisible) ? _isVisible = false : _isVisible = true;
                        });
                      },
                      child: AddCouponContainer(isVisible: _isVisible),
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: TextField(
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF4C53A5), width: 2.0),
                              ),
                              labelText: 'Enter Coupon Code',
                              labelStyle: TextStyle(color: Color(0xFF4C53A5)),
                              hintText: 'Enter Your Coupon Code')),
                    ),
                  ),
                  PaymentSummary(cartController: cartController),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                 Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckOut()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF4C53A5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Check Out",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            // Container(
            //   child: const CartNavigation(),
            // ),
          ],
        );
      }
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _razorpay.clear();
  //   super.dispose();
  // }
}

class AddCouponContainer extends StatelessWidget {
  const AddCouponContainer({
    Key? key,
    required bool isVisible,
  })  : _isVisible = isVisible,
        super(key: key);

  final bool _isVisible;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: !_isVisible,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4C53A5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        Visibility(
          visible: _isVisible,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4C53A5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Add coupon code",
            style: TextStyle(
                color: Color(0xFF4C53A5),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({
    Key? key,
    required this.cartController,
  }) : super(key: key);

  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: UiData.getScreenWidth(context) * 0.02, vertical: 5),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              "Payment Summary",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C53A5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Order Total",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u{20B9} ${(cartController.getOrderTotalPrice()).toStringAsFixed(2)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        // decorationColor: Colors.red,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationThickness: 3),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u{20B9} ${(cartController.getOrderTotalPrice() - cartController.getOrderDiscount()).toStringAsFixed(2)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Tax(18%)",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u{20B9} ${(cartController.getOrderTax()).toStringAsFixed(2)}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Delivery charges",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u{20B9} 70",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Discount Offer",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u{20B9} ${(cartController.getOrderDiscount()).toStringAsFixed(2)}",
                    // "",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 2.00,
            color: Color(0xFF4C53A5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Total amount",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5)),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\u{20B9} ${cartController.getTotalAmount()}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
