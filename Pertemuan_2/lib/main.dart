import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug [cite: 47]
      home: ProfilePage(),
    );
  }
}

// === HALAMAN PROFIL UTAMA ===
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar: Bar bagian atas [cite: 71, 78]
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      // 2. Drawer: Panel samping kiri [cite: 71, 86]
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ilham Anugrah',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
            ),
            // Navigasi ke Widget Gallery [cite: 351, 357]
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer [cite: 361]
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
          ],
        ),
      ),

      // 3. Body: Konten utama yang bisa di-scroll [cite: 71, 177, 213]
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Profil [cite: 218]
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Ilham Anugrah',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Baris Statistik menggunakan Expanded [cite: 241, 245]
            const Row(
              children: [
                Expanded(child: StatBox(label: 'Post', value: '12')),
                Expanded(child: StatBox(label: 'Teman', value: '128')),
                Expanded(child: StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),

            // Section Cards [cite: 257, 312]
            const SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: 'Saya suka belajar hal baru, terutama pengembangan aplikasi mobile.',
            ),
            const SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: 'Universitas XYZ Semester 5\nIPK: 3.75',
            ),
            const SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content: 'Coding, Membaca, Fotografi, Game',
            ),
            const SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: 'email@example.com\n+62 812-3456-7890',
            ),
            const SizedBox(height: 80), // Ruang agar tidak tertutup FAB [cite: 282]
          ],
        ),
      ),

      // 4. FloatingActionButton: Tombol melayang [cite: 71, 103]
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia')),
          );
        },
        child: const Icon(Icons.edit),
      ),

      // 5. BottomNavigationBar: Navigasi bawah [cite: 71, 107]
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

// === HELPER WIDGETS ===
class StatBox extends StatelessWidget {
  final String label;
  final String value;
  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const SectionCard({super.key, required this.icon, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === WIDGET GALLERY SECTION ===
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    // List kategori gallery [cite: 375]
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage(name: name)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    // Switch case untuk menampilkan konten per kategori [cite: 427, 937]
    Widget bodyContent;
    switch (name) {
      case 'Display':
        bodyContent = const Center(child: Text('Demo Display Widget'));
        break;
      case 'Input':
        bodyContent = const Center(child: Text('Demo Input Widget'));
        break;
      default:
        bodyContent = Center(child: Text('Konten kategori $name'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: bodyContent,
    );
  }
}