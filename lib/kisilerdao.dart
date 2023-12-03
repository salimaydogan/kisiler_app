import 'package:kisiler_app/DatabaseHelper.dart';
import 'package:kisiler_app/models/kisiler.dart';

// uzun açıklama database access object
class Kisilerdao {
  Future<List<Kisiler>> tumKisiler() async {
    var db = await DatabaseHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("Select * from kisiler");

    return List.generate(maps.length, (i) {
      var satir = maps[i];

      return Kisiler(satir["id"], satir["ad"], satir["tel"]);
    });
  }

  Future<List<Kisiler>> kisiArama(String aramaKelimesi) async {
    var db = await DatabaseHelper.veritabaniErisim();
    List<Map<String, dynamic>> maps = await db
        .rawQuery("Select * from kisiler Where ad like '%$aramaKelimesi%'");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Kisiler(satir["id"], satir["ad"], satir["tel"]);
    });
  }

  Future<void> kisiEkle(String kisi_ad, String kisi_tel) async {
    var db = await DatabaseHelper.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["ad"] = kisi_ad;
    bilgiler["tel"] = kisi_tel;
    await db.insert("kisiler", bilgiler);
  }

  Future<void> kisiGuncelle(
      int kisi_id, String kisi_ad, String kisi_tel) async {
    var db = await DatabaseHelper.veritabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["ad"] = kisi_ad;
    bilgiler["tel"] = kisi_tel;
    await db.update("kisiler", bilgiler, where: "id=?", whereArgs: [kisi_id]);
  }

  Future<void> kisiSil(int kisi_id) async {
    var db = await DatabaseHelper.veritabaniErisim();
    await db.delete("kisiler", where: "id=?", whereArgs: [kisi_id]);
  }
}
