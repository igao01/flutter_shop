import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final _itemHeight = widget.order.products.length * 25.0 + 40;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? _itemHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () => setState(() {
                  _expanded = !_expanded;
                }),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              // altura do container é baseada na quantidade de itens
              height: _expanded ? _itemHeight : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),

              child: ListView(
                children: widget.order.products.map((product) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ),
                          Text(
                            '${product.quantity}x R\$ ${product.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      widget.order.products.length > 1
                          ? const Divider()
                          : const SizedBox(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
