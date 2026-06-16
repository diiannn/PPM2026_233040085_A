import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

// === MODEL UNTUK BONUS PENGALAMAN ===
class Pengalaman {
  final Uint8List? gambarBytes;
  final String judul;
  final String deskripsi;

  Pengalaman({this.gambarBytes, required this.judul, required this.deskripsi});
}

// === HALAMAN PROFIL UTAMA ===
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // State Data Profil Utama
  Uint8List? _imageBytesProfile;
  String _nama = 'Dian Astri';
  String _tentang = 'Belajar Flutter!';
  String _pendidikan = 'Teknik Informatika - Semester 6';
  String _lokasi = 'Bandung, Jawa Barat';
  String _kontak = 'Yan@student.ac.id';
  String _skills = 'Flutter, Dart, Java, Python';

  // State Data Bonus Pengalaman
  List<Pengalaman> listPengalaman = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),

      // Drawer Menu Utama
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _imageBytesProfile != null ? MemoryImage(_imageBytesProfile!) : null,
                child: _imageBytesProfile == null
                    ? const Icon(Icons.person, size: 40, color: Colors.deepPurple)
                    : null,
              ),
              accountName: Text(_nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(_kontak),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
            // NAVIGASI DRAWER: Tambah Pengalaman Baru
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final hasilBonus = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditPengalamanPage(isEditMode: false)),
                );

                if (hasilBonus != null && hasilBonus is Pengalaman) {
                  setState(() {
                    listPengalaman.add(hasilBonus);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Foto Profil & Nama
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageBytesProfile != null ? MemoryImage(_imageBytesProfile!) : null,
                    child: _imageBytesProfile == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _nama,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _pendidikan,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Baris Statistik
            const Row(
              children: [
                Expanded(child: StatBox(label: 'Post', value: '12')),
                Expanded(child: StatBox(label: 'Teman', value: '128')),
                Expanded(child: StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),

            // Section Info Profil Utama
            SectionCard(icon: Icons.info_outline, title: 'Tentang', content: _tentang),
            SectionCard(icon: Icons.school, title: 'Pendidikan', content: _pendidikan),
            SectionCard(icon: Icons.location_on, title: 'Lokasi', content: _lokasi),
            SectionCard(icon: Icons.email, title: 'Kontak', content: _kontak),

            // Skills Section
            SectionCard(
              icon: Icons.star,
              title: 'Skills',
              content: _skills,
            ),

            // BONUS: Section Tampilan Pengalaman
            if (listPengalaman.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Pengalaman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listPengalaman.length,
                itemBuilder: (context, index) {
                  final item = listPengalaman[index];
                  return GestureDetector(
                    onTap: () async {
                      final hasilUpdate = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPengalamanPage(
                            isEditMode: true,
                            currentPengalaman: item,
                          ),
                        ),
                      );

                      if (hasilUpdate != null && hasilUpdate is Pengalaman) {
                        setState(() {
                          listPengalaman[index] = hasilUpdate;
                        });
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (item.gambarBytes != null)
                            Image.memory(item.gambarBytes!, height: 180, fit: BoxFit.cover)
                          else
                            Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const Icon(Icons.edit, size: 16, color: Colors.grey),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(item.deskripsi, style: TextStyle(color: Colors.grey[700])),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Floating Action Button -> Mengarah ke Halaman Edit Profil
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple[50],
        foregroundColor: Colors.deepPurple,
        onPressed: () async {
          final hasilEdit = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                currentNama: _nama,
                currentTentang: _tentang,
                currentPendidikan: _pendidikan,
                currentLokasi: _lokasi,
                currentKontak: _kontak,
                currentSkills: _skills,
                currentImageBytes: _imageBytesProfile,
              ),
            ),
          );

          if (hasilEdit != null && hasilEdit is Map<String, dynamic>) {
            setState(() {
              _nama = hasilEdit['nama'];
              _tentang = hasilEdit['tentang'];
              _pendidikan = hasilEdit['pendidikan'];
              _lokasi = hasilEdit['lokasi'];
              _kontak = hasilEdit['kontak'];
              _skills = hasilEdit['skills'];
              _imageBytesProfile = hasilEdit['imageBytes'];
            });
          }
        },
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}

// === HALAMAN EDIT PROFIL ===
class EditProfilePage extends StatefulWidget {
  final String currentNama;
  final String currentTentang;
  final String currentPendidikan;
  final String currentLokasi;
  final String currentKontak;
  final String currentSkills;
  final Uint8List? currentImageBytes;

  const EditProfilePage({
    super.key,
    required this.currentNama,
    required this.currentTentang,
    required this.currentPendidikan,
    required this.currentLokasi,
    required this.currentKontak,
    required this.currentSkills,
    this.currentImageBytes,
  });

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _namaController;
  late TextEditingController _tentangController;
  late TextEditingController _pendidikanController;
  late TextEditingController _lokasiController;
  late TextEditingController _kontakController;
  late TextEditingController _skillsController;
  Uint8List? _selectedImageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.currentNama);
    _tentangController = TextEditingController(text: widget.currentTentang);
    _pendidikanController = TextEditingController(text: widget.currentPendidikan);
    _lokasiController = TextEditingController(text: widget.currentLokasi);
    _kontakController = TextEditingController(text: widget.currentKontak);
    _skillsController = TextEditingController(text: widget.currentSkills);
    _selectedImageBytes = widget.currentImageBytes;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tentangController.dispose();
    _pendidikanController.dispose();
    _lokasiController.dispose();
    _kontakController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Foto Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _selectedImageBytes != null ? MemoryImage(_selectedImageBytes!) : null,
                    child: _selectedImageBytes == null ? const Icon(Icons.person, size: 50) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Informasi Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tentangController,
              decoration: const InputDecoration(labelText: 'Bio/Tentang', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pendidikanController,
              decoration: const InputDecoration(labelText: 'Pendidikan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lokasiController,
              decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _kontakController,
              decoration: const InputDecoration(labelText: 'Kontak (Email)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            // TAMPILAN FIELD INPUT: TextField baru untuk melakukan modifikasi data skill
            TextField(
              controller: _skillsController,
              decoration: const InputDecoration(labelText: 'Skills', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'nama': _namaController.text,
                  'tentang': _tentangController.text,
                  'pendidikan': _pendidikanController.text,
                  'lokasi': _lokasiController.text,
                  'kontak': _kontakController.text,
                  'skills': _skillsController.text, // Kembalikan payload data skills baru
                  'imageBytes': _selectedImageBytes,
                });
              },
              child: const Text('Simpan Perubahan'),
            )
          ],
        ),
      ),
    );
  }
}

// === HALAMAN EDIT & UPLOAD PENGALAMAN ===
class EditPengalamanPage extends StatefulWidget {
  final bool isEditMode;
  final Pengalaman? currentPengalaman;

  const EditPengalamanPage({
    super.key,
    required this.isEditMode,
    this.currentPengalaman,
  });

  @override
  State<EditPengalamanPage> createState() => EditPengalamanPageState();
}

class EditPengalamanPageState extends State<EditPengalamanPage> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  Uint8List? _imageBytesPengalaman;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.isEditMode ? widget.currentPengalaman?.judul : '',
    );
    _deskripsiController = TextEditingController(
      text: widget.isEditMode ? widget.currentPengalaman?.deskripsi : '',
    );
    _imageBytesPengalaman = widget.isEditMode ? widget.currentPengalaman?.gambarBytes : null;
  }

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      final Uint8List bytes = await img.readAsBytes();
      setState(() {
        _imageBytesPengalaman = bytes;
      });
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Pengalaman' : 'Upload Pengalaman'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isEditMode ? 'Ubah Informasi Pengalaman' : 'Informasi Pengalaman',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul Pengalaman', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Deskripsi Singkat', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text('Foto Pengalaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _imageBytesPengalaman != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(_imageBytesPengalaman!, fit: BoxFit.cover),
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Ketuk untuk pilih gambar dari galeri', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (_judulController.text.isNotEmpty && _deskripsiController.text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Pengalaman(
                      gambarBytes: _imageBytesPengalaman,
                      judul: _judulController.text,
                      deskripsi: _deskripsiController.text,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Judul dan Deskripsi tidak boleh kosong!')),
                  );
                }
              },
              child: Text(widget.isEditMode ? 'Simpan Perubahan' : 'Simpan Pengalaman'),
            ),
          ],
        ),
      ),
    );
  }
}

// === TEMPLATE UTILITAS WIDGET ===
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
            Icon(icon, color: Colors.deepPurple, size: 28),
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

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
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
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}