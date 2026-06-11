import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart' show Catatan;

/// Pengganti DbHelper berbasis shared_preferences agar jalan di Flutter Web.
/// Interface (insert / getAll / update / delete) sama persis dengan versi sqflite,
/// sehingga main.dart tidak perlu diubah.
class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _storageKey = 'catatan_list';

  // ── Baca semua catatan dari storage ──────────────────────────────────────
  Future<List<Catatan>> _readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return [];

    final List<dynamic> decoded = jsonDecode(raw);
    return decoded
        .map((e) => Catatan.fromMap(Map<String, Object?>.from(e as Map)))
        .toList();
  }

  // ── Tulis ulang seluruh list ke storage ──────────────────────────────────
  Future<void> _writeAll(List<Catatan> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(list.map((c) => c.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  // ── Buat ID baru (max id + 1, mirip AUTOINCREMENT) ───────────────────────
  int _nextId(List<Catatan> list) {
    if (list.isEmpty) return 1;
    return list.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }

  // ===== CRUD =====

  /// Tambah catatan baru. Mengembalikan id yang digenerate (seperti sqflite).
  Future<int> insert(Catatan c) async {
    final list = await _readAll();
    final newId = _nextId(list);
    // Buat objek baru dengan id yang sudah digenerate
    final withId = Catatan(
      id: newId,
      judul: c.judul,
      isi: c.isi,
      kategori: c.kategori,
      email: c.email,
      dibuatPada: c.dibuatPada,
    );
    list.add(withId);
    // Urutkan terbaru di atas (sesuai perilaku sqflite orderBy dibuat_pada DESC)
    list.sort((a, b) => b.dibuatPada.compareTo(a.dibuatPada));
    await _writeAll(list);
    return newId;
  }

  /// Ambil semua catatan (sudah terurut terbaru di atas).
  Future<List<Catatan>> getAll() async {
    final list = await _readAll();
    list.sort((a, b) => b.dibuatPada.compareTo(a.dibuatPada));
    return list;
  }

  /// Update catatan yang sudah ada berdasarkan id.
  Future<int> update(Catatan c) async {
    assert(c.id != null);
    final list = await _readAll();
    final idx = list.indexWhere((e) => e.id == c.id);
    if (idx == -1) return 0;
    list[idx] = c;
    await _writeAll(list);
    return 1;
  }

  /// Hapus catatan berdasarkan id.
  Future<int> delete(int id) async {
    final list = await _readAll();
    final before = list.length;
    list.removeWhere((e) => e.id == id);
    await _writeAll(list);
    return before - list.length; // jumlah baris yang terhapus
  }
}