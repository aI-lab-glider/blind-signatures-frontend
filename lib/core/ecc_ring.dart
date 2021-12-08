import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:elliptic/elliptic.dart';
import 'package:ninja_prime/ninja_prime.dart';
import 'package:pointycastle/pointycastle.dart';

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
      pk_message.add(publicKeys[i].X.toString());
      pk_message.add(publicKeys[i].Y.toString());
    }
    AffinePoint H = H2(pk_message);
    AffinePoint Y = ec.scalarMul(H, writeBigInt(privateKey));

    BigInt u = randomPrimeBigInt(256);

    AffinePoint GMulU = ec.scalarMul(ec.G, writeBigInt(u));
    AffinePoint HMulU = ec.scalarMul(H, writeBigInt(u));

    challenges[(myIndexKey + 1) % amountOfKeys] = H1([
      ...pk_message,
      Y.X.toString(),
      Y.Y.toString(),
      message,
      GMulU.X.toString(),
      GMulU.Y.toString(),
      HMulU.X.toString(),
      HMulU.Y.toString()
    ]);

    for (int i = myIndexKey + 1; i < amountOfKeys; i++) {
      signatures[i] = randomBigInt(256);

      var z_1 = ec.add((ec.scalarMul(ec.G, writeBigInt(signatures[i]))),
          (ec.scalarMul(publicKeys[i], writeBigInt(challenges[i]))));
      var z_2 = ec.add((ec.scalarMul(H, writeBigInt(signatures[i]))),
          (ec.scalarMul(Y, writeBigInt(challenges[i]))));
      challenges[(i + 1) % amountOfKeys] = H1([
        ...pk_message,
        Y.X.toString(),
        Y.Y.toString(),
        message,
        z_1.X.toString(),
        z_1.Y.toString(),
        z_2.X.toString(),
        z_2.Y.toString()
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
        Y.X.toString(),
        Y.Y.toString(),
        message,
        z_1.X.toString(),
        z_1.Y.toString(),
        z_2.X.toString(),
        z_2.Y.toString()
      ]);
    }
    signatures[myIndexKey] = (u - privateKey * challenges[myIndexKey]) % ec.n;
    return([challenges[0], ...signatures, Y.X, Y.Y]);
  }

  BigInt H1(List<String> message) {
    String finalString = "";
    for (int i = 0; i < message.length; i++) {
      var bytes = utf8.encode(message[i]);
      var digest = sha256.convert(bytes);
      finalString += digest.toString();
    }
    return BigInt.parse(finalString, radix: 16);
  }

  Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = new BigInt.from(256);
    var result = new Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
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
      print(fX);
      print(ec.p);
      y = GFG().STonelli(fX, ec.p);
      if (y != BigInt.from(-1)) {
        found = true;
      }
    }
    return AffinePoint.fromXY(x, y);
  }
}

class GFG {
  BigInt z = BigInt.zero;

// utility function to find
// pow(base, exponent) % modulus
  BigInt pow1(BigInt base1, BigInt exponent, BigInt modulus) {
    BigInt result = BigInt.one;
    base1 = base1 % modulus;
    while (exponent > BigInt.zero) {
      if (exponent % BigInt.two == BigInt.one) {
        result = (result * base1) % modulus;
      }
      exponent = exponent >> 1;
      base1 = (base1 * base1) % modulus;
    }
    return result;
  }

// utility function to find gcd
  BigInt gcd(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      return a;
    } else {
      return gcd(b, a % b);
    }
  }

// Returns k such that b^k = 1 (mod p)
  BigInt order(BigInt p, BigInt b) {
    if (gcd(p, b) != BigInt.one) {
      print("p and b are" + "not co-prime.");
      return BigInt.from(-1);
    }

    // Initializing k with first
    // odd prime number
    BigInt k = BigInt.from(3);
    while (true) {
      if (pow1(b, k, p) == BigInt.one) {
        return k;
      }
      k += BigInt.one;
    }
  }

// function return p - 1 (= x argument)
// as x * 2^e, where x will be odd
// sending e as reference because
// updation is needed in actual e
  BigInt convertx2e(BigInt x) {
    z = BigInt.zero;
    while (x % BigInt.two == BigInt.zero) {
      x ~/= BigInt.two;
      z += BigInt.one;
    }
    return x;
  }

// Main function for finding
// the modular square root
  BigInt STonelli(BigInt n, BigInt p) {
    // a and p should be coprime for
    // finding the modular square root
    if (gcd(n, p) != BigInt.one) {
      print("a and p are not coprime");
      return BigInt.from(-1);
    }

    // If below expression return (p - 1) then modular
    // square root is not possible
    if (pow1(n, (p - BigInt.one) ~/ BigInt.two, p) == (p - BigInt.one)) {
      print("no sqrt possible");
      return BigInt.from(-1);
    }

    // expressing p - 1, in terms of
    // s * 2^e, where s is odd number
    BigInt s, e;
    s = convertx2e(p - BigInt.one);
    e = z;

    // finding smallest q such that q ^ ((p - 1) / 2)
    // (mod p) = p - 1
    BigInt q;
    for (q = BigInt.two;; q += BigInt.one) {
      // q - 1 is in place of (-1 % p)
      if (pow1(q, (p - BigInt.one) ~/ BigInt.two, p) == (p - BigInt.one)) break;
    }

    // Initializing variable x, b and g
    BigInt x = pow1(n, (s + BigInt.one) ~/ BigInt.two, p);
    BigInt b = pow1(n, s, p);
    BigInt g = pow1(q, s, p);

    int r = e.toInt();

    // keep looping until b
    // become 1 or m becomes 0
    while (true) {
      int m;
      for (m = 0; m < r; m++) {
        if (order(p, b) == BigInt.from(-1)) {
          return BigInt.from(-1);
        }

        // finding m such that b^ (2^m) = 1
        if (order(p, b) == BigInt.two.pow(m)) {
          break;
        }
      }
      if (m == 0) {
        return x;
      }

      // updating value of x, g and b
      // according to algorithm
      print(r);
      print(m);
      x = (x * pow1(g, BigInt.two.pow(r - m - 1), p)) % p;
      g = pow1(g, BigInt.two.pow(r - m), p);
      b = (b * g) % p;

      if (b == BigInt.one) {
        return x;
      }
      r = m;
    }
  }
}

main() {
  int myKeyIndex = 3;

  var pub_keys = [BigInt.parse("106796914794365941029590955477759833492971384141416970831227660585732906202480"), BigInt.parse("114304045427248237391922753844651658432317111645386286827488113176123620184519"),BigInt.parse("33458576324051207416269679674752536950199746778021655933675753586286967591271"), BigInt.parse("110452076032873631184811228032808144474523286758868558423802592600237088849656"),BigInt.parse("46804842327670116306537165449763483414140501415023114236312611623426800152308"), BigInt.parse("28394170371524835401420889066968091986280308546227099562813274173403045425273"),BigInt.parse("24377684314135963055386437056785121263440998313429916493604886715720326850663"), BigInt.parse("67131131321752850075978955767222964993685734666555900262316052255566279948124"),BigInt.parse("82117509818995487259743241860708767710079459435126340981597320962770220274989"), BigInt.parse("59816992311953849230737957310615071227934350560380425803949001979119080541261"),BigInt.parse("31262064332185751030941147394147810753413234906694879978932512538379103118917"), BigInt.parse("78652305106984111195689480033254652387139284882535989326621266337726361198979"),BigInt.parse("28039700284136031125338919645451230509692227280382021112962651349129520818521"), BigInt.parse("96739830825861634089353045065910032861257946952315071323525074310462450877062"),BigInt.parse("70745726080842112939044575132193608683316940420026561904236145755609477025974"), BigInt.parse("57710171067965812919594016510756929684748493880070765920287951258527413997390"),BigInt.parse("86963971812811151621600949548013712753106316357780731627078269701451129156157"), BigInt.parse("34524435231328353566123052024798884908646409158801517574140302339021059614180"),BigInt.parse("77193071401374898105307778796101095394355907956417464722689582220953323803863"), BigInt.parse("92438610242949519264528535638847009451796913260720761249946275160816723933502")];
  var privateKey = BigInt.parse("10847031540638908869647665033049572579030779063314235603902587403290407360655");
  List<AffinePoint> pubKeyList = [];
  for (int i = 0; i <pub_keys.length; i+=2){
    pubKeyList.add(AffinePoint.fromXY(pub_keys[i], pub_keys[i+1]));
  }
  Ring ring = Ring(pubKeyList);
  print(ring.sign("hello", myKeyIndex, privateKey));
}

