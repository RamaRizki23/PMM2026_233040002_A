import 'package:flutter/material.dart';

void main() {
runApp( MaterialApp(
debugShowCheckedModeBanner: false,
home: Scaffold(
body: Center(
// HAPUS kata 'const' di depan Column agar Container di bawahnya tidak error
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Latihan 3: Row Alignment',
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
),
SizedBox(height: 20),
Container(
color: Colors.grey.shade200, // Ini penyebab error jika ada 'const' di atasnya
height: 120,
width: double.infinity,
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Container(width: 60, height: 60, color: Colors.red),
Container(width: 60, height: 60, color: Colors.green),
Container(width: 60, height: 60, color: Colors.blue),
],
),
),
],
),
),
),
));
}