import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

/*

  ESTE ARQUIVO NÃO FAZ PARTE DA APLICAÇÃO
  FOI UTILIZADO SOMENTE DURANTE A AULA 
  SOBRE InheritedWidget

*/

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(provider!.state.value.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    provider.state.increment();
                  });
                },
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    provider.state.decrement();
                  });
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          )
        ],
      ),
    );
  }
}
