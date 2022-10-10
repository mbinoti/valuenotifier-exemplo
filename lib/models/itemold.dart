import 'package:demo4/models/item.dart';
import 'package:flutter/material.dart';

class Itemold {
  final int id;
  final String name;
  final Color color;
  final int price = 42;

  Itemold(this.id, this.name)
      // Para tornar o aplicativo de amostra mais bonito, cada item recebe uma das
      // Cores primárias do Material Design.

      : color = Colors.primaries[id % Colors.primaries.length];

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
