import 'package:dio/dio.dart';


class HttpClientConstructor {
  final Function(dynamic defaults) createClient;

  HttpClientConstructor(this.createClient);
}

class HttpClientParams<DTO, DQO> {
  final String path;
  final String method;
  final DTO? body;
  final DQO? query;
  final Map<String, dynamic>? options;

  HttpClientParams({
    required this.path,
    required this.method,
    this.body,
    this.query,
    this.options,
  });
}

class HttpClientResolverError {
  final String message;
  final int statusCode;

  HttpClientResolverError({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'message: $message, statusCode: $statusCode';
  }
}

typedef HttpClientResolverDTO<T> = Map<String, dynamic>;


class HttpService {
  late final Dio dio;
  late final String token;

  HttpService({required this.dio, required this.token});

  static const apiEndpoint = "https://api.smtpexpress.com";

  Future<HttpClientResolverDTO<T>> resolver<T>(Future<Response> fn,) async {
    Map<String, dynamic>? data;
    HttpClientResolverError? error;


    try {

      final response = await fn;
      if (response.statusCode == 200 || response.statusCode == 201) {
        data = response.data;
      } else {
        error = HttpClientResolverError(
          message: response.statusMessage!,
          statusCode: response.statusCode!,
        );
      }
    } on DioException catch (e) {
      error = HttpClientResolverError(
        message: e.response!.statusMessage.toString(),
        statusCode: e.response!.statusCode!.toInt(),
      );
    }

    final resolvedResponse = {'data': data, 'error': error};
    return Future.value(resolvedResponse);
  }


  Future<HttpClientResolverDTO<dynamic>> sendRequest(
      HttpClientParams params,
      ) async {

    return resolver(
        dio.post(
          apiEndpoint + params.path,
          data: params.body,
        )
    );
  }
}