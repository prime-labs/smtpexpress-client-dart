
import 'package:dio/dio.dart';
import 'package:smtpexpress/apis/send_api.dart';
import 'package:smtpexpress/helpers/types.dart';

import 'http_service.dart';

Client createClient(CredentialOptions credentials) {
  final projectId = credentials.projectId;
  final projectSecret = credentials.projectSecret;

  final dio = Dio();
  dio.options
  ..baseUrl = ''
  ..headers = {
    'Authorization': 'Bearer $projectSecret'
  };
  
  final httpService = HttpService(
      dio: dio,
      token: projectSecret,
  );

  return Client(
    sendApi: SendApi(httpService),
  );
}

class Client {
  final SendApi sendApi;

  Client({required this.sendApi});
}
