
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sozluk_uygulamasi_firebase/Detay_sayfa.dart';
import 'package:sozluk_uygulamasi_firebase/Kelimeler.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase başlatma
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Anasayfa(title: ""),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key, required this.title});

  final String title;

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool arama_yapiliyor_mu=false;
  String arama_kelimesi="";
  var refKelimeler=FirebaseDatabase.instance.ref().child("kelimeler");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: arama_yapiliyor_mu ?
        TextField(
          decoration: InputDecoration(
            hintText: "Aramak için bir şey yazınız",
          ),
          onChanged: (arama_sonucu){
            print("Arama sonucu: $arama_sonucu");
            setState(() {
              arama_kelimesi=arama_sonucu;
            });
          },
        )
            : Text("SÖZLÜK UYGULAMASI"),
        actions: [
          arama_yapiliyor_mu ?
          IconButton(     // true durumu
            icon: Icon(Icons.cancel_outlined),
            onPressed: (){
              setState(() {
                arama_yapiliyor_mu=false;
                arama_kelimesi="";

              });
            },
          )
              : IconButton(  // false durumu
            icon: Icon(Icons.search_rounded),
            onPressed: (){
              setState(() {
                arama_yapiliyor_mu=true;

              });
            },
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: refKelimeler.onValue,
        builder: (context,event){
          if(event.hasData){

            var kelimeler_liste=<Kelimeler>[];
            var gelenDegerler=event.data?.snapshot.value as dynamic;
            if(gelenDegerler!=null){
              gelenDegerler.forEach((key,nesne){

                var gelenKelime=Kelimeler.fromJson(key, nesne);
                if(arama_yapiliyor_mu){
                 if(gelenKelime.ingilizce.contains(arama_kelimesi)){
                   kelimeler_liste.add(gelenKelime);
                 }

                }
                else{
                  kelimeler_liste.add(gelenKelime);
                }
              });
            }
            return ListView.builder(
              itemCount: kelimeler_liste !.length,
              itemBuilder: (context,indeks){
                var kelime=kelimeler_liste[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Detay_sayfa(kelime: kelime,)));
                  },
                  child: SizedBox(
                    height: 50,
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Text(kelime.ingilizce,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.black),),
                          Text(kelime.turkce,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15,color: Colors.indigo),),
                        ],
                      ),
                    ),
                  ),
                );
              },

            );
          }

          else{
            return Center();
          }
        },

      ),

    );
  }
}
