import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app_rudisupratman/data/datasources/product_local_datasaource.dart';
import 'package:flutter_posresto_app_rudisupratman/presentation/setting/bloc/sync_product/sync_product_bloc.dart';

import '../bloc/sync_order/sync_order_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data Console'),
      ),
      body: Column(children: [
        BlocConsumer<SyncProductBloc, SyncProductState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              loaded: (productResponseModel) {
                ProductLocalDatasource.instance.deleteAllProducts();
                ProductLocalDatasource.instance.insertProducts(
                  productResponseModel.data!,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sync product success'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return ElevatedButton(
                  onPressed: () {
                    context
                        .read<SyncProductBloc>()
                        .add(const SyncProductEvent.syncProduct());
                  },
                  child: const Text('Sync Products'),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ),
        BlocConsumer<SyncOrderBloc, SyncOrderState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              loaded: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sync Order Success'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return ElevatedButton(
                  onPressed: () {
                    context
                        .read<SyncOrderBloc>()
                        .add(const SyncOrderEvent.syncOrder());
                  },
                  child: const Text('Sync Orders'),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        )
      ]),
    );
  }
}
