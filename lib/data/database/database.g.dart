// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class FolderEntry extends DataClass implements Insertable<FolderEntry> {
  final int id;
  final String name;
  final int order;
  final int planId;
  final int numberToShow;
  final bool isDefaultFolder;
  final DateTime created;
  FolderEntry(
      {@required this.id,
      @required this.name,
      @required this.order,
      this.planId,
      @required this.numberToShow,
      @required this.isDefaultFolder,
      @required this.created});
  factory FolderEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return FolderEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      order: intType.mapFromDatabaseResponse(data['${effectivePrefix}order']),
      planId: intType.mapFromDatabaseResponse(data['${effectivePrefix}planId']),
      numberToShow: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}numberToShow']),
      isDefaultFolder: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}isDefaultFolder']),
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
    if (!nullToAbsent || created != null) {
      map['created'] = Variable<DateTime>(created);
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
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
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
      created: serializer.fromJson<DateTime>(json['created']),
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
      'created': serializer.toJson<DateTime>(created),
    };
  }

  FolderEntry copyWith(
          {int id,
          String name,
          int order,
          int planId,
          int numberToShow,
          bool isDefaultFolder,
          DateTime created}) =>
      FolderEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        planId: planId ?? this.planId,
        numberToShow: numberToShow ?? this.numberToShow,
        isDefaultFolder: isDefaultFolder ?? this.isDefaultFolder,
        created: created ?? this.created,
      );
  @override
  String toString() {
    return (StringBuffer('FolderEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('planId: $planId, ')
          ..write('numberToShow: $numberToShow, ')
          ..write('isDefaultFolder: $isDefaultFolder, ')
          ..write('created: $created')
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
              $mrjc(
                  planId.hashCode,
                  $mrjc(numberToShow.hashCode,
                      $mrjc(isDefaultFolder.hashCode, created.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FolderEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.planId == this.planId &&
          other.numberToShow == this.numberToShow &&
          other.isDefaultFolder == this.isDefaultFolder &&
          other.created == this.created);
}

class FoldersCompanion extends UpdateCompanion<FolderEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> order;
  final Value<int> planId;
  final Value<int> numberToShow;
  final Value<bool> isDefaultFolder;
  final Value<DateTime> created;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.planId = const Value.absent(),
    this.numberToShow = const Value.absent(),
    this.isDefaultFolder = const Value.absent(),
    this.created = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int order,
    this.planId = const Value.absent(),
    this.numberToShow = const Value.absent(),
    this.isDefaultFolder = const Value.absent(),
    this.created = const Value.absent(),
  })  : name = Value(name),
        order = Value(order);
  static Insertable<FolderEntry> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> order,
    Expression<int> planId,
    Expression<int> numberToShow,
    Expression<bool> isDefaultFolder,
    Expression<DateTime> created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (planId != null) 'planId': planId,
      if (numberToShow != null) 'numberToShow': numberToShow,
      if (isDefaultFolder != null) 'isDefaultFolder': isDefaultFolder,
      if (created != null) 'created': created,
    });
  }

  FoldersCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> order,
      Value<int> planId,
      Value<int> numberToShow,
      Value<bool> isDefaultFolder,
      Value<DateTime> created}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      planId: planId ?? this.planId,
      numberToShow: numberToShow ?? this.numberToShow,
      isDefaultFolder: isDefaultFolder ?? this.isDefaultFolder,
      created: created ?? this.created,
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
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
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
          ..write('isDefaultFolder: $isDefaultFolder, ')
          ..write('created: $created')
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

  final VerificationMeta _createdMeta = const VerificationMeta('created');
  GeneratedDateTimeColumn _created;
  @override
  GeneratedDateTimeColumn get created => _created ??= _constructCreated();
  GeneratedDateTimeColumn _constructCreated() {
    return GeneratedDateTimeColumn('created', $tableName, false,
        defaultValue: Constant(DateTime.now()));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, order, planId, numberToShow, isDefaultFolder, created];
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
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created'], _createdMeta));
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

class NoteEntry extends DataClass implements Insertable<NoteEntry> {
  final int id;
  final int folderId;
  final String title;
  final String content;
  final DateTime created;
  final DateTime nextReviewTime;
  final int reviewProgress;
  final int reviewPlanId;
  NoteEntry(
      {@required this.id,
      @required this.folderId,
      @required this.title,
      this.content,
      @required this.created,
      this.nextReviewTime,
      this.reviewProgress,
      this.reviewPlanId});
  factory NoteEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return NoteEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      folderId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}folderId']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      created: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
      nextReviewTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}nextReviewTime']),
      reviewProgress: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewProgress']),
      reviewPlanId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewPlanId']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || folderId != null) {
      map['folderId'] = Variable<int>(folderId);
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
    if (!nullToAbsent || nextReviewTime != null) {
      map['nextReviewTime'] = Variable<DateTime>(nextReviewTime);
    }
    if (!nullToAbsent || reviewProgress != null) {
      map['reviewProgress'] = Variable<int>(reviewProgress);
    }
    if (!nullToAbsent || reviewPlanId != null) {
      map['reviewPlanId'] = Variable<int>(reviewPlanId);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      nextReviewTime: nextReviewTime == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewTime),
      reviewProgress: reviewProgress == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewProgress),
      reviewPlanId: reviewPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewPlanId),
    );
  }

  factory NoteEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NoteEntry(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      created: serializer.fromJson<DateTime>(json['created']),
      nextReviewTime: serializer.fromJson<DateTime>(json['nextReviewTime']),
      reviewProgress: serializer.fromJson<int>(json['reviewProgress']),
      reviewPlanId: serializer.fromJson<int>(json['reviewPlanId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'created': serializer.toJson<DateTime>(created),
      'nextReviewTime': serializer.toJson<DateTime>(nextReviewTime),
      'reviewProgress': serializer.toJson<int>(reviewProgress),
      'reviewPlanId': serializer.toJson<int>(reviewPlanId),
    };
  }

  NoteEntry copyWith(
          {int id,
          int folderId,
          String title,
          String content,
          DateTime created,
          DateTime nextReviewTime,
          int reviewProgress,
          int reviewPlanId}) =>
      NoteEntry(
        id: id ?? this.id,
        folderId: folderId ?? this.folderId,
        title: title ?? this.title,
        content: content ?? this.content,
        created: created ?? this.created,
        nextReviewTime: nextReviewTime ?? this.nextReviewTime,
        reviewProgress: reviewProgress ?? this.reviewProgress,
        reviewPlanId: reviewPlanId ?? this.reviewPlanId,
      );
  @override
  String toString() {
    return (StringBuffer('NoteEntry(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('created: $created, ')
          ..write('nextReviewTime: $nextReviewTime, ')
          ..write('reviewProgress: $reviewProgress, ')
          ..write('reviewPlanId: $reviewPlanId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          folderId.hashCode,
          $mrjc(
              title.hashCode,
              $mrjc(
                  content.hashCode,
                  $mrjc(
                      created.hashCode,
                      $mrjc(
                          nextReviewTime.hashCode,
                          $mrjc(reviewProgress.hashCode,
                              reviewPlanId.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NoteEntry &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.title == this.title &&
          other.content == this.content &&
          other.created == this.created &&
          other.nextReviewTime == this.nextReviewTime &&
          other.reviewProgress == this.reviewProgress &&
          other.reviewPlanId == this.reviewPlanId);
}

class NotesCompanion extends UpdateCompanion<NoteEntry> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> created;
  final Value<DateTime> nextReviewTime;
  final Value<int> reviewProgress;
  final Value<int> reviewPlanId;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.created = const Value.absent(),
    this.nextReviewTime = const Value.absent(),
    this.reviewProgress = const Value.absent(),
    this.reviewPlanId = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    @required String title,
    this.content = const Value.absent(),
    this.created = const Value.absent(),
    this.nextReviewTime = const Value.absent(),
    this.reviewProgress = const Value.absent(),
    this.reviewPlanId = const Value.absent(),
  }) : title = Value(title);
  static Insertable<NoteEntry> custom({
    Expression<int> id,
    Expression<int> folderId,
    Expression<String> title,
    Expression<String> content,
    Expression<DateTime> created,
    Expression<DateTime> nextReviewTime,
    Expression<int> reviewProgress,
    Expression<int> reviewPlanId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folderId': folderId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (created != null) 'created': created,
      if (nextReviewTime != null) 'nextReviewTime': nextReviewTime,
      if (reviewProgress != null) 'reviewProgress': reviewProgress,
      if (reviewPlanId != null) 'reviewPlanId': reviewPlanId,
    });
  }

  NotesCompanion copyWith(
      {Value<int> id,
      Value<int> folderId,
      Value<String> title,
      Value<String> content,
      Value<DateTime> created,
      Value<DateTime> nextReviewTime,
      Value<int> reviewProgress,
      Value<int> reviewPlanId}) {
    return NotesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      content: content ?? this.content,
      created: created ?? this.created,
      nextReviewTime: nextReviewTime ?? this.nextReviewTime,
      reviewProgress: reviewProgress ?? this.reviewProgress,
      reviewPlanId: reviewPlanId ?? this.reviewPlanId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderId.present) {
      map['folderId'] = Variable<int>(folderId.value);
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
    if (nextReviewTime.present) {
      map['nextReviewTime'] = Variable<DateTime>(nextReviewTime.value);
    }
    if (reviewProgress.present) {
      map['reviewProgress'] = Variable<int>(reviewProgress.value);
    }
    if (reviewPlanId.present) {
      map['reviewPlanId'] = Variable<int>(reviewPlanId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('created: $created, ')
          ..write('nextReviewTime: $nextReviewTime, ')
          ..write('reviewProgress: $reviewProgress, ')
          ..write('reviewPlanId: $reviewPlanId')
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

  final VerificationMeta _folderIdMeta = const VerificationMeta('folderId');
  GeneratedIntColumn _folderId;
  @override
  GeneratedIntColumn get folderId => _folderId ??= _constructFolderId();
  GeneratedIntColumn _constructFolderId() {
    return GeneratedIntColumn('folderId', $tableName, false,
        defaultValue: const Constant(3));
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
    return GeneratedDateTimeColumn('created', $tableName, false,
        defaultValue: Constant(DateTime.now()));
  }

  final VerificationMeta _nextReviewTimeMeta =
      const VerificationMeta('nextReviewTime');
  GeneratedDateTimeColumn _nextReviewTime;
  @override
  GeneratedDateTimeColumn get nextReviewTime =>
      _nextReviewTime ??= _constructNextReviewTime();
  GeneratedDateTimeColumn _constructNextReviewTime() {
    return GeneratedDateTimeColumn(
      'nextReviewTime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewProgressMeta =
      const VerificationMeta('reviewProgress');
  GeneratedIntColumn _reviewProgress;
  @override
  GeneratedIntColumn get reviewProgress =>
      _reviewProgress ??= _constructReviewProgress();
  GeneratedIntColumn _constructReviewProgress() {
    return GeneratedIntColumn(
      'reviewProgress',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewPlanIdMeta =
      const VerificationMeta('reviewPlanId');
  GeneratedIntColumn _reviewPlanId;
  @override
  GeneratedIntColumn get reviewPlanId =>
      _reviewPlanId ??= _constructReviewPlanId();
  GeneratedIntColumn _constructReviewPlanId() {
    return GeneratedIntColumn(
      'reviewPlanId',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        folderId,
        title,
        content,
        created,
        nextReviewTime,
        reviewProgress,
        reviewPlanId
      ];
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
    if (data.containsKey('folderId')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folderId'], _folderIdMeta));
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
    if (data.containsKey('nextReviewTime')) {
      context.handle(
          _nextReviewTimeMeta,
          nextReviewTime.isAcceptableOrUnknown(
              data['nextReviewTime'], _nextReviewTimeMeta));
    }
    if (data.containsKey('reviewProgress')) {
      context.handle(
          _reviewProgressMeta,
          reviewProgress.isAcceptableOrUnknown(
              data['reviewProgress'], _reviewProgressMeta));
    }
    if (data.containsKey('reviewPlanId')) {
      context.handle(
          _reviewPlanIdMeta,
          reviewPlanId.isAcceptableOrUnknown(
              data['reviewPlanId'], _reviewPlanIdMeta));
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

class ReviewPlanEntry extends DataClass implements Insertable<ReviewPlanEntry> {
  final int id;
  final String name;
  final String introduction;
  ReviewPlanEntry(
      {@required this.id, @required this.name, @required this.introduction});
  factory ReviewPlanEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return ReviewPlanEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      introduction: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}introduction']),
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
    if (!nullToAbsent || introduction != null) {
      map['introduction'] = Variable<String>(introduction);
    }
    return map;
  }

  ReviewPlansCompanion toCompanion(bool nullToAbsent) {
    return ReviewPlansCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      introduction: introduction == null && nullToAbsent
          ? const Value.absent()
          : Value(introduction),
    );
  }

  factory ReviewPlanEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ReviewPlanEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      introduction: serializer.fromJson<String>(json['introduction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'introduction': serializer.toJson<String>(introduction),
    };
  }

  ReviewPlanEntry copyWith({int id, String name, String introduction}) =>
      ReviewPlanEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        introduction: introduction ?? this.introduction,
      );
  @override
  String toString() {
    return (StringBuffer('ReviewPlanEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('introduction: $introduction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, introduction.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ReviewPlanEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.introduction == this.introduction);
}

class ReviewPlansCompanion extends UpdateCompanion<ReviewPlanEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> introduction;
  const ReviewPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.introduction = const Value.absent(),
  });
  ReviewPlansCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String introduction,
  })  : name = Value(name),
        introduction = Value(introduction);
  static Insertable<ReviewPlanEntry> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> introduction,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (introduction != null) 'introduction': introduction,
    });
  }

  ReviewPlansCompanion copyWith(
      {Value<int> id, Value<String> name, Value<String> introduction}) {
    return ReviewPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      introduction: introduction ?? this.introduction,
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
    if (introduction.present) {
      map['introduction'] = Variable<String>(introduction.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('introduction: $introduction')
          ..write(')'))
        .toString();
  }
}

class $ReviewPlansTable extends ReviewPlans
    with TableInfo<$ReviewPlansTable, ReviewPlanEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $ReviewPlansTable(this._db, [this._alias]);
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
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _introductionMeta =
      const VerificationMeta('introduction');
  GeneratedTextColumn _introduction;
  @override
  GeneratedTextColumn get introduction =>
      _introduction ??= _constructIntroduction();
  GeneratedTextColumn _constructIntroduction() {
    return GeneratedTextColumn(
      'introduction',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, introduction];
  @override
  $ReviewPlansTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'review_plans';
  @override
  final String actualTableName = 'review_plans';
  @override
  VerificationContext validateIntegrity(Insertable<ReviewPlanEntry> instance,
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
    if (data.containsKey('introduction')) {
      context.handle(
          _introductionMeta,
          introduction.isAcceptableOrUnknown(
              data['introduction'], _introductionMeta));
    } else if (isInserting) {
      context.missing(_introductionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewPlanEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ReviewPlanEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ReviewPlansTable createAlias(String alias) {
    return $ReviewPlansTable(_db, alias);
  }
}

class ReviewPlanConfigEntry extends DataClass
    implements Insertable<ReviewPlanConfigEntry> {
  final int id;
  final int progressId;
  final int order;
  final int value;
  final int unit;
  ReviewPlanConfigEntry(
      {@required this.id,
      @required this.progressId,
      @required this.order,
      @required this.value,
      @required this.unit});
  factory ReviewPlanConfigEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return ReviewPlanConfigEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      progressId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}progressId']),
      order: intType.mapFromDatabaseResponse(data['${effectivePrefix}order']),
      value: intType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      unit: intType.mapFromDatabaseResponse(data['${effectivePrefix}unit']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || progressId != null) {
      map['progressId'] = Variable<int>(progressId);
    }
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<int>(value);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<int>(unit);
    }
    return map;
  }

  ReviewPlanConfigsCompanion toCompanion(bool nullToAbsent) {
    return ReviewPlanConfigsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      progressId: progressId == null && nullToAbsent
          ? const Value.absent()
          : Value(progressId),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
    );
  }

  factory ReviewPlanConfigEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ReviewPlanConfigEntry(
      id: serializer.fromJson<int>(json['id']),
      progressId: serializer.fromJson<int>(json['progressId']),
      order: serializer.fromJson<int>(json['order']),
      value: serializer.fromJson<int>(json['value']),
      unit: serializer.fromJson<int>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'progressId': serializer.toJson<int>(progressId),
      'order': serializer.toJson<int>(order),
      'value': serializer.toJson<int>(value),
      'unit': serializer.toJson<int>(unit),
    };
  }

  ReviewPlanConfigEntry copyWith(
          {int id, int progressId, int order, int value, int unit}) =>
      ReviewPlanConfigEntry(
        id: id ?? this.id,
        progressId: progressId ?? this.progressId,
        order: order ?? this.order,
        value: value ?? this.value,
        unit: unit ?? this.unit,
      );
  @override
  String toString() {
    return (StringBuffer('ReviewPlanConfigEntry(')
          ..write('id: $id, ')
          ..write('progressId: $progressId, ')
          ..write('order: $order, ')
          ..write('value: $value, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(progressId.hashCode,
          $mrjc(order.hashCode, $mrjc(value.hashCode, unit.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ReviewPlanConfigEntry &&
          other.id == this.id &&
          other.progressId == this.progressId &&
          other.order == this.order &&
          other.value == this.value &&
          other.unit == this.unit);
}

class ReviewPlanConfigsCompanion
    extends UpdateCompanion<ReviewPlanConfigEntry> {
  final Value<int> id;
  final Value<int> progressId;
  final Value<int> order;
  final Value<int> value;
  final Value<int> unit;
  const ReviewPlanConfigsCompanion({
    this.id = const Value.absent(),
    this.progressId = const Value.absent(),
    this.order = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
  });
  ReviewPlanConfigsCompanion.insert({
    this.id = const Value.absent(),
    @required int progressId,
    @required int order,
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
  })  : progressId = Value(progressId),
        order = Value(order);
  static Insertable<ReviewPlanConfigEntry> custom({
    Expression<int> id,
    Expression<int> progressId,
    Expression<int> order,
    Expression<int> value,
    Expression<int> unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (progressId != null) 'progressId': progressId,
      if (order != null) 'order': order,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
    });
  }

  ReviewPlanConfigsCompanion copyWith(
      {Value<int> id,
      Value<int> progressId,
      Value<int> order,
      Value<int> value,
      Value<int> unit}) {
    return ReviewPlanConfigsCompanion(
      id: id ?? this.id,
      progressId: progressId ?? this.progressId,
      order: order ?? this.order,
      value: value ?? this.value,
      unit: unit ?? this.unit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (progressId.present) {
      map['progressId'] = Variable<int>(progressId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewPlanConfigsCompanion(')
          ..write('id: $id, ')
          ..write('progressId: $progressId, ')
          ..write('order: $order, ')
          ..write('value: $value, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

class $ReviewPlanConfigsTable extends ReviewPlanConfigs
    with TableInfo<$ReviewPlanConfigsTable, ReviewPlanConfigEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $ReviewPlanConfigsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _progressIdMeta = const VerificationMeta('progressId');
  GeneratedIntColumn _progressId;
  @override
  GeneratedIntColumn get progressId => _progressId ??= _constructProgressId();
  GeneratedIntColumn _constructProgressId() {
    return GeneratedIntColumn(
      'progressId',
      $tableName,
      false,
    );
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

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedIntColumn _value;
  @override
  GeneratedIntColumn get value => _value ??= _constructValue();
  GeneratedIntColumn _constructValue() {
    return GeneratedIntColumn('value', $tableName, false,
        defaultValue: const Constant(1));
  }

  final VerificationMeta _unitMeta = const VerificationMeta('unit');
  GeneratedIntColumn _unit;
  @override
  GeneratedIntColumn get unit => _unit ??= _constructUnit();
  GeneratedIntColumn _constructUnit() {
    return GeneratedIntColumn('unit', $tableName, false,
        defaultValue: const Constant(1));
  }

  @override
  List<GeneratedColumn> get $columns => [id, progressId, order, value, unit];
  @override
  $ReviewPlanConfigsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'review_plan_configs';
  @override
  final String actualTableName = 'review_plan_configs';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReviewPlanConfigEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('progressId')) {
      context.handle(
          _progressIdMeta,
          progressId.isAcceptableOrUnknown(
              data['progressId'], _progressIdMeta));
    } else if (isInserting) {
      context.missing(_progressIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order'], _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value'], _valueMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit'], _unitMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewPlanConfigEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ReviewPlanConfigEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ReviewPlanConfigsTable createAlias(String alias) {
    return $ReviewPlanConfigsTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$Database.connect(DatabaseConnection c) : super.connect(c);
  $FoldersTable _folders;
  $FoldersTable get folders => _folders ??= $FoldersTable(this);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  $ReviewPlansTable _reviewPlans;
  $ReviewPlansTable get reviewPlans => _reviewPlans ??= $ReviewPlansTable(this);
  $ReviewPlanConfigsTable _reviewPlanConfigs;
  $ReviewPlanConfigsTable get reviewPlanConfigs =>
      _reviewPlanConfigs ??= $ReviewPlanConfigsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [folders, notes, reviewPlans, reviewPlanConfigs];
}
