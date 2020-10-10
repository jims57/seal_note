// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class NoteEntry extends DataClass implements Insertable<NoteEntry> {
  final int id;
  final String title;
  final String content;
  final DateTime created;
  NoteEntry(
      {@required this.id, @required this.title, this.content, this.created});
  factory NoteEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return NoteEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      created: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || created != null) {
      map['created'] = Variable<DateTime>(created);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
    );
  }

  factory NoteEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NoteEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      created: serializer.fromJson<DateTime>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'created': serializer.toJson<DateTime>(created),
    };
  }

  NoteEntry copyWith(
          {int id, String title, String content, DateTime created}) =>
      NoteEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        created: created ?? this.created,
      );
  @override
  String toString() {
    return (StringBuffer('NoteEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(title.hashCode, $mrjc(content.hashCode, created.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NoteEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.created == this.created);
}

class NotesCompanion extends UpdateCompanion<NoteEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> created;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.created = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    this.content = const Value.absent(),
    this.created = const Value.absent(),
  }) : title = Value(title);
  static Insertable<NoteEntry> custom({
    Expression<int> id,
    Expression<String> title,
    Expression<String> content,
    Expression<DateTime> created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (created != null) 'created': created,
    });
  }

  NotesCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime> created}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        minTextLength: 2, maxTextLength: 200);
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdMeta = const VerificationMeta('created');
  GeneratedDateTimeColumn _created;
  @override
  GeneratedDateTimeColumn get created => _created ??= _constructCreated();
  GeneratedDateTimeColumn _constructCreated() {
    return GeneratedDateTimeColumn(
      'created',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, content, created];
  @override
  $NotesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes';
  @override
  final String actualTableName = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<NoteEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created'], _createdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NoteEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }
}

class FolderEntry extends DataClass implements Insertable<FolderEntry> {
  final int id;
  final String name;
  final int order;
  final int planId;
  final int numberToShow;
  final bool isDefaultFolder;
  FolderEntry(
      {@required this.id,
      @required this.name,
      @required this.order,
      this.planId,
      @required this.numberToShow,
      @required this.isDefaultFolder});
  factory FolderEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return FolderEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      order: intType.mapFromDatabaseResponse(data['${effectivePrefix}order']),
      planId: intType.mapFromDatabaseResponse(data['${effectivePrefix}planId']),
      numberToShow: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}numberToShow']),
      isDefaultFolder: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}isDefaultFolder']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    if (!nullToAbsent || planId != null) {
      map['planId'] = Variable<int>(planId);
    }
    if (!nullToAbsent || numberToShow != null) {
      map['numberToShow'] = Variable<int>(numberToShow);
    }
    if (!nullToAbsent || isDefaultFolder != null) {
      map['isDefaultFolder'] = Variable<bool>(isDefaultFolder);
    }
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      planId:
          planId == null && nullToAbsent ? const Value.absent() : Value(planId),
      numberToShow: numberToShow == null && nullToAbsent
          ? const Value.absent()
          : Value(numberToShow),
      isDefaultFolder: isDefaultFolder == null && nullToAbsent
          ? const Value.absent()
          : Value(isDefaultFolder),
    );
  }

  factory FolderEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FolderEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      planId: serializer.fromJson<int>(json['planId']),
      numberToShow: serializer.fromJson<int>(json['numberToShow']),
      isDefaultFolder: serializer.fromJson<bool>(json['isDefaultFolder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'planId': serializer.toJson<int>(planId),
      'numberToShow': serializer.toJson<int>(numberToShow),
      'isDefaultFolder': serializer.toJson<bool>(isDefaultFolder),
    };
  }

  FolderEntry copyWith(
          {int id,
          String name,
          int order,
          int planId,
          int numberToShow,
          bool isDefaultFolder}) =>
      FolderEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        planId: planId ?? this.planId,
        numberToShow: numberToShow ?? this.numberToShow,
        isDefaultFolder: isDefaultFolder ?? this.isDefaultFolder,
      );
  @override
  String toString() {
    return (StringBuffer('FolderEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('planId: $planId, ')
          ..write('numberToShow: $numberToShow, ')
          ..write('isDefaultFolder: $isDefaultFolder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              order.hashCode,
              $mrjc(planId.hashCode,
                  $mrjc(numberToShow.hashCode, isDefaultFolder.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FolderEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.planId == this.planId &&
          other.numberToShow == this.numberToShow &&
          other.isDefaultFolder == this.isDefaultFolder);
}

class FoldersCompanion extends UpdateCompanion<FolderEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> order;
  final Value<int> planId;
  final Value<int> numberToShow;
  final Value<bool> isDefaultFolder;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.planId = const Value.absent(),
    this.numberToShow = const Value.absent(),
    this.isDefaultFolder = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int order,
    this.planId = const Value.absent(),
    this.numberToShow = const Value.absent(),
    this.isDefaultFolder = const Value.absent(),
  })  : name = Value(name),
        order = Value(order);
  static Insertable<FolderEntry> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> order,
    Expression<int> planId,
    Expression<int> numberToShow,
    Expression<bool> isDefaultFolder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (planId != null) 'planId': planId,
      if (numberToShow != null) 'numberToShow': numberToShow,
      if (isDefaultFolder != null) 'isDefaultFolder': isDefaultFolder,
    });
  }

  FoldersCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> order,
      Value<int> planId,
      Value<int> numberToShow,
      Value<bool> isDefaultFolder}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      planId: planId ?? this.planId,
      numberToShow: numberToShow ?? this.numberToShow,
      isDefaultFolder: isDefaultFolder ?? this.isDefaultFolder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (planId.present) {
      map['planId'] = Variable<int>(planId.value);
    }
    if (numberToShow.present) {
      map['numberToShow'] = Variable<int>(numberToShow.value);
    }
    if (isDefaultFolder.present) {
      map['isDefaultFolder'] = Variable<bool>(isDefaultFolder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('planId: $planId, ')
          ..write('numberToShow: $numberToShow, ')
          ..write('isDefaultFolder: $isDefaultFolder')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, FolderEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $FoldersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 200);
  }

  final VerificationMeta _orderMeta = const VerificationMeta('order');
  GeneratedIntColumn _order;
  @override
  GeneratedIntColumn get order => _order ??= _constructOrder();
  GeneratedIntColumn _constructOrder() {
    return GeneratedIntColumn(
      'order',
      $tableName,
      false,
    );
  }

  final VerificationMeta _planIdMeta = const VerificationMeta('planId');
  GeneratedIntColumn _planId;
  @override
  GeneratedIntColumn get planId => _planId ??= _constructPlanId();
  GeneratedIntColumn _constructPlanId() {
    return GeneratedIntColumn(
      'planId',
      $tableName,
      true,
    );
  }

  final VerificationMeta _numberToShowMeta =
      const VerificationMeta('numberToShow');
  GeneratedIntColumn _numberToShow;
  @override
  GeneratedIntColumn get numberToShow =>
      _numberToShow ??= _constructNumberToShow();
  GeneratedIntColumn _constructNumberToShow() {
    return GeneratedIntColumn('numberToShow', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _isDefaultFolderMeta =
      const VerificationMeta('isDefaultFolder');
  GeneratedBoolColumn _isDefaultFolder;
  @override
  GeneratedBoolColumn get isDefaultFolder =>
      _isDefaultFolder ??= _constructIsDefaultFolder();
  GeneratedBoolColumn _constructIsDefaultFolder() {
    return GeneratedBoolColumn('isDefaultFolder', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, order, planId, numberToShow, isDefaultFolder];
  @override
  $FoldersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'folders';
  @override
  final String actualTableName = 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<FolderEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order'], _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('planId')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['planId'], _planIdMeta));
    }
    if (data.containsKey('numberToShow')) {
      context.handle(
          _numberToShowMeta,
          numberToShow.isAcceptableOrUnknown(
              data['numberToShow'], _numberToShowMeta));
    }
    if (data.containsKey('isDefaultFolder')) {
      context.handle(
          _isDefaultFolderMeta,
          isDefaultFolder.isAcceptableOrUnknown(
              data['isDefaultFolder'], _isDefaultFolderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FolderEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return FolderEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$Database.connect(DatabaseConnection c) : super.connect(c);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  $FoldersTable _folders;
  $FoldersTable get folders => _folders ??= $FoldersTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notes, folders];
}
