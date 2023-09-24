import 'package:example_app_1/domain/whisky_best_distilleries.dart';
import 'package:example_app_1/domain/whisky_manager.dart';
import 'package:example_app_1/presentation/whisky_results_cubic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.whiskyManager});

  final WhiskyManager whiskyManager;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisky Distilleries Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => WhiskyResultsCubic([]),
        child: MyHomePage(whiskyManager: whiskyManager),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.whiskyManager});

  final WhiskyManager whiskyManager;
  int minimumVotes = 0;
  double minimumRating = 0.0;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final whiskyResultsCubit = context.read<WhiskyResultsCubic>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whisky Distilleries Search'),
      ),
      body: BlocBuilder<WhiskyResultsCubic, List<WhiskyBestDistilleries>>(
        builder: (context, results) {
          // TODO: could be changed to bloc state pattern or even open a
          // new route (w/ navigator) to make it easier control the Form page
          // ...it's also missing the ErrorState and EmptyState
          final isSuccessState = results.isEmpty;
          if (isSuccessState) {
            return SearchForm(
              setMinimumVotes: setMinimumVotes,
              setMinimumRating: setMinimumRating,
            );
          } else {
            return WhiskyBestDistilleriesResults(results: results);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bestDistilleries =
              await widget.whiskyManager.getBestDistilleries(
            widget.minimumVotes,
            widget.minimumRating,
          );
          whiskyResultsCubit.showResultsInDescOrder(bestDistilleries);
        },
        tooltip: 'Search',
        child: const Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // TODO: could be moved to bloc event pattern
  void setMinimumVotes(newInput) {
    setState(() {
      widget.minimumVotes = int.tryParse(newInput) ?? 0;
    });
  }

  // TODO: could be moved to bloc event pattern
  void setMinimumRating(newInput) {
    setState(() {
      widget.minimumRating = double.tryParse(newInput) ?? 0.0;
    });
  }
}

class WhiskyBestDistilleriesResults extends StatelessWidget {
  const WhiskyBestDistilleriesResults({
    super.key,
    required this.results,
  });

  final List<WhiskyBestDistilleries> results;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ListView.builder(
        itemCount: results.length,
        prototypeItem: ListTile(
          title: Text(results.first.toString()),
        ),
        itemBuilder: (context, index) => ListTile(
          title: Text('Distillery: ${results[index].name}'),
          subtitle: Text('Country: ${results[index].country}'),
          trailing: Text('Rating: ${results[index].rating}'),
        ),
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({
    super.key,
    required this.setMinimumVotes,
    required this.setMinimumRating,
  });

  final void Function(String newInput) setMinimumVotes;
  final void Function(String newInput) setMinimumRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Enter the desired filters',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            key: const ValueKey('votes-field'),
            onChanged: (text) => setMinimumVotes(text),
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Minimum Rating',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            key: const ValueKey('rating-field'),
            onChanged: (text) => setMinimumRating(text),
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Minimum Votes',
            ),
            keyboardType: TextInputType.number,
          ),
        )
      ],
    );
  }
}
