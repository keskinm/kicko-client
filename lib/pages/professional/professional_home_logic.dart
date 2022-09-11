import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';

class ProfessionalHomeLogic{

  Future<List> getJobOffers() async {
    Response response = await dioHttpGet(
      route: 'get_job_offers',
      token: false,
    );
    return response.data;
  }

  void updateJobOffers(
      {required String backlog}) async {
    await dioHttpPost(
      route: 'update_business',
      jsonData: backlog,
      token: false,
    );
  }

  void updateBusiness(
      {required String backlog}) async {
    await dioHttpPost(
      route: 'update_business',
      jsonData: backlog,
      token: false,
    );
  }

  Future<List> getBusiness() async {
    Response response = await dioHttpGet(
      route: 'get_business',
      token: false,
    );
    return response.data;
  }


}