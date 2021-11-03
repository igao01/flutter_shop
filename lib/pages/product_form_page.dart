import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  // variável que controla o foco do campo preço
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // verifica se os dados do formulario estao vazios
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)!.settings.arguments;

      // verifica se há um produto passado pelo arguments
      if (arg != null) {
        final product = arg as Product;

        // passa os valores recebidos no arguments
        // para o formulário
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFocus.dispose();
    _priceFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  // Atualiza a exibição da imagem no formulário
  void updateImage() {
    setState(() {});
  }

  // verifica se a url da imagem é valida
  bool isValidImageUrl(String url) {
    // verifica se é uma url
    bool isValidUrl = Uri.tryParse(url)!.hasAbsolutePath;

    // verifica se termina com as extensoes png, jpg ou jpeg
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  // envia o formulario
  void _submitForm() {
    // verifica se o formulário é valido
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    // salva o formulario
    _formKey.currentState!.save();

    // salva os dados chamando o provider
    // e passando os dados do form como parâmetro
    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(_formData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                // carrega o campo com a informação do produto
                initialValue: _formData['name'],
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
                textInputAction: TextInputAction.next,
                //muda o focu para o campo preço
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (name) => _formData['name'] = (name ?? ''),
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return 'O nome precisa conter no mínimo 3 letras';
                  }
                },
              ),
              TextFormField(
                initialValue: _formData['price'].toString(),
                decoration: const InputDecoration(
                  label: Text('Preço'),
                ),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (price) =>
                    _formData['price'] = (double.parse(price ?? '0')),
                validator: (_price) {
                  final priceString = _price ?? '';
                  final price = double.tryParse(priceString) ?? -1;

                  if (priceString.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }

                  if (price <= 0) {
                    return 'Informe um preço válido';
                  }
                },
              ),
              TextFormField(
                initialValue: _formData['description'],
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                ),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocus,
                // cria um campo de texto com 3 linhas
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    _formData['description'] = (description ?? ''),
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }

                  if (description.trim().length < 10) {
                    return 'A descrição precisa conter no mínimo 10 letras';
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('URL da imagem'),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = (imageUrl ?? ''),
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';

                        if (imageUrl.trim().isEmpty) {
                          return 'Campo obrigatório';
                        }

                        if (!isValidImageUrl(imageUrl)) {
                          return 'Informe uma url válida!';
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Informe a url')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              width: 100,
                              height: 100,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
