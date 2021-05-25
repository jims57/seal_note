class TCBReviewPlanModel {
  final int id;
  final String name;
  final String introduction;

  TCBReviewPlanModel({
    this.id,
    this.name,
    this.introduction,
  });

  factory TCBReviewPlanModel.fromHashMap(
      Map<dynamic, dynamic> tcbReviewPlanHashMap) {
    return TCBReviewPlanModel(
      id: tcbReviewPlanHashMap['id'],
      name: tcbReviewPlanHashMap['name'],
      introduction: tcbReviewPlanHashMap['introduction'],
    );
  }

  static List<TCBReviewPlanModel> convertHashMapListToModelList(
      {List<dynamic> hashMapList}) {
    var reviewPlanHashMapList = hashMapList;

    var reviewPlanList = reviewPlanHashMapList
        .map((reviewPlan) => TCBReviewPlanModel.fromHashMap(reviewPlan))
        .toList();

    return reviewPlanList;
  }
}
