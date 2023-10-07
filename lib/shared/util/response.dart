import 'package:flamingo/shared/util/error_message_factory.dart';
import 'package:flamingo/shared/enum/response_state.dart';

class Response<ResultType> {
  ResponseState? state;
  ResultType? data;
  String? exception;

  Response({this.state, this.data, this.exception});

  Response.loading() {
    this.state = ResponseState.loading;
  }

  Response.complete(this.data) {
    this.state = ResponseState.complete;
  }

  Response.error(dynamic exception) {
    this.state = ResponseState.error;
    this.exception = ErrorMessageFactory.createMessage(exception);
  }

  bool get isLoading => state == ResponseState.loading;
  bool get hasCompleted => state == ResponseState.complete;
  bool get hasError => state == ResponseState.error;
}
