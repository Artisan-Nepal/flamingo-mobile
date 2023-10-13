import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flamingo/shared/constant/message/message.dart';
import 'package:flamingo/data/remote/api_exceptions.dart';

class ErrorMessageFactory {
  static String createMessage(Exception exception) {
    if (exception is NetworkNotAvailableException) {
      return exception.message.toString();
    } else if (exception is FailedResponseException) {
      return exception.message.toString();
    } else if (exception is SocketException) {
      return ErrorMessages.noConnection;
    } else if (exception is TimeoutException) {
      return ErrorMessages.connectionTimedOut;
    } else if (exception is DioException) {
      if (exception.response?.data != null) {
        return exception.response!.data['message'];
      } else {
        switch (exception.type) {
          case DioExceptionType.connectionError:
            return ErrorMessages.noConnection;

          case DioExceptionType.cancel:
            return ErrorMessages.requestCancelled;

          case DioExceptionType.connectionTimeout:
            return ErrorMessages.connectionTimedOut;

          default:
            return ErrorMessages.defaultError;
        }
      }
    } else {
      return ErrorMessages.defaultError;
    }
  }
}
