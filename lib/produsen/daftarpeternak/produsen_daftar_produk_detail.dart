import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_login.dart';
import 'package:quackmo/produsen/pesanan/produsen_pesanan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdusenDaftarProdukDetail extends StatefulWidget {
  ProdusenDaftarProdukDetail(this.produkID, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('produk').doc(produkID);
    _futureData = _reference.get();
  }

  String produkID;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  State<ProdusenDaftarProdukDetail> createState() =>
      _ProdusenDaftarProdukDetailState();
}

class _ProdusenDaftarProdukDetailState
    extends State<ProdusenDaftarProdukDetail> {
  late var _produkData = widget.data;
  late int satuan = _produkData['satuan'];
  late int total = satuan;
  late int hargaTotal = 0;
  _add() {
    if (total >= _produkData['stok']) {
      total = total;
    } else {
      total = total + satuan;
    }
    return total;
  }

  _decrease() {
    if (total <= satuan) {
      total = satuan;
    } else {
      total = total - satuan;
    }
    return total;
  }

  _total(total) {
    return Text("$total");
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference pemesanan = firestore.collection('pemesanan');

    // if(total>_produkData['stok']){
    //   total = _produkData['stok'];
    // }

    return FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi Error ${snapshot.hasError}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot? documentSnapshot = snapshot.data;
            widget.data = documentSnapshot!.data() as Map;
            if (total > _produkData['stok']) {
              total = _produkData['stok'];
            }
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(),
                backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                centerTitle: true,
                title: Text(_produkData['nama_produk']),
              ),
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: 200,
                    width: 200,
                    child: Image(image: NetworkImage(_produkData['foto_url']), fit: BoxFit.contain,)
                    ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      children: [
                        Text("Detail Produk", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(225, 202, 167, 1)
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(225, 202, 167, 1)))
                                ),
                                child: Text("Stock: ${_produkData['stok']}")
                              ),
                                                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(225, 202, 167, 1)))
                                ),
                                child: Text("Berat Satuan: ${_produkData['satuan']}"),
                              ),
                                                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(225, 202, 167, 1)))
                                ),
                                child: Text("Harga: ${_produkData['harga']} / ${_produkData['satuan']} telur"),
                              ),
                                                            Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color.fromRGBO(225, 202, 167, 1)))
                                ),
                                child: Text("Keterangan: ${_produkData['keterangan']}")
                              ),
                              
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225, 202, 167, 1), foregroundColor: Colors.black),
                              onPressed: () async {
                                await showDialog(
                                  useSafeArea: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                                        content: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                             height: 200,
                                            child: Column(children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _add();
                                                              });
                                                            },
                                                            icon: Icon(Icons.add)),
                                                        Text("$total"),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _decrease();
                                                              });
                                                            },
                                                            icon:
                                                                Icon(Icons.remove)),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                      "Stock Total: ${_produkData['stok']}")
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("SubTotal: Rp. "),
                                                  Text('${_produkData['harga'] * (total / satuan)}'),
                                                  // Text('${hargaTotal}')
                                                ],
                                              )
                                            ]),
                                          );
                                        }),
                                        actions: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: TextButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                                              onPressed: () async {
                                                setState(() {
                                                  hargaTotal = (_produkData['harga'] * (total / satuan)).round();
                                                });
                                                CircularProgressIndicator();
                                                await pemesanan.add({
                                                  'id_kondisi': 100,
                                                  'id_produk': widget.produkID,
                                                  'id_produsen': userProdusenID,
                                                  'id_peternak':
                                                      _produkData['peternak_uid'],
                                                  // 'id_transaksi': '',
                                                  'quantity': total,
                                                  'waktu': DateTime.now(),
                                                  'alamat_kirim': '',
                                                  'total': hargaTotal,
                                                  'url_bukti_pembayaran': '',
                                                  'waktu_transaksi': DateTime.now(),
                                                  'id_pengiriman':0
                                                });
                                                                                
                                                Navigator.pushReplacement(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ProdusenPesanan();
                                                }));
                                              },
                                              child: const Text('Pesan Sekarang'),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                      
                                setState(() {});
                              },
                              child: Text("Beli")),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
  }
}
