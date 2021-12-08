import 'package:elliptic/elliptic.dart';

void main() {
  var ec = getSecp256k1();
  var priv = ec.generatePrivateKey();
  var priv_num = priv.D;
  var pub = priv.publicKey;
  print('privateKey: $priv_num');
  print('publicKey: 0x$pub');
}
