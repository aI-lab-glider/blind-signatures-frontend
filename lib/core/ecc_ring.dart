import 'dart:convert';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:elliptic/elliptic.dart';
import 'package:ninja_prime/ninja_prime.dart';

class Ring {
  List<AffinePoint> publicKeys;
  int amountOfKeys = 0;
  Curve ec = getSecp256k1();

  Ring(this.publicKeys) {
    amountOfKeys = publicKeys.length;
  }

  List<BigInt> sign(String message, int myIndexKey, BigInt privateKey) {
    List<BigInt> signatures = List<BigInt>.filled(amountOfKeys, BigInt.zero);
    List<BigInt> challenges = List<BigInt>.filled(amountOfKeys, BigInt.zero);

    List<String> pk_message = [];
    for (int i = 0; i < amountOfKeys; i++) {
      pk_message.add(publicKeys[i].X.toString() + publicKeys[i].Y.toString());
    }
    AffinePoint H = H2(pk_message);
    AffinePoint Y = ec.scalarMul(H, writeBigInt(privateKey));

    BigInt u = randomPrimeBigInt(256);

    AffinePoint GMulU = ec.scalarMul(ec.G, writeBigInt(u));
    AffinePoint HMulU = ec.scalarMul(H, writeBigInt(u));

    challenges[(myIndexKey + 1) % amountOfKeys] = H1([
      ...pk_message,
      Y.X.toString() + Y.Y.toString(),
      message,
      GMulU.X.toString() + GMulU.Y.toString(),
      HMulU.X.toString() + HMulU.Y.toString()
    ]);

    for (int i = myIndexKey + 1; i < amountOfKeys; i++) {
      signatures[i] = randomBigInt(256);

      var z_1 = ec.add((ec.scalarMul(ec.G, writeBigInt(signatures[i]))),
          (ec.scalarMul(publicKeys[i], writeBigInt(challenges[i]))));
      var z_2 = ec.add((ec.scalarMul(H, writeBigInt(signatures[i]))),
          (ec.scalarMul(Y, writeBigInt(challenges[i]))));
      challenges[(i + 1) % amountOfKeys] = H1([
        ...pk_message,
        Y.X.toString() + Y.Y.toString(),
        message,
        z_1.X.toString() + z_1.Y.toString(),
        z_2.X.toString() + z_2.Y.toString()
      ]);
    }
    for (int i = 0; i < myIndexKey; i++) {
      signatures[i] = randomBigInt(256);

      var z_1 = ec.add((ec.scalarMul(ec.G, writeBigInt(signatures[i]))),
          (ec.scalarMul(publicKeys[i], writeBigInt(challenges[i]))));
      var z_2 = ec.add((ec.scalarMul(H, writeBigInt(signatures[i]))),
          (ec.scalarMul(Y, writeBigInt(challenges[i]))));
      challenges[(i + 1) % amountOfKeys] = H1([
        ...pk_message,
        Y.X.toString() + Y.Y.toString(),
        message,
        z_1.X.toString() + z_1.Y.toString(),
        z_2.X.toString() + z_2.Y.toString()
      ]);
    }
    signatures[myIndexKey] = (u - privateKey * challenges[myIndexKey]) % ec.n;
    return ([challenges[0], ...signatures, Y.X, Y.Y]);
  }

  BigInt H1(List<String> message) {
    String finalString = "";
    for (int i = 0; i < message.length; i++) {
      var bytes = utf8.encode(message[i]);
      var k = SHA3(256, SHA3_PADDING, 256);
      var digest = HEX.encode(k.update(bytes).digest());
      finalString += digest.toString();
    }

    var k = SHA3(256, SHA3_PADDING, 256);
    finalString = HEX.encode(k.update(utf8.encode(finalString)).digest());
    return BigInt.parse(finalString, radix: 16);
  }

  List<int> writeBigInt(BigInt number) {
    int bytes = (number.bitLength + 7) >> 3;
    var hex = number.toRadixString(16).padLeft(bytes * 2, '0');
    return List<int>.generate(
        bytes, (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16));
  }

  AffinePoint H2(List<String> message) {
    return map2Curve(H1(message));
  }

  AffinePoint map2Curve(BigInt x) {
    x -= BigInt.one;
    var y = BigInt.zero;
    var found = false;

    while (!found) {
      x += BigInt.one;
      var fX = (x * x * x + BigInt.from(7)) % ec.p;
      try {
        y = square_root_mod_prime(fX, ec.p);
        found = true;
      } on Exception {
        found = false;
      }
    }
    return AffinePoint.fromXY(x, y);
  }

  BigInt jacobi(BigInt a, BigInt n) {
    if (n < BigInt.from(3)) {
      throw Exception(['jacobi']);
    }
    if (n % BigInt.two != BigInt.one) {
      throw Exception(['jacobi']);
    }
    a = a % n;
    if (a == BigInt.zero) {
      return BigInt.zero;
    }
    if (a == BigInt.one) {
      return BigInt.one;
    }
    BigInt a1 = a;
    BigInt e = BigInt.zero;

    while (a1 % BigInt.two == BigInt.zero) {
      a1 = a1 ~/ BigInt.two;
      e = e + BigInt.one;
    }
    BigInt s;
    if (e % BigInt.two == BigInt.zero ||
        n % BigInt.from(8) == BigInt.one ||
        n % BigInt.from(8) == BigInt.from(7)) {
      s = BigInt.one;
    } else {
      s = BigInt.from(-1);
    }

    if (a1 == BigInt.one) {
      return s;
    }

    if (n % BigInt.from(4) == BigInt.from(3) &&
        a1 % BigInt.from(4) == BigInt.from(3)) {
      s = -s;
    }

    return s * jacobi(n % a1, a1);
  }

  BigInt square_root_mod_prime(BigInt a, BigInt p) {
    if (!(BigInt.zero <= a && a < p)) {
      throw Exception(['srmp']);
    }
    if (!(BigInt.one < p)) {
      throw Exception(['srmp']);
    }

    if (a == BigInt.zero) {
      return BigInt.zero;
    }

    if (p == BigInt.two) {
      return a;
    }

    BigInt jac = jacobi(a, p);
    if (jac == BigInt.from(-1)) {
      throw Exception(['srmp']);
    }

    if (p % BigInt.from(4) == BigInt.from(3)) {
      return a.modPow((p + BigInt.one) ~/ BigInt.from(4), p);
    }

    if (p % BigInt.from(8) == BigInt.from(5)) {
      BigInt d = a.modPow((p - BigInt.one) ~/ BigInt.from(4), p);
      if (d == BigInt.one) {
        return a.modPow((p + BigInt.from(3)) ~/ BigInt.from(8), p);
      }
      if (d == p - BigInt.one) {
        return (BigInt.two *
                a *
                (a * BigInt.from(4))
                    .modPow((p - BigInt.from(5)) ~/ BigInt.from(8), p)) %
            p;
      }
      return BigInt.from(-1);
    }

    BigInt rangeTop = p;
    for (BigInt b = BigInt.two; b < rangeTop; b += BigInt.one) {
      if (jacobi(b * b - BigInt.from(4) * a, p) == BigInt.from(-1)) {
        List<BigInt> f = [a, -b, BigInt.one];
        List<BigInt> ff = polynomial_exp_mod(
            [BigInt.zero, BigInt.one], (p + BigInt.one) ~/ BigInt.two, f, p);
        if (!(ff[1] == 0)) {
          throw Exception(['srmp']);
        }
        return ff[0];
      }
    }
    throw Exception(['srmp']);
  }

  List<BigInt> polynomial_reduce_mod(
      List<BigInt> poly, List<BigInt> polymod, BigInt p) {
    assert(polymod[-1] == BigInt.one);

    assert(polymod.length > 1);

    while (poly.length >= polymod.length) {
      if (poly[-1] != BigInt.zero) {
        for (int i = 2; i < polymod.length + 1; i++) {
          poly[-i] = (poly[poly.length - i] -
                  poly[poly.length - 1] * polymod[poly.length - i]) %
              p;
        }
      }
      poly = poly.sublist(0, poly.length - 1);
    }
    return poly;
  }

  List<BigInt> polynomial_multiply_mod(
      List<BigInt> m1, List<BigInt> m2, List<BigInt> polymod, BigInt p) {
    List<BigInt> prod =
        List<BigInt>.filled((m1.length + m2.length - 1), BigInt.zero);

    for (int i = 0; i < m1.length; i++) {
      for (int j = 0; j < m2.length; j++) {
        prod[i + j] = (prod[i + j] + m1[i] * m2[j]) % p;
      }
    }
    return polynomial_reduce_mod(prod, polymod, p);
  }

  List<BigInt> polynomial_exp_mod(
      List<BigInt> base, BigInt exponent, List<BigInt> polymod, BigInt p) {
    assert(exponent < p);

    if (exponent == BigInt.zero) {
      return [BigInt.one];
    }

    List<BigInt> G = base;
    BigInt k = exponent;
    List<BigInt> s;
    if (k % BigInt.two == BigInt.one) {
      s = G;
    } else {
      s = [BigInt.one];
    }

    while (k > BigInt.one) {
      k = k ~/ BigInt.two;
      G = polynomial_multiply_mod(G, G, polymod, p);
      if (k % BigInt.two == BigInt.one) {
        s = polynomial_multiply_mod(G, s, polymod, p);
      }
    }

    return s;
  }
}

main() {
  int myKeyIndex = 3;

  var pub_keys = [
    BigInt.parse(
        "106796914794365941029590955477759833492971384141416970831227660585732906202480"),
    BigInt.parse(
        "114304045427248237391922753844651658432317111645386286827488113176123620184519"),
    BigInt.parse(
        "33458576324051207416269679674752536950199746778021655933675753586286967591271"),
    BigInt.parse(
        "110452076032873631184811228032808144474523286758868558423802592600237088849656"),
    BigInt.parse(
        "46804842327670116306537165449763483414140501415023114236312611623426800152308"),
    BigInt.parse(
        "28394170371524835401420889066968091986280308546227099562813274173403045425273"),
    BigInt.parse(
        "24377684314135963055386437056785121263440998313429916493604886715720326850663"),
    BigInt.parse(
        "67131131321752850075978955767222964993685734666555900262316052255566279948124"),
    BigInt.parse(
        "82117509818995487259743241860708767710079459435126340981597320962770220274989"),
    BigInt.parse(
        "59816992311953849230737957310615071227934350560380425803949001979119080541261"),
    BigInt.parse(
        "31262064332185751030941147394147810753413234906694879978932512538379103118917"),
    BigInt.parse(
        "78652305106984111195689480033254652387139284882535989326621266337726361198979"),
    BigInt.parse(
        "28039700284136031125338919645451230509692227280382021112962651349129520818521"),
    BigInt.parse(
        "96739830825861634089353045065910032861257946952315071323525074310462450877062"),
    BigInt.parse(
        "70745726080842112939044575132193608683316940420026561904236145755609477025974"),
    BigInt.parse(
        "57710171067965812919594016510756929684748493880070765920287951258527413997390"),
    BigInt.parse(
        "86963971812811151621600949548013712753106316357780731627078269701451129156157"),
    BigInt.parse(
        "34524435231328353566123052024798884908646409158801517574140302339021059614180"),
    BigInt.parse(
        "77193071401374898105307778796101095394355907956417464722689582220953323803863"),
    BigInt.parse(
        "92438610242949519264528535638847009451796913260720761249946275160816723933502")
  ];
  var privateKey = BigInt.parse(
      "10847031540638908869647665033049572579030779063314235603902587403290407360655");
  List<AffinePoint> pubKeyList = [];
  for (int i = 0; i < pub_keys.length; i += 2) {
    pubKeyList.add(AffinePoint.fromXY(pub_keys[i], pub_keys[i + 1]));
  }
  Ring ring = Ring(pubKeyList);
  print(ring.sign("hello", myKeyIndex, privateKey));
}
