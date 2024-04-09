import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi_firebase/Kelimeler.dart';

class Detay_sayfa extends StatefulWidget {
  Kelimeler kelime;

  Detay_sayfa({required this.kelime});


  @override
  State<Detay_sayfa> createState() => _Detay_sayfaState();
}

class _Detay_sayfaState extends State<Detay_sayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("SÖZLÜK UYGULAMASI"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.kelime.ingilizce, style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30,color: Colors.indigo),),
            Text(widget.kelime.turkce,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 30,color: Colors.pinkAccent),),

          ],
        ),
      ),

    );
  }
}
