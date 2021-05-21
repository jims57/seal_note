import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
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
    T result,
  }) {
    ResponseModel<T> response = ResponseModel<T>();

    response.result = result;
    response.code = ErrorCodeModel.SUCCESS_CODE;
    response.message = ErrorCodeModel.SUCCESS_MESSAGE;

    return response;
  }

  static ResponseModel<T> getResponseModelForError<T>({
    // T result,
    @required int code,
    @required String message,
  }) {
    ResponseModel<T> response = ResponseModel<T>();

    // response.result = result;
    response.code = code;
    response.message = message;

    return response;
  }

  static ResponseModel<T> getResponseModelForUnknownError<T>() {
    var response = ResponseModel.getResponseModelForError<T>(
      code: ErrorCodeModel.UNKNOWN_ERROR_CODE,
      message: ErrorCodeModel.NETWORK_PROBLEM_MESSAGE,
    );

    return response;
  }

  static ResponseModel<T> getResponseModelForErrorAccordingToErrorType<T>(
      {@required dynamic err}) {
    var response;

    if (err is DioError) {
      DioError e = err;
      if (e.error is SocketException) {
        response = ResponseModel.getResponseModelForError<T>(
          code: ErrorCodeModel.NETWORK_PROBLEM_CODE,
          message: ErrorCodeModel.NETWORK_PROBLEM_MESSAGE,
        );
      } else {
        response = ResponseModel.getResponseModelForUnknownError<T>();
      }
    } else if (err is CloudBaseException) {
      CloudBaseException e = err;
      if (e.code ==
          ErrorCodeModel.TCB_STORAGE_FILE_NOT_EXISTENT_CODE_FROM_TCB) {
        response = ResponseModel.getResponseModelForError<T>(
          code: ErrorCodeModel.TCB_STORAGE_FILE_NOT_EXISTENT_CODE,
          message: ErrorCodeModel.TCB_STORAGE_FILE_NOT_EXISTENT_MESSAGE,
        );
      }
    } else {
      response = ResponseModel.getResponseModelForUnknownError<T>();
    }

    return response;
  }
}
