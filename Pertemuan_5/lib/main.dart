import 'package:flutter/material.dart';
import 'api_client.dart';

void main() {
  runApp(const MyApp());
}

// ───────────────────────────── Model ─────────────────────────────
class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'dibuat_pada': dibuatPada.toUtc().toIso8601String(),
  };

  static Catatan fromJson(Map<String, dynamic> m) => Catatan(
    id: m['id'] as int?,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
    kategori: m['kategori'] as String,
    dibuatPada: DateTime.parse(m['dibuat_pada'] as String),
  );

  Catatan copyWith({String? judul, String? isi, String? kategori}) => Catatan(
    id: id,
    judul: judul ?? this.judul,
    isi: isi ?? this.isi,
    kategori: kategori ?? this.kategori,
    dibuatPada: dibuatPada,
  );
}

// ───────────────────────────── Helpers ───────────────────────────
String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

// ──────────────────────── Palet Earth Tone ───────────────────────
class AppColors {
  static const darkBrown  = Color(0xFF6E4E37); // AppBar / Warna Utama
  static const clayBrown  = Color(0xFFA07154); // Cokelat Tanah / Clay
  static const sandBeige  = Color(0xFFD9B48F); // Beige Pasir Hangat
  static const softAlmond = Color(0xFFF7EFE5); // Almond Lembut (Card)
}

// ───────────────────────────── App ───────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.darkBrown,
          primary: AppColors.darkBrown,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.clayBrown,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: AppColors.softAlmond,
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/form':
            final arg = settings.arguments;
            return MaterialPageRoute(
              builder: (_) =>
                  CatatanFormPage(initial: arg as Catatan?),
            );
          case '/detail':
            final c = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: c),
            );
        }
        return null;
      },
    );
  }
}

// ──────────────────────────── Home ───────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Catatan>> _futureCatatan;

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futureCatatan = ApiClient.instance.getAll(); // REST API
    });
  }

  Future<void> _bukaForm({Catatan? initial}) async {
    await Navigator.pushNamed(context, '/form', arguments: initial);
    _muatUlang();
  }

  Future<void> _konfirmasiHapus(Catatan c) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('"${c.judul}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.clayBrown),
            onPressed: () {
              // => Navigator.pop(ctx, true),
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      try {
        await ApiClient.instance.delete(c.id!);
        if (!mounted) return;
        _muatUlang();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${c.judul}" dihapus'),
            backgroundColor: AppColors.darkBrown,
          ),
        );
      } on ApiException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${e.message}')),
        );
      }
    }
  }

  Widget _itemCatatan(Catatan c) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        title: Text(
          c.judul,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.darkBrown,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${c.kategori}\n${_formatDate(c.dibuatPada)}',
            style: const TextStyle(fontSize: 12, height: 1.3),
          ),
        ),
        onTap: () async {
          await Navigator.pushNamed(context, '/detail', arguments: c);
          _muatUlang();
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: AppColors.clayBrown),
              onPressed: () => _bukaForm(initial: c),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.clayBrown),
              onPressed: () => _konfirmasiHapus(c),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catatan Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: FutureBuilder<List<Catatan>>(
        future: _futureCatatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state — termasuk ApiException
          if (snapshot.hasError) {
            final e = snapshot.error;
            final pesan = e is ApiException
                ? e.message
                : 'Terjadi kesalahan: $e';
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.clayBrown),
                  const SizedBox(height: 8),
                  Text(
                    pesan,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.clayBrown),
                    onPressed: _muatUlang,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data ?? const [];
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notes,
                      size: 70, color: AppColors.sandBeige),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada catatan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemBuilder: (_, i) => _itemCatatan(data[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ──────────────────────────── Form ───────────────────────────────
class CatatanFormPage extends StatefulWidget {
  final Catatan? initial;
  const CatatanFormPage({super.key, this.initial});
  @override
  State<CatatanFormPage> createState() => _CatatanFormPageState();
}

class _CatatanFormPageState extends State<CatatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late String _kategori;
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];
  bool _menyimpan = false;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _judulCtrl =
        TextEditingController(text: widget.initial?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.initial?.isi ?? '');
    _kategori = widget.initial?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    //untuk tes
    // if (!_formKey.currentState!.validate()) return;
    if (false) { if (!_formKey.currentState!.validate()) return; }
    setState(() => _menyimpan = true);
    try {
      if (_isEdit) {
        final updated = widget.initial!.copyWith(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
        );
        await ApiClient.instance.update(updated);
      } else {
        // final baru = Catatan(
        //   judul: _judulCtrl.text.trim(),
        //   isi: _isiCtrl.text.trim(),
        //   kategori: _kategori,
        //   dibuatPada: DateTime.now(),
        // );

        // kode tes
        final baru = Catatan(
          judul: "",
          isi: "",
          kategori: _kategori,
          dibuatPada: DateTime.now(),
        );

        await ApiClient.instance.insert(baru);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            _isEdit ? 'Catatan diperbarui' : 'Catatan ditambahkan'),
        backgroundColor: AppColors.darkBrown,
      ));
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);

      // Menampilkan pesan error (yang sudah kita paksa jadi "HTTP 422" di api_client.dart)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(_isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Judul
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon:
                Icon(Icons.title, color: AppColors.clayBrown),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Judul wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),

            // Kategori
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category_outlined,
                    color: AppColors.sandBeige),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) =>
                  DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),

            // Isi Catatan
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                prefixIcon: Icon(Icons.notes_outlined,
                    color: AppColors.darkBrown),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty)
                  ? 'Isi wajib diisi'
                  : null,
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            FilledButton.icon(
              onPressed: _menyimpan ? null : _simpan,
              icon: _menyimpan
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.save_outlined,
                  color: Colors.white),
              label: Text(
                _isEdit ? 'Perbarui Catatan' : 'Simpan Catatan',
                style:
                const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Detail ──────────────────────────────
class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catatan.judul,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Chip(
                          avatar: const Icon(Icons.label_outline,
                              color: AppColors.clayBrown, size: 16),
                          label: Text(catatan.kategori,
                              style: const TextStyle(
                                  color: AppColors.darkBrown)),
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(
                              color: AppColors.clayBrown),
                          shape: const StadiumBorder(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 15, color: AppColors.sandBeige),
                        const SizedBox(width: 6),
                        Text(
                          'Dibuat: ${_formatDate(catatan.dibuatPada)}',
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        catatan.isi,
                        style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.clayBrown),
              label: Text(
                'Kembali ke Daftar',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: AppColors.clayBrown),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}