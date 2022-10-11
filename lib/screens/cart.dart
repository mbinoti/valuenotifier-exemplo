import 'package:demo4/models/cart_model.dart';
import 'package:demo4/models/item.dart';
import 'package:demo4/screens/catalog_list.dart';

import 'package:flutter/material.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  // final _carts = CartModel();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: ValueListenableBuilder<List<Item>>(
                  valueListenable: MyCatalog.cartItems,
                  builder: (_, value, __) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          leading: const Icon(Icons.done),
                          title: Text(value[index].name),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              // ignore: list_remove_unrelated_type
                              MyCatalog.cartItems.value.removeAt(index);
                              MyCatalog.cartItems.notifyListeners();

                              initState();
                              // MyCatalog.remove(item);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    // Isso obtém o estado atual do CartModel e também informa ao Flutter
    // para reconstruir este widget quando o CartModel notificar os ouvintes (em outras palavras,
    // quando muda).
    CartModel cart = CartModel();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: const Icon(Icons.done),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => cart.remove(cart.items[index]),
          ),
          title: Text(cart.items[index].name, style: itemNameStyle),
        );
      },
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline1!.copyWith(fontSize: 48);

    int sumTotalPrice() {
      // final numbers = <double>[10, 2, 5, 0.5];
      // const initialValue = 100.0;
      // final result = numbers.fold<double>(
      //     initialValue, (previousValue, element) => previousValue + element);
      // print(result);

      int initialValue = 0;
      final numbers = MyCatalog.cartItems.value.fold<int>(initialValue,
          (previousValue, element) => previousValue + element.price);

      return numbers;
    }

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${sumTotalPrice()}'),
            const SizedBox(width: 24),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buying not supported yet.')));
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
