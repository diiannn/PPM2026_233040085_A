import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainMenu(),
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Widget Dasar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pilih Latihan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _MenuButton(
              label: 'Latihan 1: Text & Styling',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Latihan1()),
              ),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'Latihan 2: Container & Decoration',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Latihan2()),
              ),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'Latihan 3: Row & Column',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Latihan3()),
              ),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'Latihan 4: Icon & Bottom Bar',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Latihan4()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}


// Latihan 1: Text & Styling
class Latihan1 extends StatelessWidget {
  const Latihan1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1: Text & Styling'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello Flutter!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ini teks biasa dengan ukuran kecil',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Latihan 2: Container & Decoration
class Latihan2 extends StatelessWidget {
  const Latihan2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 2: Container & Decoration'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Box',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}


// Latihan 3: Row & Column
class Latihan3 extends StatelessWidget {
  const Latihan3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 3: Row & Column'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MainAxisAlignment pada Row:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // .start
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('.start', style: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.home, color: Colors.blue, size: 32),
                Icon(Icons.search, color: Colors.red, size: 32),
                Icon(Icons.notifications, color: Colors.green, size: 32),
                Icon(Icons.person, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 12),

            // .center
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('.center', style: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.home, color: Colors.blue, size: 32),
                Icon(Icons.search, color: Colors.red, size: 32),
                Icon(Icons.notifications, color: Colors.green, size: 32),
                Icon(Icons.person, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 12),

            // .end
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('.end', style: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.home, color: Colors.blue, size: 32),
                Icon(Icons.search, color: Colors.red, size: 32),
                Icon(Icons.notifications, color: Colors.green, size: 32),
                Icon(Icons.person, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 12),

            // .spaceBetween
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('.spaceBetween', style: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.home, color: Colors.blue, size: 32),
                Icon(Icons.search, color: Colors.red, size: 32),
                Icon(Icons.notifications, color: Colors.green, size: 32),
                Icon(Icons.person, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 12),

            // .spaceAround
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('.spaceAround', style: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.home, color: Colors.blue, size: 32),
                Icon(Icons.search, color: Colors.red, size: 32),
                Icon(Icons.notifications, color: Colors.green, size: 32),
                Icon(Icons.person, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 12),

            // .spaceEvenly
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('.spaceEvenly', style: TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.home, color: Colors.blue, size: 32),
                Icon(Icons.search, color: Colors.red, size: 32),
                Icon(Icons.notifications, color: Colors.green, size: 32),
                Icon(Icons.person, color: Colors.orange, size: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Latihan 4: Icon & Bottom Bar Mock-up
class Latihan4 extends StatelessWidget {
  const Latihan4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 4: Icon & Bottom Bar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contoh berbagai ukuran ikon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 24, color: Colors.blue),
                SizedBox(width: 16),
                Icon(Icons.home, size: 48, color: Colors.blue),
                SizedBox(width: 16),
                Icon(Icons.home, size: 64, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'size: 24  |  48  |  64',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 24),
            // Contoh berbagai warna ikon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 40, color: Colors.red),
                SizedBox(width: 16),
                Icon(Icons.star, size: 40, color: Colors.green),
                SizedBox(width: 16),
                Icon(Icons.star, size: 40, color: Colors.purple),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'red  |  green  |  purple',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      // Mock-up bottom navigation bar
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 32, color: Colors.blue),
                Text('Home', style: TextStyle(fontSize: 11, color: Colors.blue)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 32, color: Colors.grey),
                Text('Riwayat', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications, size: 32, color: Colors.grey),
                Text('Notif', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 32, color: Colors.grey),
                Text('Profil', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}