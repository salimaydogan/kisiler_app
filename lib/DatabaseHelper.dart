import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final String veritabaniAdi = "kisiler.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veriTabaniYolu = join(await getDatabasesPath(), veritabaniAdi);
    if (await databaseExists(veriTabaniYolu)) {
      print("Veri tabanı mevcut");
    } else {
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(veriTabaniYolu).writeAsBytes(bytes, flush: true);
      print("Veri tabanı Kopyalandı");
    }
    return openDatabase(veriTabaniYolu);
  }
}
