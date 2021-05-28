import 'package:moor/moor.dart' show Value;

class IDHandler {
  static Value<int> getMoorCompanionValueId({int id}) {
    var valueId = (id == null) ? Value<int>.absent() : Value(id);

    return valueId;
  }
}
