import 'package:flutter/material.dart';
import 'package:kisiler_app/kisilerdao.dart';
import 'package:kisiler_app/main.dart';

class KisiKayitSayfa extends StatefulWidget {
  @override
  State<KisiKayitSayfa> createState() => _KisiKayitSayfaState();
}

class _KisiKayitSayfaState extends State<KisiKayitSayfa> {
  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  Future<void> kayit(String kisi_ad, String kisi_tel) async {
    await Kisilerdao().kisiEkle(kisi_ad, kisi_tel);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnaSayfa()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Kişi Kayıt",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, //nesneleri ekrana dikey yay
            children: <Widget>[
              TextField(
                controller: tfKisiAdi,
                decoration:
                    InputDecoration(hintText: "Kişi Ad", labelText: "Ad"),
              ),
              TextField(
                controller: tfKisiTel,
                decoration:
                    InputDecoration(hintText: "Kişi Tel", labelText: "Tel"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          kayit(tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: "Kişi Kayıt", // uzun basınca bilgi
        icon: const Icon(Icons.save),
        backgroundColor: Colors.green[100],
        label: Text("Kaydet"),
      ),
    );
  }
}
