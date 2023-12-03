import 'package:flutter/material.dart';
import 'package:kisiler_app/kisilerdao.dart';
import 'package:kisiler_app/main.dart';
import 'package:kisiler_app/models/kisiler.dart';
import 'package:kisiler_app/models/notlar.dart';
import 'package:kisiler_app/notlardao.dart';

// ignore: must_be_immutable
class kisiDetaySayfa extends StatefulWidget {
  Kisiler kisi;
  kisiDetaySayfa({required this.kisi});

  @override
  State<kisiDetaySayfa> createState() => _kisiDetaySayfaState();
}

class _kisiDetaySayfaState extends State<kisiDetaySayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  Future<List<Notlar>> tumNotlariGoster() async {
    var notListesi = await Notlardao().tumNotlar(widget.kisi.kisi_id);
    return notListesi;
  }

  Future<List<Notlar>> aramaYap(String arananKelime) async {
    var notlarListesi = await Notlardao().notArama(arananKelime);
    return notlarListesi;
  }

  Future<void> notSil(int id) async {
    await Notlardao().notSil(id);
    setState(() {});
  }

  Future<void> notEkle(int id) async {
    await Notlardao().notEkle(widget.kisi.kisi_id, tfNot.text);
    setState(() {});
    tfNot.text = "";
  }

  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();
  var tfNot = TextEditingController();

  Future<void> guncelle(int kisi_id, String kisi_ad, String kisi_tel) async {
    await Kisilerdao().kisiGuncelle(kisi_id, kisi_ad, kisi_tel);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnaSayfa()));
  }

  @override
  void initState() {
    super.initState();
    var kisi = widget.kisi;
    tfKisiAdi.text = kisi.kisi_ad;
    tfKisiTel.text = kisi.kisi_tel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Kişi Detay", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
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
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Notlar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300,
                child: FutureBuilder<List<Notlar>>(
                  future: aramaYapiliyorMu
                      ? aramaYap(aramaKelimesi)
                      : tumNotlariGoster(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var notlarListesi = snapshot.data;
                      return ListView.builder(
                        itemCount: notlarListesi!.length,
                        itemBuilder: (context, indeks) {
                          var not = notlarListesi[indeks];
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            not.not,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              notSil(not.id);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center();
                    }
                  },
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text("Yeni Not Ekle"),
                //child: Text("Yeni Not Ekle"),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    //title: const Text('AlertDialog Title'),
                    // content: const Text('AlertDialog description'),
                    actions: <Widget>[
                      TextField(
                        controller: tfNot,
                        decoration: InputDecoration(
                            hintText: "Not giriniz", labelText: "Not"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          notEkle(widget.kisi.kisi_id);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          guncelle(widget.kisi.kisi_id, tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: "Kişi Güncelle", // uzun basınca bilgi
        backgroundColor: Colors.lightBlueAccent,
        icon: const Icon(Icons.update),
        label: const Text("Güncelle"),
      ),
    );
  }
}
