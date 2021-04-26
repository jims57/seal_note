import 'package:flutter/cupertino.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';

class ResponseModel<T> {
  T result;
  int code;
  String message;

  ResponseModel({
    this.result,
    this.code,
    this.message,
  });

  // Public methods
  static ResponseModel<T> getResponseModelForSuccess<T>({
    @required T result,
  }) {
    ResponseModel<T> response = ResponseModel<T>();

    response.result = result;
    response.code = ErrorCodeModel.SUCCESS_CODE;
    response.message = ErrorCodeModel.SUCCESS_MESSAGE;

    return response;
  }

  static ResponseModel<T> getResponseModelForError<T>({
    @required int code,
    @required String message,
  }) {
    ResponseModel<T> response = ResponseModel<T>();

    response.code = code;
    response.message = message;

    return response;
  }

  static ResponseModel<T> getResponseModelForTCBError<T>({
    @required dynamic err,
  }) {
    return getResponseModelForError(code: err?.code, message: err?.message);
  }
}
