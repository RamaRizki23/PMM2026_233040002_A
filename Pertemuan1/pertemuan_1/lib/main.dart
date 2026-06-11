import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello Flutter'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👋', style: TextStyle(fontSize: 40)), // Text (emoji)
              const SizedBox(height: 10),
              const Text(
                'Halo, Riki Rikandi!', // Text ('Halo, [Nama]!')
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Selamat datang di praktikum mobile'), // Text ('Selamat datang...')
              const SizedBox(height: 20),

              // Container <- kartu profil biru
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: const [
                    Text('Nama: Riki Rikandi'), // Text (Nama)
                    Text('NIM: 233040025'), // Text (NIM)
                    Text('Prodi: Teknik Informatika'), // Text (Prodi)
                    Text('Semester: 6'), // Text (Semester)
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ElevatedButton
              ElevatedButton(
                onPressed: () {
                  // Aksi ketika tombol ditekan
                },
                child: const Text('Tap Saya'), // Text ('Tap Saya')
              ),
            ],
          ),
        ),
      ),
    );
  }
}