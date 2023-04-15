import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_pembayaran.dart';

class ProdusenTransaksi extends StatelessWidget {
  const ProdusenTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Title(color: Colors.indigo, child: Text("Status Transaksi")),
        ),
        body: ListView(
          children: [
            Text("Semua Transaksi"),
            
            InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Text('1 April 2023'),
                    Card(
                      child: Row(children: [
                        Image(image: AssetImage('images/transaksi_02.png')),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Berhasil')
                          ],
                        ),
                        Text("- Rp. 20.000")
                      ]),
                    ),
                  ],
                )),


                InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Text('30 Maret 2023'),
                    Card(
                      child: Row(children: [
                        Image(image: AssetImage('images/transaksi_02.png')),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Berhasil')
                          ],
                        ),
                        Text("- Rp. 20.000"),
                      ]),
                    ),
                  ],
                )),



                InkWell(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                  //   return ProdusenPembayaran();
                  // }));
                },
                child: Column(
                  children: [
                    Text('30 Maret 2023'),
                    Card(
                      child: Row(children: [
                        Image(image: AssetImage('images/transaksi_02.png')),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Berhasilr')
                          ],
                        ),
                        Text("- Rp. 20.000"),
                      ]),
                    ),
                  ],
                )),
          ],
        ));
  }
}