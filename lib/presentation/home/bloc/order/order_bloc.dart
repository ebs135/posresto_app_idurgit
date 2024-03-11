import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../../data/datasources/auth_local_datasource.dart';
import '../../../../data/datasources/product_local_datasaource.dart';
import '../../../../core/core.dart';
import '../../models/order_model.dart';
import '../../models/product_quantity.dart';

part 'order_bloc.freezed.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());

      //save to local storage
      // this.id,
      // required this.paymentAmount,
      // required this.subTotal,
      // required this.tax,
      // required this.discount,
      // required this.serviceCharge,
      // required this.total,
      // required this.paymentMethod,
      // required this.totalItem,
      // required this.idKasir,
      // required this.namaKasir,
      // required this.transactionTime,
      // required this.isSync,
      // required this.orderItems,
      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.replaceAll('.00', '').toIntegerFromText *
                  element.quantity));

      // final total = subTotal + event.tax + event.serviceCharge - event.discount;
      final total =
          (subTotal - event.discount) + (event.tax + event.serviceCharge);
      
      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);
      
      final userData = await AuthLocalDatasource().getAuthData();
      
      final dataInput = OrderModel(
        subTotal: subTotal,
        paymentAmount: event.paymentAmount,
        tax: event.tax,
        discount: event.discount,
        serviceCharge: event.serviceCharge,
        total: total,
        paymentMethod: 'Cash',
        totalItem: totalItem,
        idKasir: userData.user!.id!,
        namaKasir: userData.user!.name!,
        transactionTime: DateFormat.yMd().format(DateTime.now()),
        isSync: 0,
        orderItems: event.items,
      );

      await ProductLocalDatasource.instance.saveOrder(dataInput);

      emit(_Loaded(dataInput));
    });
  }
}
