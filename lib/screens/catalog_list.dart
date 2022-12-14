import 'package:demo4/models/cart_model.dart';
import 'package:demo4/models/catalog_model.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class MyCatalog extends StatefulWidget {
  static final ValueNotifier<List<Item>> cartItems =
      ValueNotifier<List<Item>>([]);

  /// Internal, private state of the cart. Stores the ids of each item.2
  static final List<int> _itemIds = [];

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  static void add(Item item) {
    _itemIds.add(item.id);

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    // notifyListeners();
  }

  static void remove(Item item) {
    _itemIds.remove(item.id);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    // notifyListeners();
  }

  @override
  State<MyCatalog> createState() => _MyCatalogState();
}

class _MyCatalogState extends State<MyCatalog> {
  late CatalogModel _catalog;

  /// The current catalog. Used to construct items from numeric ids.3
  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    // notifyListeners();
  }

  /// List of items in the cart.
  List<Item> get items =>
      MyCatalog._itemIds.map((id) => _catalog.getById(id)).toList();

  /// The current total price of all items.
  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<List<Item>>(
        valueListenable: MyCatalog.cartItems,
        builder: (context, value, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Catalog',
                    style: Theme.of(context).textTheme.headline1),
                floating: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                ],
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _MyListItem(index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    var item = CatalogModel().getByPosition(index);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                    color: CatalogModel().getByPosition(index).color)),
            const SizedBox(width: 24),
            Expanded(
                child: Text(CatalogModel().getByPosition(index).name,
                    style: Theme.of(context).textTheme.headline6)),
            const SizedBox(width: 24),
            TextButton(
              // ignore: iterable_contains_unrelated_type
              onPressed: () {
                final existe = MyCatalog.cartItems.value
                    .where((element) => element.name == item.name.toString());
                if (existe.isEmpty) {
                  MyCatalog.cartItems.value.add(item);
                  MyCatalog.cartItems.notifyListeners();
                } else {
                  MyCatalog.cartItems.value.removeAt(index);
                  MyCatalog.cartItems.notifyListeners();
                }
              },
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              child: MyCatalog.cartItems.value
                      .where((element) => element.name == item.name.toString())
                      .isNotEmpty
                  ? const Icon(
                      Icons.check,
                      color: Colors.black,
                    )
                  : const Text('ADD', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    // O m??todo context.select() permitir?? que voc?? ou??a as altera????es de
    // uma *parte* de um modelo.
    // Voc?? define uma fun????o que "seleciona" (ou seja, retorna)
    // a parte em que voc?? est?? interessado e o pacote do provedor n??o ser?? reconstru??do
    // este widget, a menos que essa parte espec??fica do modelo seja alterada.
    //
    // Isso pode levar a melhorias significativas de desempenho.
    var isInCart = CartModel().items.contains(item);

    return TextButton(
      onPressed: isInCart
          ? null
          : () {
              // Se o item n??o estiver no carrinho, deixamos o usu??rio adicion??-lo.
              // Estamos usando context.read() aqui porque o retorno de chamada
              // ?? executado sempre que o usu??rio toca no bot??o. Em outros
              // palavras, ele ?? executado fora do m??todo build.
              var cart = CartModel();
              cart.add(item);
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInCart
          ? const Icon(Icons.check, semanticLabel: 'ADDED')
          : const Text('ADD'),
    );
  }
}
