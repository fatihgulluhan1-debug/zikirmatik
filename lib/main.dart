import 'package:flutter/material.dart';

void main() {
  runApp(const ZikirmatikApp());
}

class ZikirmatikApp extends StatefulWidget {
  const ZikirmatikApp({super.key});

  @override
  State<ZikirmatikApp> createState() => _ZikirmatikAppState();
}

class _ZikirmatikAppState extends State<ZikirmatikApp> {
  bool _isDarkMode = false; 

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zikirmatik Premium',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xff121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xff004d40)),
      ),
      home: ZikirmatikAnaSayfa(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class ZikirmatikAnaSayfa extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const ZikirmatikAnaSayfa({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ZikirmatikAnaSayfa> createState() => _ZikirmatikAnaSayfaState();
}

class _ZikirmatikAnaSayfaState extends State<ZikirmatikAnaSayfa> {
  int _sayac = 0;
  int _hedef = 33; 
  
  final List<Map<String, String>> _zikirListesi = [
    {"ad": "Sübhanallah", "arapca": "سُبْحَانَ اللهِ", "anlam": "Allah'ı her türlü eksiklikten tenzih ederim."},
    {"ad": "Elhamdülillah", "arapca": "الْحَمْدُ للهِ", "anlam": "Hamd ve övgü yalnızca Allah'adır."},
    {"ad": "Allahu Ekber", "arapca": "اللهُ أَكْبَرُ", "anlam": "Allah en büyüktür."},
    {"ad": "La İlahe İllallah", "arapca": "لَا إِلٰهَ إِلَّا اللهُ", "anlam": "Allah'tan başka hiçbir ilah yoktur."},
    {"ad": "Estağfirullah", "arapca": "أَسْتَغْفِرُ اللهَ", "anlam": "Allah'tan bağışlanma dilerim."},
    {"ad": "Subhanallahi ve Bihamdihi", "arapca": "سُبْحَانَ اللهِ وَبِحَمْدِهِ", "anlam": "Allah'ı hamd ile tenzih ederim."},
    {"ad": "La Havle ve La Kuvvete...", "arapca": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ", "anlam": "Güç ve kuvvet ancak Allah'a aittir."},
    {"ad": "Salavat-ı Şerife", "arapca": "اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ", "anlam": "Allah'ım, Efendimiz Muhammed'e salat ve selam eyle."},
    {"ad": "Hasbünallahü ve Ni'mel Vekil", "arapca": "حَسْبُنَا اللهُ وَنِعْمَ الْوَكِيلُ", "anlam": "Allah bize yeter, O ne güzel vekildir."},
    {"ad": "Ya Allah Ya Fettah", "arapca": "يَا اللهُ يَا فَتَّاحُ", "anlam": "Ey her şeyi açan, kolaylaştıran Allah'ım."}
  ];

  int _secilenIndex = 0;
  final List<int> _hedefler = [33, 99, 100, 500, 1000];

  void _zikirCek() {
    setState(() {
      _sayac++;
      if (_sayac == _hedef) {
        Feedback.forTap(context); 
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('🎉 Tebrikler!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
              content: Text('${_zikirListesi[_secilenIndex]["ad"]} zikrinde $_hedef olan hedefinize başarıyla ulaştınız. Allah kabul etsin!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Amin', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void _sayaciEksilt() {
    setState(() {
      if (_sayac > 0) {
        _sayac--;
      }
    });
  }

  void _sayaciSifirla() {
    setState(() {
      _sayac = 0;
    });
  }

  void _ozelZikirEkleKutusu() {
    String yeniAd = "";
    String yeniArapca = "";
    String yeniAnlam = "";
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Özel Zikir Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: "Zikir Adı (Örn: Ya Kuddüs)"),
                  onChanged: (value) => yeniAd = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Arapça Yazılışı (Opsiyonel)"),
                  onChanged: (value) => yeniArapca = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Türkçe Anlamı"),
                  onChanged: (value) => yeniAnlam = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                if (yeniAd.trim().isNotEmpty) {
                  setState(() {
                    _zikirListesi.add({
                      "ad": yeniAd.trim(),
                      "arapca": yeniArapca.trim().isEmpty ? "الله" : yeniArapca.trim(),
                      "anlam": yeniAnlam.trim().isEmpty ? "Özel dua/zikir." : yeniAnlam.trim(),
                    });
                    _secilenIndex = _zikirListesi.length - 1;
                    _sayac = 0;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Ekle', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _zikirDuzenleKutusu() {
    String guncelAd = _zikirListesi[_secilenIndex]["ad"]!;
    String guncelArapca = _zikirListesi[_secilenIndex]["arapca"]!;
    String guncelAnlam = _zikirListesi[_secilenIndex]["anlam"]!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Zikri Düzenle', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: guncelAd,
                  decoration: const InputDecoration(hintText: "Zikir Adı"),
                  onChanged: (value) => guncelAd = value,
                ),
                TextFormField(
                  initialValue: guncelArapca,
                  decoration: const InputDecoration(hintText: "Arapça Yazılışı"),
                  onChanged: (value) => guncelArapca = value,
                ),
                TextFormField(
                  initialValue: guncelAnlam,
                  decoration: const InputDecoration(hintText: "Türkçe Anlamı"),
                  onChanged: (value) => guncelAnlam = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _zikirListesi[_secilenIndex] = {
                    "ad": guncelAd.trim(),
                    "arapca": guncelArapca.trim(),
                    "anlam": guncelAnlam.trim(),
                  };
                });
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _zikirSilOnayKutusu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⚠️ Emin misiniz?', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('"${_zikirListesi[_secilenIndex]["ad"]}" zikrini silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _zikirListesi.removeAt(_secilenIndex);
                  _secilenIndex = 0; 
                  _sayac = 0;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Sil', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _destekReklamiIzle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Destek reklamı yükleniyor... Teşekkürler! ❤️'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final panelColor = isDark ? const Color(0xff1a1a1a).withOpacity(0.85) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zikirmatik Canavar v8.1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: widget.onThemeChanged,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: isDark ? 0.03 : 0.04,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'ALLAH',
                      style: TextStyle(fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black, letterSpacing: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 1. KISIM: ZİKİR SEÇİM ŞERİDİ
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _zikirListesi.length + 1, 
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (context, index) {
                          if (index == _zikirListesi.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ActionChip(
                                backgroundColor: Colors.teal.shade700,
                                label: const Text('+ Özel Ekle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                onPressed: _ozelZikirEkleKutusu,
                              ),
                            );
                          }

                          final seciliMi = index == _secilenIndex;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(_zikirListesi[index]["ad"]!),
                              selected: seciliMi,
                              selectedColor: Colors.teal,
                              labelStyle: TextStyle(
                                color: seciliMi ? Colors.white : (isDark ? Colors.white70 : Colors.teal.shade900),
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: isDark ? Colors.grey.shade800 : Colors.teal.shade50,
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() {
                                    _secilenIndex = index;
                                    _sayac = 0;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (_secilenIndex >= 10)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: _zikirDuzenleKutusu),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _zikirSilOnayKutusu),
                        ],
                      )
                    else
                      const SizedBox(height: 15),
                  ],
                ),

                // 2. KISIM: ANLAM PANELİ VE HEDEF SEÇİMİ
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: panelColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: Text(
                          _zikirListesi[_secilenIndex]["anlam"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: textColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _hedefler.map((h) {
                        final hedefSecili = _hedef == h;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text('$h'),
                            selected: hedefSecili,
                            selectedColor: Colors.amber.shade800,
                            labelStyle: TextStyle(
                              color: hedefSecili ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.amber.shade100,
                            onSelected: (selected) {
                              if (selected) setState(() => _hedef = h);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // 3. KISIM: SAYAÇ EKRANI
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.teal, width: 2),
                  ),
                  child: Text('$_sayac', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: textColor)),
                ),

                // 4. KISIM: BÜYÜK BUTON VE ANLIK ARAPÇA METİN
                GestureDetector(
                  onTap: _zikirCek,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.teal.withOpacity(0.3), spreadRadius: 6, blurRadius: 12),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _zikirListesi[_secilenIndex]["arapca"]!, 
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                // 5. KISIM: KONTROLLER
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _sayaciEksilt,
                          icon: const Icon(Icons.remove, color: Colors.white),
                          label: const Text('Eksilt', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton.icon(
                          onPressed: _sayaciSifirla,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _destekReklamiIzle,
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      label: const Text('Destek Ol (Reklam İzle)', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
