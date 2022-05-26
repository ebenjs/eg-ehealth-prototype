import 'package:prototype_e_health/prototype_e_health.dart'
    as prototype_e_health;
import 'dart:io';

import 'package:test/test.dart';

void main(List<String> arguments) {
  chooseService();
}

void chooseService() {
  print('Bonjour et bienvenue sur SmartHospital\nChoisissez un service :');
  print('[1] Commande de produits pharmaceutiques');
  print('[2] Consultation en ligne');
  int service = getCorrectValue(true, rangeBegin: 1, rangeEnd: 2);
  service == 1 ? orderProduct() : comingSoon();
}

void comingSoon() {
  print(
      'Ce service n\'est pas encore disponible. Merci pour votre compréhension.');
}

void orderProduct() {
  List<Product> products = <Product>[];
  products.add(new Product("Paracétamol", variants: <Variant>[
    new Variant('Paracétamol 200mg', 200),
    new Variant('Paracétamol 500mg', 400)
  ]));
  products.add(new Product("Diclofenac", variants: <Variant>[
    new Variant('Diclo 150mg', 595),
    new Variant('Diclo 300mg', 990)
  ]));
  products.add(new Product("Lumartem", price: 2350));
  print('Que voulez-vous commander?');
  products
      .asMap()
      .forEach((index, element) => print('[${index + 1}] ${element.name}'));
  int productId = getCorrectValue(true, rangeBegin: 1, rangeEnd: 3);
  Product product = products.elementAt(productId - 1);

  if(product.variants.isNotEmpty){
    product = chooseVariante(product);
  }
  bool paid = pay(product);
  paid ? print('Paiement effectué avec succes.') : print('Vous pouvez revenir a tout moment.');
  print('Merci pour votre visite!');
}

Variant chooseVariante(Product product){
  print('Choisissez une variante pour ce produit : ${product.name}');
  product.variants.asMap().forEach((index, element) => print('[${index+1}] ${element.name}'));
  int variantId = getCorrectValue(true, rangeBegin: 1, rangeEnd: product.variants.length);
  return product.variants.elementAt(variantId-1);
}
bool pay(Product product){
  print('Etes-vous sur de vouloir payer la somme de ${product.price} contre le produit ${product.name} ?');
  bool result = getCorrectValueYesOrNo();
  return result;
}
int getCorrectValue(bool exitApp, {rangeBegin: 0, rangeEnd: 0}) {
  int finalValue = -1;
  try {
    final int result = int.parse(stdin.readLineSync()!);
    if ((rangeBegin == 0 && rangeEnd == 0) ||
        (rangeBegin <= result && result <= rangeEnd)) {
      finalValue = result;
    } else {
      finalValue = -1;
    }
  } on FormatException {
    print('Erreur : Saisissez une bonne valeur.');
    exitApp ? exit(-1) : finalValue = -1;
  }

  return finalValue;
}

bool getCorrectValueYesOrNo() {
  final String result = stdin.readLineSync()!;
  if(result.toLowerCase() == 'oui'){
    return true;
  }else {
    return false;
  }
}

class Product {
  String name;
  var price;
  List<Variant> variants = [];

  Product(this.name, {variants: const <Variant>[], price: null}) {
    this.price = price;
    this.variants = variants;
  }
}

class Variant extends Product {
  Variant(super.name, int price) {
    this.price = price;
  }
}
