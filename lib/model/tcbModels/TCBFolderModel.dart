class TCBFolderModel {
  final int id;
  final String name;
  final int order;
  final bool isDefaultFolder;
  final DateTime created;
  final bool isDeleted;
  final int createdBy;

  TCBFolderModel({
    this.id,
    this.name,
    this.order,
    this.isDefaultFolder,
    this.created,
    this.isDeleted,
    this.createdBy,
  });

  factory TCBFolderModel.fromHashMap(Map<dynamic, dynamic> tcbFolderHashMap) {
    return TCBFolderModel(
      id: tcbFolderHashMap['id'],
      name: tcbFolderHashMap['name'],
      order: tcbFolderHashMap['order'],
      isDefaultFolder: tcbFolderHashMap['isDefaultFolder'],
      created: tcbFolderHashMap['created'],
      isDeleted: tcbFolderHashMap['isDeleted'],
      createdBy: tcbFolderHashMap['createdBy'],
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
