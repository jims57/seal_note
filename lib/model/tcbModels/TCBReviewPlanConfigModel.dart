import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/database/database.dart';

class TCBReviewPlanConfigModel {
  final int id;
  final int reviewPlanId;
  final int order;
  final int value;
  final int unit;

  TCBReviewPlanConfigModel({
    this.id,
    this.reviewPlanId,
    this.order,
    this.value,
    this.unit,
  });

  factory TCBReviewPlanConfigModel.fromHashMap(
      Map<dynamic, dynamic> tcbReviewPlanHashMap) {
    return TCBReviewPlanConfigModel(
      id: tcbReviewPlanHashMap['id'],
      reviewPlanId: tcbReviewPlanHashMap['reviewPlanId'],
      order: tcbReviewPlanHashMap['order'],
      value: tcbReviewPlanHashMap['value'],
      unit: tcbReviewPlanHashMap['unit'],
    );
  }

  static List<TCBReviewPlanConfigModel> convertHashMapListToModelList(
      {List<dynamic> hashMapList}) {
    var reviewPlanConfigHashMapList = hashMapList;

    var reviewPlanConfigList = reviewPlanConfigHashMapList
        .map((reviewPlanConfig) =>
            TCBReviewPlanConfigModel.fromHashMap(reviewPlanConfig))
        .toList();

    return reviewPlanConfigList;
  }

  static List<ReviewPlanConfigsCompanion>
      convertTCBReviewPlanConfigModelListToReviewPlanConfigsCompanionList({
    @required List<TCBReviewPlanConfigModel> tcbReviewPlanConfigModelList,
  }) {
    var reviewPlanConfigsCompanionList = <ReviewPlanConfigsCompanion>[];

    for (var tcbReviewPlanConfigModel in tcbReviewPlanConfigModelList) {
      reviewPlanConfigsCompanionList.add(ReviewPlanConfigsCompanion(
        id: Value(tcbReviewPlanConfigModel.id),
        reviewPlanId: Value(tcbReviewPlanConfigModel.reviewPlanId),
        order: Value(tcbReviewPlanConfigModel.order),
        value: Value(tcbReviewPlanConfigModel.value),
        unit: Value(tcbReviewPlanConfigModel.unit),
      ));
    }

    return reviewPlanConfigsCompanionList;
  }
}
