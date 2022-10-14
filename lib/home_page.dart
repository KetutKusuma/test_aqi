import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController isbnBuku = TextEditingController();

    final TextEditingController kodeBuku = TextEditingController();
    final TextEditingController judulBuku = TextEditingController();
    final TextEditingController kategori = TextEditingController();
    final TextEditingController harga = TextEditingController();

    final CollectionReference _books =
        FirebaseFirestore.instance.collection("books");
    bool? checkbox;
    Future<void> _delete(String productId) async {
      await _books.doc(productId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You will finally deleted the data"),
        ),
      );
    }

    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        isbnBuku.text = documentSnapshot['ISBN'];
        judulBuku.text = documentSnapshot['bookTitle'];
        kodeBuku.text = documentSnapshot['bookCode'];
        kategori.text = documentSnapshot['category'];
        harga.text = documentSnapshot['price'].toString();
      }

      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: isbnBuku,
                  decoration: InputDecoration(labelText: "ISBN"),
                ),
                TextField(
                  controller: judulBuku,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Judul Buku"),
                ),
                TextField(
                  controller: kodeBuku,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Kode Buku"),
                ),
                TextField(
                  controller: kategori,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Kategori"),
                ),
                TextField(
                  controller: harga,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Harga"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String judulbuku = judulBuku.text;
                      final String isbn = isbnBuku.text;
                      final String codeBuku = kodeBuku.text;
                      final String katgori = kategori.text;
                      final double? price = double.tryParse(harga.text);
                      if (price != null) {
                        await _books.doc(documentSnapshot!.id).update(
                          {
                            "ISBN": isbn,
                            "bookCode": codeBuku,
                            "bookTitle": judulbuku,
                            "category": katgori,
                            "price": price,
                          },
                        );
                        setState(() {
                          isbnBuku.text = '';
                          judulBuku.text = '';
                          kodeBuku.text = '';
                          kategori.text = '';
                          harga.text = '';
                        });
                      }
                    },
                    child: Text("Update"))
              ],
            ),
          );
        },
      );
    }

    Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        isbnBuku.text = documentSnapshot['ISBN'];
        judulBuku.text = documentSnapshot['bookTitle'];
        kodeBuku.text = documentSnapshot['bookCode'];
        kategori.text = documentSnapshot['category'];
        harga.text = documentSnapshot['price'].toString();
      }

      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: isbnBuku,
                  decoration: InputDecoration(labelText: "ISBN"),
                ),
                TextField(
                  controller: judulBuku,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Judul Buku"),
                ),
                TextField(
                  controller: kodeBuku,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Kode Buku"),
                ),
                TextField(
                  controller: kategori,
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Kategori"),
                ),
                TextField(
                  controller: harga,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Harga"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String judulbuku = judulBuku.text;
                      final String isbn = isbnBuku.text;
                      final String codeBuku = kodeBuku.text;
                      final String katgori = kategori.text;
                      final double? price = double.tryParse(harga.text);
                      if (price != null) {
                        await _books.add(
                          {
                            "ISBN": isbnBuku.text,
                            "bookCode": codeBuku,
                            "bookTitle": judulbuku,
                            "category": katgori,
                            "price": price,
                          },
                        );
                        setState(() {
                          isbnBuku.text = '';
                          judulBuku.text = '';
                          kodeBuku.text = '';
                          kategori.text = '';
                          harga.text = '';
                        });
                      }
                    },
                    child: Text("Create"))
              ],
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _create();
                  },
                  child: Text("Add"),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Del All"))
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: _books.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        final DocumentSnapshot booksList =
                            streamSnapshot.data!.docs[index];
                        return Container(
                          height: 100,
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booksList['ISBN'],
                                    ),
                                    Text(
                                      booksList['bookCode'],
                                    ),
                                    Text(
                                      booksList['bookTitle'],
                                    ),
                                    Text(
                                      booksList['category'],
                                    ),
                                    Text(
                                      booksList['price'].toString(),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    _update(booksList);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _delete(booksList.id);
                                  },
                                  icon: Icon(Icons.restore_from_trash),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }
                  return Text("mama");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
