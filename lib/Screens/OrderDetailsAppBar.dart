// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrderDetailsAppBar extends StatefulWidget {
  const OrderDetailsAppBar({super.key});

  @override
  State<OrderDetailsAppBar> createState() => _OrderDetailsAppBarState();
}

class _OrderDetailsAppBarState extends State<OrderDetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Order Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
