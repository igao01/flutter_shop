import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/confirm_dialog.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.name),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => CustomConfirmDialog(
                    title: 'Tem Certeza?',
                    content: 'Você deseja remover da loja?',
                    positiveOnPressed: () {
                      Provider.of<ProductList>(
                        context,
                        listen: false,
                      ).removeProduct(product);
                      Navigator.of(context).pop(true);
                    },
                    negativeOnPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
