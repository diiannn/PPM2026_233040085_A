import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();
  static const _key = 'catatan_list';

  Future<List<Catatan>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final result = <Catatan>[];
    for (final s in raw) {
      try {
        result.add(Catatan.fromMap(jsonDecode(s) as Map<String, Object?>));
      } catch (_) {
        // Menghindari crash jika ada data korup
      }
    }
    return result;
  }

  Future<void> insert(Catatan c) async {
    final list = await getAll();

    // PERBAIKAN: Buat ID unik di sini menggunakan milidetik waktu sekarang
    final generatorId = DateTime.now().millisecondsSinceEpoch;

    // Pastikan ID baru ini masuk ke dalam data yang akan disimpan ke list
    final newCatatan = Catatan(
      id: generatorId,
      judul: c.judul,
      email: c.email,
      isi: c.isi,
      kategori: c.kategori,
      dibuatPada: c.dibuatPada,
      diubahPada: null,
    );

    list.insert(0, newCatatan);
    await _simpan(list); // Sekarang data yang disimpan dijamin punya ID unik!
  }

  Future<void> update(Catatan c) async {
    final list = await getAll();
    // Mencari index berdasarkan ID catatan
    final idx = list.indexWhere((e) => e.id == c.id);
    if (idx != -1) {
      list[idx] = c;
    }
    await _simpan(list);
  }

  Future<void> delete(int id) async {
    final list = await getAll();
    list.removeWhere((e) => e.id == id);
    await _simpan(list);
  }

  Future<void> _simpan(List<Catatan> list) async {
    final prefs = await SharedPreferences.getInstance();
    // Mengonversi seluruh objek Catatan di dalam list menjadi String JSON
    final StringList = list.map((c) => jsonEncode(c.toMap())).toList();
    await prefs.setStringList(_key, StringList);
  }
}