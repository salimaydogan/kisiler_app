import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kisiler_app/kisiDetaySayfa.dart';
import 'package:kisiler_app/kisiKayitSayfa.dart';
import 'package:kisiler_app/kisilerdao.dart';
import 'package:kisiler_app/models/kisiler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kisiler Uygulaması',
      debugShowCheckedModeBanner: false,
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  Future<List<Kisiler>> tumKisileriGoster() async {
    var kisilerListesi = await Kisilerdao().tumKisiler();
    return kisilerListesi;
  }

  Future<List<Kisiler>> aramaYap(String arananKelime) async {
    var kisilerListesi = await Kisilerdao().kisiArama(arananKelime);
    return kisilerListesi;
  }

  Future<void> sil(int kisi_id) async {
    await Kisilerdao().kisiSil(kisi_id);
    setState(() {});
  }

  Future<bool> uygulamaKapat() async {
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            uygulamaKapat();
          },
          icon: Icon(Icons.close),
          color: Colors.white,
        ),
        backgroundColor:
            Colors.blueGrey, //Theme.of(context).colorScheme.inversePrimary,
        title: aramaYapiliyorMu
            ? TextField(
                decoration:
                    InputDecoration(hintText: "Arama için değer giriniz"),
                onChanged: (aramaSonucu) {
                  print("Sonuc:$aramaSonucu");
                  setState(() {
                    aramaKelimesi = aramaSonucu;
                  });
                },
              )
            : const Text("Kişiler Uygulaması",
                style: TextStyle(color: Colors.white)),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaKelimesi = "";
                    });
                  },
                  icon: Icon(Icons.cancel),
                  color: Colors.white,
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = true;
                    });
                  },
                  icon: Icon(Icons.search),
                  color: Colors.white,
                )
        ],
      ),
      body: WillPopScope(
        onWillPop: uygulamaKapat,
        child: FutureBuilder<List<Kisiler>>(
          future:
              aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKisileriGoster(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var kisilerListesi = snapshot.data;
              return ListView.builder(
                itemCount: kisilerListesi!.length,
                itemBuilder: (context, indeks) {
                  var kisi = kisilerListesi[indeks];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  kisiDetaySayfa(kisi: kisi)));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    kisi.kisi_ad,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("(${kisi.kisi_tel})"),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      sil(kisi.kisi_id);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => KisiKayitSayfa()));
        },
        backgroundColor: Colors.blue[200],
        tooltip: "Kişi Ekle", // uzun basınca bilgi
        icon: const Icon(Icons.add),
        label: Text("Kişi Ekle"),
      ),
    );
  }
}
