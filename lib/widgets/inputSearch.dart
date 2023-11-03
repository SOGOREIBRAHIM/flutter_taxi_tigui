import 'package:flutter/material.dart';

class InputSearch extends StatefulWidget {
  const InputSearch({super.key});

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      left: 10,
      bottom: 10,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 250,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 199, 199, 199),
                  blurRadius: 10.0,
                  spreadRadius: 3.0,
                ),
              ],
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(30)),
            ),
            child: TextFormField(
              onTap: () {
                PopupMenuItem(child: Text('One'));
              },
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(210, 54, 54, 54),
              ),
              decoration: const InputDecoration(
                 border: InputBorder.none,
                 hintText: 'Ou voulez-vous aller ?',
                 hintStyle: TextStyle(fontSize: 20),
                 contentPadding: EdgeInsets.all(18.0), 
              ),
              
            
            ),
          ),
          // SizedBox(width: 10),
          Container(
            child: Column(
              children: [
                ElevatedButton(
                  child: Icon(Icons.calendar_month_outlined),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEDB602),
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 14)),
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
