class TCBNoteModel {
  final int id;
  final int folderId;
  final String content;
  final bool isDeleted;

  TCBNoteModel({
    this.id,
    this.folderId,
    this.content,
    this.isDeleted,
  });

  factory TCBNoteModel.fromHashMap(Map<dynamic, dynamic> tcbNoteHashMap) {
    return TCBNoteModel(
      id: tcbNoteHashMap['id'],
      folderId: tcbNoteHashMap['folderId'],
      content: tcbNoteHashMap['content'],
      isDeleted: tcbNoteHashMap['isDeleted'],
    );
  }

  static List<TCBNoteModel> convertHashMapListToModelList(
      {List<dynamic> hashMapList}) {
    var noteHashMapList = hashMapList;

    var noteList =
        noteHashMapList.map((note) => TCBNoteModel.fromHashMap(note)).toList();

    return noteList;
  }
}
