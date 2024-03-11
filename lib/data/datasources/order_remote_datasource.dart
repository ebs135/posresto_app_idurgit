import '../../core/constants/variables.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../presentation/home/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDatasource {
  //save order to remote server
  Future<bool> saveOrder(OrderModel orderModel) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/save-order'),
      body: orderModel.toJson(),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
