import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_bell_system/components/updateoption.dart';
import 'package:school_bell_system/page/loginpage.dart'; // 

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {

String currentDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset('lib/images/logo.jpg', 
                   width: 50,
                    height: 50,
                    fit: BoxFit.cover,)
                  ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "School Belling System",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentDateTime, // Corrected dynamic date
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),

      body: Center(
        child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Updateoption(),
              ],
            ),
          ),
        );

       

    
  }
}
