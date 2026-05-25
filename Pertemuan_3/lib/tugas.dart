import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. MODEL DATA (Catatan) - Mencakup ID unik dan Field Email Pengirim
class Catatan {
  final String id;
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

// 2. MAIN APPLICATION WIDGET (Named Routes)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/form-catatan':
            final argument = settings.arguments as Catatan?;
            return MaterialPageRoute(
              builder: (_) => FormCatatanPage(catatanLama: argument),
            );
          case '/detail':
            final argument = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: argument),
            );
        }
        return null;
      },
    );
  }
}

// 3. HOME PAGE (StatefulWidget  dan Fitur Filter Kategori)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State dropdown filter kategori aktif
  String _filterKategori = 'Semua';
  final List<String> _opsiFilter = ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  // List data awal catatan mahasiswa
  final List<Catatan> _catatan = [
    Catatan(
      id: '1',
      judul: 'Belajar Flutter Dasar',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation pada pertemuan 3.',
      kategori: 'Kuliah',
      emailPengirim: 'budi@mahasiswa.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  // Menangani penambahan catatan baru
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/form-catatan');

    if (hasil is Catatan) {
      setState(() {
        _catatan.add(hasil);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" berhasil ditambahkan')),
      );
    }
  }

  //Fitur edit
  Future<void> _bukaDetailCatatan(Catatan catatan, int indexDasar) async {
    final hasilEdit = await Navigator.pushNamed(context, '/detail', arguments: catatan);

    if (hasilEdit is Catatan) {
      setState(() {
        final idxAsli = _catatan.indexWhere((element) => element.id == hasilEdit.id);
        if (idxAsli != -1) {
          _catatan[idxAsli] = hasilEdit;
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasilEdit.judul}" berhasil diperbarui')),
      );
    }
  }

  // Fungsi menghapus catatan
  void _hapusCatatan(String id, String judul) {
    setState(() {
      _catatan.removeWhere((element) => element.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "$judul" berhasil dihapus')),
    );
  }

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Memfilter data list
    final listTerfilter = _filterKategori == 'Semua'
        ? _catatan
        : _catatan.where((c) => c.kategori == _filterKategori).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Dropdown Filter Kategori
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: _filterKategori,
              icon: const Icon(Icons.filter_list, color: Colors.indigo),
              underline: const SizedBox(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
              items: _opsiFilter.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? valueBaru) {
                if (valueBaru != null) {
                  setState(() {
                    _filterKategori = valueBaru;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: listTerfilter.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada catatan ditemukan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: listTerfilter.length,
        itemBuilder: (context, i) {
          final c = listTerfilter[i];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: ListTile(
              title: Text(
                c.judul,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          c.kategori,
                          style: const TextStyle(fontSize: 12, color: Colors.indigo),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.emailPengirim,
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTanggal(c.dibuatPada),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Edit Baru
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      // Langsung buka form edit dengan membawa data catatan saat ini
                      final hasilEdit = await Navigator.pushNamed(
                        context,
                        '/form-catatan',
                        arguments: c,
                      );

                      // Jika ada perubahan, langsung update di list utama
                      if (hasilEdit is Catatan) {
                        setState(() {
                          final idxAsli = _catatan.indexWhere((element) => element.id == hasilEdit.id);
                          if (idxAsli != -1) {
                            _catatan[idxAsli] = hasilEdit;
                          }
                        });
                      }
                    },
                  ),
                  // Tombol Hapus (Lama)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _hapusCatatan(c.id, c.judul),
                  ),
                ],
              ),
              onTap: () => _bukaDetailCatatan(c, i),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        tooltip: 'Tambah Catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 4. FORM CATATAN PAGE (Reuse untuk Tambah/Edit + Validasi Lanjutan Regex Email)
class FormCatatanPage extends StatefulWidget {
  final Catatan? catatanLama;

  const FormCatatanPage({super.key, this.catatanLama});

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late TextEditingController _emailCtrl;
  late String _kategori;

  final List<String> _daftarKategori = ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanLama?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.emailPengirim ?? '');
    _kategori = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanHasil = Catatan(
      // Pertahankan ID lama jika mode edit, generate ID acak unix-timestamp jika data baru
      id: widget.catatanLama?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim().toLowerCase(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(),
    );

    Navigator.pop(context, catatanHasil);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = widget.catatanLama != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Field Input Judul Catatan
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Field Input Dropdown Pilihan Kategori
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _daftarKategori.map((String kat) {
                return DropdownMenuItem<String>(
                  value: kat,
                  child: Text(kat),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _kategori = v;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Field validasi masukan Email Pengirim
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                hintText: 'contoh@mahasiswa.com',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email pengirim wajib diisi';

                final regexEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!regexEmail.hasMatch(v.trim())) {
                  return 'Masukkan format alamat email yang benar';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Field Input Isi Catatan
            TextFormField(
              controller: _isiCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.description),
                ),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Isi catatan tidak boleh kosong';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Tombol Eksekusi Aksi Form
            ElevatedButton.icon(
              onPressed: _simpan,
              icon: Icon(isEditMode ? Icons.edit : Icons.save),
              label: Text(isEditMode ? 'Simpan Perubahan' : 'Simpan Catatan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 5. DETAIL CATATAN PAGE (StatelessWidget + Akses Tombol Edit Data)
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  const DetailCatatanPage({super.key, required this.catatan});

  String _formatTanggal(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Catatan',
            onPressed: () async {
              final hasilEdit = await Navigator.pushNamed(
                context,
                '/form-catatan',
                arguments: catatan,
              );

              // Jika data berhasil diperbarui dari form, kirim balik objek data ke HomePage
              if (hasilEdit is Catatan && context.mounted) {
                Navigator.pop(context, hasilEdit);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Info Bar: Kategori, Tanggal, dan Email Pengirim
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(
                  label: Text(catatan.kategori),
                  backgroundColor: Colors.indigo.withOpacity(0.1),
                  side: BorderSide.none,
                ),
                Text(
                  _formatTanggal(catatan.dibuatPada),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Pengirim: ${catatan.emailPengirim}',
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
                ),
              ],
            ),
            const Divider(height: 32),

            // Tampilan Isi Utama Catatan
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Tombol Kembali Ke Halaman Utama
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}