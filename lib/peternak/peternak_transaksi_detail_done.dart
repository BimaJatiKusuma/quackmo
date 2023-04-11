import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/peternak/peternak_transaksi.dart';

class PeternakTransaksiDetailDone extends StatelessWidget {
  const PeternakTransaksiDetailDone ({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.check_circle),
          Text('TRANSAKSI BERHASIL DITAMBAHKAN'),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            //   return PeternakTransaksi();
            // }));
          }, child: Text('Kembali'))
        ],
      ),
    );
  }
}