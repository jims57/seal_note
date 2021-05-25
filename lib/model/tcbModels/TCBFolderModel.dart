class TCBFolderModel {
  final int id;
  final String name;
  final int order;
  final bool isDefaultFolder;
  final int reviewPlanId;
  final bool isDeleted;

  TCBFolderModel({
    this.id,
    this.name,
    this.order,
    this.isDefaultFolder,
    this.reviewPlanId,
    this.isDeleted,
  });

  factory TCBFolderModel.fromHashMap(Map<dynamic, dynamic> tcbFolderHashMap) {
    return TCBFolderModel(
      id: tcbFolderHashMap['id'],
      name: tcbFolderHashMap['name'],
      order: tcbFolderHashMap['order'],
      isDefaultFolder: tcbFolderHashMap['isDefaultFolder'],
      reviewPlanId: tcbFolderHashMap['reviewPlanId'],
      isDeleted: tcbFolderHashMap['isDeleted'],
    );
  }

  static List<TCBFolderModel> convertHashMapListToModelList(
      {List<dynamic> hashMapList}) {
    var folderHashMapList = hashMapList;

    var folderList = folderHashMapList
        .map((folder) => TCBFolderModel.fromHashMap(folder))
        .toList();

    return folderList;
  }
}
