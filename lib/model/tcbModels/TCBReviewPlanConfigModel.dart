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
}
