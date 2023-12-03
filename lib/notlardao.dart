import 'package:kisiler_app/DatabaseHelper.dart';
import 'package:kisiler_app/models/notlar.dart';

// uzun açıklama database access object
class Notlardao {
  Future<List<Notlar>> tumNotlar(int kisi_id) async {
    var db = await DatabaseHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("Select * from notlar where kisi_id=$kisi_id");

    return List.generate(maps.length, (i) {
      var satir = maps[i];

      return Notlar(satir["id"], satir["not"]);
    });
  }

  Future<List<Notlar>> notArama(String aramaKelimesi) async {
    var db = await DatabaseHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db
        .rawQuery("Select * from notlar Where not like '%$aramaKelimesi%'");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Notlar(satir["id"], satir["not"]);
    });
  }

  Future<void> notEkle(int kisi_id, String not) async {
    var db = await DatabaseHelper.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["kisi_id"] = kisi_id;
    bilgiler["not"] = not;
    await db.insert("notlar", bilgiler);
  }

  Future<void> notGuncelle(int id, int kisi_id, String not) async {
    var db = await DatabaseHelper.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["kisi_id"] = kisi_id;
    bilgiler["not"] = not;
    await db.update("notlar", bilgiler, where: "id=?", whereArgs: [id]);
  }

  Future<void> notSil(int id) async {
    var db = await DatabaseHelper.veritabaniErisim();
    await db.delete("notlar", where: "id=?", whereArgs: [id]);
  }
}
