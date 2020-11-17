// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UserEntry extends DataClass implements Insertable<UserEntry> {
  final int id;
  final String userName;
  final String password;
  final String nickName;
  final String portrait;
  final String mobile;
  final String introduction;
  final DateTime created;
  UserEntry(
      {@required this.id,
      @required this.userName,
      @required this.password,
      this.nickName,
      this.portrait,
      this.mobile,
      this.introduction,
      @required this.created});
  factory UserEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return UserEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      userName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}userName']),
      password: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}password']),
      nickName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}nickName']),
      portrait: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}portrait']),
      mobile:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}mobile']),
      introduction: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}introduction']),
      created: $UsersTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || userName != null) {
      map['userName'] = Variable<String>(userName);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    if (!nullToAbsent || nickName != null) {
      map['nickName'] = Variable<String>(nickName);
    }
    if (!nullToAbsent || portrait != null) {
      map['portrait'] = Variable<String>(portrait);
    }
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || introduction != null) {
      map['introduction'] = Variable<String>(introduction);
    }
    if (!nullToAbsent || created != null) {
      final converter = $UsersTable.$converter0;
      map['created'] = Variable<String>(converter.mapToSql(created));
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      nickName: nickName == null && nullToAbsent
          ? const Value.absent()
          : Value(nickName),
      portrait: portrait == null && nullToAbsent
          ? const Value.absent()
          : Value(portrait),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      introduction: introduction == null && nullToAbsent
          ? const Value.absent()
          : Value(introduction),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
    );
  }

  factory UserEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UserEntry(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      password: serializer.fromJson<String>(json['password']),
      nickName: serializer.fromJson<String>(json['nickName']),
      portrait: serializer.fromJson<String>(json['portrait']),
      mobile: serializer.fromJson<String>(json['mobile']),
      introduction: serializer.fromJson<String>(json['introduction']),
      created: serializer.fromJson<DateTime>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'password': serializer.toJson<String>(password),
      'nickName': serializer.toJson<String>(nickName),
      'portrait': serializer.toJson<String>(portrait),
      'mobile': serializer.toJson<String>(mobile),
      'introduction': serializer.toJson<String>(introduction),
      'created': serializer.toJson<DateTime>(created),
    };
  }

  UserEntry copyWith(
          {int id,
          String userName,
          String password,
          String nickName,
          String portrait,
          String mobile,
          String introduction,
          DateTime created}) =>
      UserEntry(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        nickName: nickName ?? this.nickName,
        portrait: portrait ?? this.portrait,
        mobile: mobile ?? this.mobile,
        introduction: introduction ?? this.introduction,
        created: created ?? this.created,
      );
  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('password: $password, ')
          ..write('nickName: $nickName, ')
          ..write('portrait: $portrait, ')
          ..write('mobile: $mobile, ')
          ..write('introduction: $introduction, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userName.hashCode,
          $mrjc(
              password.hashCode,
              $mrjc(
                  nickName.hashCode,
                  $mrjc(
                      portrait.hashCode,
                      $mrjc(mobile.hashCode,
                          $mrjc(introduction.hashCode, created.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.password == this.password &&
          other.nickName == this.nickName &&
          other.portrait == this.portrait &&
          other.mobile == this.mobile &&
          other.introduction == this.introduction &&
          other.created == this.created);
}

class UsersCompanion extends UpdateCompanion<UserEntry> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> password;
  final Value<String> nickName;
  final Value<String> portrait;
  final Value<String> mobile;
  final Value<String> introduction;
  final Value<DateTime> created;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.password = const Value.absent(),
    this.nickName = const Value.absent(),
    this.portrait = const Value.absent(),
    this.mobile = const Value.absent(),
    this.introduction = const Value.absent(),
    this.created = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    @required String userName,
    @required String password,
    this.nickName = const Value.absent(),
    this.portrait = const Value.absent(),
    this.mobile = const Value.absent(),
    this.introduction = const Value.absent(),
    @required DateTime created,
  })  : userName = Value(userName),
        password = Value(password),
        created = Value(created);
  static Insertable<UserEntry> custom({
    Expression<int> id,
    Expression<String> userName,
    Expression<String> password,
    Expression<String> nickName,
    Expression<String> portrait,
    Expression<String> mobile,
    Expression<String> introduction,
    Expression<String> created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'userName': userName,
      if (password != null) 'password': password,
      if (nickName != null) 'nickName': nickName,
      if (portrait != null) 'portrait': portrait,
      if (mobile != null) 'mobile': mobile,
      if (introduction != null) 'introduction': introduction,
      if (created != null) 'created': created,
    });
  }

  UsersCompanion copyWith(
      {Value<int> id,
      Value<String> userName,
      Value<String> password,
      Value<String> nickName,
      Value<String> portrait,
      Value<String> mobile,
      Value<String> introduction,
      Value<DateTime> created}) {
    return UsersCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      nickName: nickName ?? this.nickName,
      portrait: portrait ?? this.portrait,
      mobile: mobile ?? this.mobile,
      introduction: introduction ?? this.introduction,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['userName'] = Variable<String>(userName.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (nickName.present) {
      map['nickName'] = Variable<String>(nickName.value);
    }
    if (portrait.present) {
      map['portrait'] = Variable<String>(portrait.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (introduction.present) {
      map['introduction'] = Variable<String>(introduction.value);
    }
    if (created.present) {
      final converter = $UsersTable.$converter0;
      map['created'] = Variable<String>(converter.mapToSql(created.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('password: $password, ')
          ..write('nickName: $nickName, ')
          ..write('portrait: $portrait, ')
          ..write('mobile: $mobile, ')
          ..write('introduction: $introduction, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $UsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _userNameMeta = const VerificationMeta('userName');
  GeneratedTextColumn _userName;
  @override
  GeneratedTextColumn get userName => _userName ??= _constructUserName();
  GeneratedTextColumn _constructUserName() {
    return GeneratedTextColumn('userName', $tableName, false,
        minTextLength: 1, maxTextLength: 200);
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  GeneratedTextColumn _password;
  @override
  GeneratedTextColumn get password => _password ??= _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn('password', $tableName, false,
        minTextLength: 6, maxTextLength: 200);
  }

  final VerificationMeta _nickNameMeta = const VerificationMeta('nickName');
  GeneratedTextColumn _nickName;
  @override
  GeneratedTextColumn get nickName => _nickName ??= _constructNickName();
  GeneratedTextColumn _constructNickName() {
    return GeneratedTextColumn('nickName', $tableName, true,
        minTextLength: 1, maxTextLength: 200);
  }

  final VerificationMeta _portraitMeta = const VerificationMeta('portrait');
  GeneratedTextColumn _portrait;
  @override
  GeneratedTextColumn get portrait => _portrait ??= _constructPortrait();
  GeneratedTextColumn _constructPortrait() {
    return GeneratedTextColumn(
      'portrait',
      $tableName,
      true,
    );
  }

  final VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  GeneratedTextColumn _mobile;
  @override
  GeneratedTextColumn get mobile => _mobile ??= _constructMobile();
  GeneratedTextColumn _constructMobile() {
    return GeneratedTextColumn('mobile', $tableName, true,
        minTextLength: 11, maxTextLength: 11);
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
      true,
    );
  }

  final VerificationMeta _createdMeta = const VerificationMeta('created');
  GeneratedTextColumn _created;
  @override
  GeneratedTextColumn get created => _created ??= _constructCreated();
  GeneratedTextColumn _constructCreated() {
    return GeneratedTextColumn(
      'created',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        userName,
        password,
        nickName,
        portrait,
        mobile,
        introduction,
        created
      ];
  @override
  $UsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'users';
  @override
  final String actualTableName = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('userName')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['userName'], _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password'], _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('nickName')) {
      context.handle(_nickNameMeta,
          nickName.isAcceptableOrUnknown(data['nickName'], _nickNameMeta));
    }
    if (data.containsKey('portrait')) {
      context.handle(_portraitMeta,
          portrait.isAcceptableOrUnknown(data['portrait'], _portraitMeta));
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile'], _mobileMeta));
    }
    if (data.containsKey('introduction')) {
      context.handle(
          _introductionMeta,
          introduction.isAcceptableOrUnknown(
              data['introduction'], _introductionMeta));
    }
    context.handle(_createdMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return UserEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(_db, alias);
  }

  static TypeConverter<DateTime, String> $converter0 =
      const IsoDateTimeConverter();
}

class FolderEntry extends DataClass implements Insertable<FolderEntry> {
  final int id;
  final String name;
  final int order;
  final bool isDefaultFolder;
  final int reviewPlanId;
  final DateTime created;
  final int createdBy;
  FolderEntry(
      {@required this.id,
      @required this.name,
      @required this.order,
      @required this.isDefaultFolder,
      this.reviewPlanId,
      @required this.created,
      @required this.createdBy});
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
      isDefaultFolder: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}isDefaultFolder']),
      reviewPlanId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewPlanId']),
      created: $FoldersTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created'])),
      createdBy:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}createdBy']),
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
    if (!nullToAbsent || isDefaultFolder != null) {
      map['isDefaultFolder'] = Variable<bool>(isDefaultFolder);
    }
    if (!nullToAbsent || reviewPlanId != null) {
      map['reviewPlanId'] = Variable<int>(reviewPlanId);
    }
    if (!nullToAbsent || created != null) {
      final converter = $FoldersTable.$converter0;
      map['created'] = Variable<String>(converter.mapToSql(created));
    }
    if (!nullToAbsent || createdBy != null) {
      map['createdBy'] = Variable<int>(createdBy);
    }
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      isDefaultFolder: isDefaultFolder == null && nullToAbsent
          ? const Value.absent()
          : Value(isDefaultFolder),
      reviewPlanId: reviewPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewPlanId),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory FolderEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FolderEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      isDefaultFolder: serializer.fromJson<bool>(json['isDefaultFolder']),
      reviewPlanId: serializer.fromJson<int>(json['reviewPlanId']),
      created: serializer.fromJson<DateTime>(json['created']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'isDefaultFolder': serializer.toJson<bool>(isDefaultFolder),
      'reviewPlanId': serializer.toJson<int>(reviewPlanId),
      'created': serializer.toJson<DateTime>(created),
      'createdBy': serializer.toJson<int>(createdBy),
    };
  }

  FolderEntry copyWith(
          {int id,
          String name,
          int order,
          bool isDefaultFolder,
          int reviewPlanId,
          DateTime created,
          int createdBy}) =>
      FolderEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        isDefaultFolder: isDefaultFolder ?? this.isDefaultFolder,
        reviewPlanId: reviewPlanId ?? this.reviewPlanId,
        created: created ?? this.created,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('FolderEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('isDefaultFolder: $isDefaultFolder, ')
          ..write('reviewPlanId: $reviewPlanId, ')
          ..write('created: $created, ')
          ..write('createdBy: $createdBy')
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
                  isDefaultFolder.hashCode,
                  $mrjc(reviewPlanId.hashCode,
                      $mrjc(created.hashCode, createdBy.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is FolderEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.order == this.order &&
          other.isDefaultFolder == this.isDefaultFolder &&
          other.reviewPlanId == this.reviewPlanId &&
          other.created == this.created &&
          other.createdBy == this.createdBy);
}

class FoldersCompanion extends UpdateCompanion<FolderEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> order;
  final Value<bool> isDefaultFolder;
  final Value<int> reviewPlanId;
  final Value<DateTime> created;
  final Value<int> createdBy;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.isDefaultFolder = const Value.absent(),
    this.reviewPlanId = const Value.absent(),
    this.created = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required int order,
    this.isDefaultFolder = const Value.absent(),
    this.reviewPlanId = const Value.absent(),
    @required DateTime created,
    this.createdBy = const Value.absent(),
  })  : name = Value(name),
        order = Value(order),
        created = Value(created);
  static Insertable<FolderEntry> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<int> order,
    Expression<bool> isDefaultFolder,
    Expression<int> reviewPlanId,
    Expression<String> created,
    Expression<int> createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (isDefaultFolder != null) 'isDefaultFolder': isDefaultFolder,
      if (reviewPlanId != null) 'reviewPlanId': reviewPlanId,
      if (created != null) 'created': created,
      if (createdBy != null) 'createdBy': createdBy,
    });
  }

  FoldersCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<int> order,
      Value<bool> isDefaultFolder,
      Value<int> reviewPlanId,
      Value<DateTime> created,
      Value<int> createdBy}) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      isDefaultFolder: isDefaultFolder ?? this.isDefaultFolder,
      reviewPlanId: reviewPlanId ?? this.reviewPlanId,
      created: created ?? this.created,
      createdBy: createdBy ?? this.createdBy,
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
    if (isDefaultFolder.present) {
      map['isDefaultFolder'] = Variable<bool>(isDefaultFolder.value);
    }
    if (reviewPlanId.present) {
      map['reviewPlanId'] = Variable<int>(reviewPlanId.value);
    }
    if (created.present) {
      final converter = $FoldersTable.$converter0;
      map['created'] = Variable<String>(converter.mapToSql(created.value));
    }
    if (createdBy.present) {
      map['createdBy'] = Variable<int>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('isDefaultFolder: $isDefaultFolder, ')
          ..write('reviewPlanId: $reviewPlanId, ')
          ..write('created: $created, ')
          ..write('createdBy: $createdBy')
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

  final VerificationMeta _createdMeta = const VerificationMeta('created');
  GeneratedTextColumn _created;
  @override
  GeneratedTextColumn get created => _created ??= _constructCreated();
  GeneratedTextColumn _constructCreated() {
    return GeneratedTextColumn(
      'created',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedIntColumn _createdBy;
  @override
  GeneratedIntColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedIntColumn _constructCreatedBy() {
    return GeneratedIntColumn('createdBy', $tableName, false,
        defaultValue: const Constant(1));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, order, isDefaultFolder, reviewPlanId, created, createdBy];
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
    if (data.containsKey('isDefaultFolder')) {
      context.handle(
          _isDefaultFolderMeta,
          isDefaultFolder.isAcceptableOrUnknown(
              data['isDefaultFolder'], _isDefaultFolderMeta));
    }
    if (data.containsKey('reviewPlanId')) {
      context.handle(
          _reviewPlanIdMeta,
          reviewPlanId.isAcceptableOrUnknown(
              data['reviewPlanId'], _reviewPlanIdMeta));
    }
    context.handle(_createdMeta, const VerificationResult.success());
    if (data.containsKey('createdBy')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['createdBy'], _createdByMeta));
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

  static TypeConverter<DateTime, String> $converter0 =
      const IsoDateTimeConverter();
}

class NoteEntry extends DataClass implements Insertable<NoteEntry> {
  final int id;
  final int folderId;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime nextReviewTime;
  final int reviewProgressNo;
  final bool isReviewFinished;
  final bool isDeleted;
  final int createdBy;
  NoteEntry(
      {@required this.id,
      @required this.folderId,
      this.content,
      @required this.created,
      @required this.updated,
      this.nextReviewTime,
      this.reviewProgressNo,
      @required this.isReviewFinished,
      @required this.isDeleted,
      @required this.createdBy});
  factory NoteEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return NoteEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      folderId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}folderId']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
      created: $NotesTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created'])),
      updated: $NotesTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated'])),
      nextReviewTime: $NotesTable.$converter2.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}nextReviewTime'])),
      reviewProgressNo: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewProgressNo']),
      isReviewFinished: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}isReviewFinished']),
      isDeleted:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}isDeleted']),
      createdBy:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}createdBy']),
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
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || created != null) {
      final converter = $NotesTable.$converter0;
      map['created'] = Variable<String>(converter.mapToSql(created));
    }
    if (!nullToAbsent || updated != null) {
      final converter = $NotesTable.$converter1;
      map['updated'] = Variable<String>(converter.mapToSql(updated));
    }
    if (!nullToAbsent || nextReviewTime != null) {
      final converter = $NotesTable.$converter2;
      map['nextReviewTime'] =
          Variable<String>(converter.mapToSql(nextReviewTime));
    }
    if (!nullToAbsent || reviewProgressNo != null) {
      map['reviewProgressNo'] = Variable<int>(reviewProgressNo);
    }
    if (!nullToAbsent || isReviewFinished != null) {
      map['isReviewFinished'] = Variable<bool>(isReviewFinished);
    }
    if (!nullToAbsent || isDeleted != null) {
      map['isDeleted'] = Variable<bool>(isDeleted);
    }
    if (!nullToAbsent || createdBy != null) {
      map['createdBy'] = Variable<int>(createdBy);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      folderId: folderId == null && nullToAbsent
          ? const Value.absent()
          : Value(folderId),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      updated: updated == null && nullToAbsent
          ? const Value.absent()
          : Value(updated),
      nextReviewTime: nextReviewTime == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewTime),
      reviewProgressNo: reviewProgressNo == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewProgressNo),
      isReviewFinished: isReviewFinished == null && nullToAbsent
          ? const Value.absent()
          : Value(isReviewFinished),
      isDeleted: isDeleted == null && nullToAbsent
          ? const Value.absent()
          : Value(isDeleted),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory NoteEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NoteEntry(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      content: serializer.fromJson<String>(json['content']),
      created: serializer.fromJson<DateTime>(json['created']),
      updated: serializer.fromJson<DateTime>(json['updated']),
      nextReviewTime: serializer.fromJson<DateTime>(json['nextReviewTime']),
      reviewProgressNo: serializer.fromJson<int>(json['reviewProgressNo']),
      isReviewFinished: serializer.fromJson<bool>(json['isReviewFinished']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'content': serializer.toJson<String>(content),
      'created': serializer.toJson<DateTime>(created),
      'updated': serializer.toJson<DateTime>(updated),
      'nextReviewTime': serializer.toJson<DateTime>(nextReviewTime),
      'reviewProgressNo': serializer.toJson<int>(reviewProgressNo),
      'isReviewFinished': serializer.toJson<bool>(isReviewFinished),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdBy': serializer.toJson<int>(createdBy),
    };
  }

  NoteEntry copyWith(
          {int id,
          int folderId,
          String content,
          DateTime created,
          DateTime updated,
          DateTime nextReviewTime,
          int reviewProgressNo,
          bool isReviewFinished,
          bool isDeleted,
          int createdBy}) =>
      NoteEntry(
        id: id ?? this.id,
        folderId: folderId ?? this.folderId,
        content: content ?? this.content,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        nextReviewTime: nextReviewTime ?? this.nextReviewTime,
        reviewProgressNo: reviewProgressNo ?? this.reviewProgressNo,
        isReviewFinished: isReviewFinished ?? this.isReviewFinished,
        isDeleted: isDeleted ?? this.isDeleted,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('NoteEntry(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('content: $content, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('nextReviewTime: $nextReviewTime, ')
          ..write('reviewProgressNo: $reviewProgressNo, ')
          ..write('isReviewFinished: $isReviewFinished, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          folderId.hashCode,
          $mrjc(
              content.hashCode,
              $mrjc(
                  created.hashCode,
                  $mrjc(
                      updated.hashCode,
                      $mrjc(
                          nextReviewTime.hashCode,
                          $mrjc(
                              reviewProgressNo.hashCode,
                              $mrjc(
                                  isReviewFinished.hashCode,
                                  $mrjc(isDeleted.hashCode,
                                      createdBy.hashCode))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NoteEntry &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.content == this.content &&
          other.created == this.created &&
          other.updated == this.updated &&
          other.nextReviewTime == this.nextReviewTime &&
          other.reviewProgressNo == this.reviewProgressNo &&
          other.isReviewFinished == this.isReviewFinished &&
          other.isDeleted == this.isDeleted &&
          other.createdBy == this.createdBy);
}

class NotesCompanion extends UpdateCompanion<NoteEntry> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<String> content;
  final Value<DateTime> created;
  final Value<DateTime> updated;
  final Value<DateTime> nextReviewTime;
  final Value<int> reviewProgressNo;
  final Value<bool> isReviewFinished;
  final Value<bool> isDeleted;
  final Value<int> createdBy;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.content = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.nextReviewTime = const Value.absent(),
    this.reviewProgressNo = const Value.absent(),
    this.isReviewFinished = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.content = const Value.absent(),
    @required DateTime created,
    @required DateTime updated,
    this.nextReviewTime = const Value.absent(),
    this.reviewProgressNo = const Value.absent(),
    this.isReviewFinished = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdBy = const Value.absent(),
  })  : created = Value(created),
        updated = Value(updated);
  static Insertable<NoteEntry> custom({
    Expression<int> id,
    Expression<int> folderId,
    Expression<String> content,
    Expression<String> created,
    Expression<String> updated,
    Expression<String> nextReviewTime,
    Expression<int> reviewProgressNo,
    Expression<bool> isReviewFinished,
    Expression<bool> isDeleted,
    Expression<int> createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folderId': folderId,
      if (content != null) 'content': content,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (nextReviewTime != null) 'nextReviewTime': nextReviewTime,
      if (reviewProgressNo != null) 'reviewProgressNo': reviewProgressNo,
      if (isReviewFinished != null) 'isReviewFinished': isReviewFinished,
      if (isDeleted != null) 'isDeleted': isDeleted,
      if (createdBy != null) 'createdBy': createdBy,
    });
  }

  NotesCompanion copyWith(
      {Value<int> id,
      Value<int> folderId,
      Value<String> content,
      Value<DateTime> created,
      Value<DateTime> updated,
      Value<DateTime> nextReviewTime,
      Value<int> reviewProgressNo,
      Value<bool> isReviewFinished,
      Value<bool> isDeleted,
      Value<int> createdBy}) {
    return NotesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      content: content ?? this.content,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      nextReviewTime: nextReviewTime ?? this.nextReviewTime,
      reviewProgressNo: reviewProgressNo ?? this.reviewProgressNo,
      isReviewFinished: isReviewFinished ?? this.isReviewFinished,
      isDeleted: isDeleted ?? this.isDeleted,
      createdBy: createdBy ?? this.createdBy,
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
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (created.present) {
      final converter = $NotesTable.$converter0;
      map['created'] = Variable<String>(converter.mapToSql(created.value));
    }
    if (updated.present) {
      final converter = $NotesTable.$converter1;
      map['updated'] = Variable<String>(converter.mapToSql(updated.value));
    }
    if (nextReviewTime.present) {
      final converter = $NotesTable.$converter2;
      map['nextReviewTime'] =
          Variable<String>(converter.mapToSql(nextReviewTime.value));
    }
    if (reviewProgressNo.present) {
      map['reviewProgressNo'] = Variable<int>(reviewProgressNo.value);
    }
    if (isReviewFinished.present) {
      map['isReviewFinished'] = Variable<bool>(isReviewFinished.value);
    }
    if (isDeleted.present) {
      map['isDeleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdBy.present) {
      map['createdBy'] = Variable<int>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('content: $content, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('nextReviewTime: $nextReviewTime, ')
          ..write('reviewProgressNo: $reviewProgressNo, ')
          ..write('isReviewFinished: $isReviewFinished, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdBy: $createdBy')
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
  GeneratedTextColumn _created;
  @override
  GeneratedTextColumn get created => _created ??= _constructCreated();
  GeneratedTextColumn _constructCreated() {
    return GeneratedTextColumn(
      'created',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedMeta = const VerificationMeta('updated');
  GeneratedTextColumn _updated;
  @override
  GeneratedTextColumn get updated => _updated ??= _constructUpdated();
  GeneratedTextColumn _constructUpdated() {
    return GeneratedTextColumn(
      'updated',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nextReviewTimeMeta =
      const VerificationMeta('nextReviewTime');
  GeneratedTextColumn _nextReviewTime;
  @override
  GeneratedTextColumn get nextReviewTime =>
      _nextReviewTime ??= _constructNextReviewTime();
  GeneratedTextColumn _constructNextReviewTime() {
    return GeneratedTextColumn(
      'nextReviewTime',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reviewProgressNoMeta =
      const VerificationMeta('reviewProgressNo');
  GeneratedIntColumn _reviewProgressNo;
  @override
  GeneratedIntColumn get reviewProgressNo =>
      _reviewProgressNo ??= _constructReviewProgressNo();
  GeneratedIntColumn _constructReviewProgressNo() {
    return GeneratedIntColumn(
      'reviewProgressNo',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isReviewFinishedMeta =
      const VerificationMeta('isReviewFinished');
  GeneratedBoolColumn _isReviewFinished;
  @override
  GeneratedBoolColumn get isReviewFinished =>
      _isReviewFinished ??= _constructIsReviewFinished();
  GeneratedBoolColumn _constructIsReviewFinished() {
    return GeneratedBoolColumn('isReviewFinished', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  GeneratedBoolColumn _isDeleted;
  @override
  GeneratedBoolColumn get isDeleted => _isDeleted ??= _constructIsDeleted();
  GeneratedBoolColumn _constructIsDeleted() {
    return GeneratedBoolColumn('isDeleted', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedIntColumn _createdBy;
  @override
  GeneratedIntColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedIntColumn _constructCreatedBy() {
    return GeneratedIntColumn('createdBy', $tableName, false,
        defaultValue: const Constant(1));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        folderId,
        content,
        created,
        updated,
        nextReviewTime,
        reviewProgressNo,
        isReviewFinished,
        isDeleted,
        createdBy
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
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content'], _contentMeta));
    }
    context.handle(_createdMeta, const VerificationResult.success());
    context.handle(_updatedMeta, const VerificationResult.success());
    context.handle(_nextReviewTimeMeta, const VerificationResult.success());
    if (data.containsKey('reviewProgressNo')) {
      context.handle(
          _reviewProgressNoMeta,
          reviewProgressNo.isAcceptableOrUnknown(
              data['reviewProgressNo'], _reviewProgressNoMeta));
    }
    if (data.containsKey('isReviewFinished')) {
      context.handle(
          _isReviewFinishedMeta,
          isReviewFinished.isAcceptableOrUnknown(
              data['isReviewFinished'], _isReviewFinishedMeta));
    }
    if (data.containsKey('isDeleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['isDeleted'], _isDeletedMeta));
    }
    if (data.containsKey('createdBy')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['createdBy'], _createdByMeta));
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

  static TypeConverter<DateTime, String> $converter0 =
      const IsoDateTimeConverter();
  static TypeConverter<DateTime, String> $converter1 =
      const IsoDateTimeConverter();
  static TypeConverter<DateTime, String> $converter2 =
      const IsoDateTimeConverter();
}

class ReviewPlanEntry extends DataClass implements Insertable<ReviewPlanEntry> {
  final int id;
  final String name;
  final String introduction;
  final int createdBy;
  ReviewPlanEntry(
      {@required this.id,
      @required this.name,
      @required this.introduction,
      @required this.createdBy});
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
      createdBy:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}createdBy']),
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
    if (!nullToAbsent || createdBy != null) {
      map['createdBy'] = Variable<int>(createdBy);
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
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory ReviewPlanEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ReviewPlanEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      introduction: serializer.fromJson<String>(json['introduction']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'introduction': serializer.toJson<String>(introduction),
      'createdBy': serializer.toJson<int>(createdBy),
    };
  }

  ReviewPlanEntry copyWith(
          {int id, String name, String introduction, int createdBy}) =>
      ReviewPlanEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        introduction: introduction ?? this.introduction,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('ReviewPlanEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('introduction: $introduction, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(introduction.hashCode, createdBy.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ReviewPlanEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.introduction == this.introduction &&
          other.createdBy == this.createdBy);
}

class ReviewPlansCompanion extends UpdateCompanion<ReviewPlanEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> introduction;
  final Value<int> createdBy;
  const ReviewPlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.introduction = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  ReviewPlansCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required String introduction,
    this.createdBy = const Value.absent(),
  })  : name = Value(name),
        introduction = Value(introduction);
  static Insertable<ReviewPlanEntry> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<String> introduction,
    Expression<int> createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (introduction != null) 'introduction': introduction,
      if (createdBy != null) 'createdBy': createdBy,
    });
  }

  ReviewPlansCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<String> introduction,
      Value<int> createdBy}) {
    return ReviewPlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      introduction: introduction ?? this.introduction,
      createdBy: createdBy ?? this.createdBy,
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
    if (createdBy.present) {
      map['createdBy'] = Variable<int>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewPlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('introduction: $introduction, ')
          ..write('createdBy: $createdBy')
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

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedIntColumn _createdBy;
  @override
  GeneratedIntColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedIntColumn _constructCreatedBy() {
    return GeneratedIntColumn('createdBy', $tableName, false,
        defaultValue: const Constant(1));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, introduction, createdBy];
  @override
  $ReviewPlansTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reviewPlans';
  @override
  final String actualTableName = 'reviewPlans';
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
    if (data.containsKey('createdBy')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['createdBy'], _createdByMeta));
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
  final int reviewPlanId;
  final int order;
  final int value;
  final int unit;
  final int createdBy;
  ReviewPlanConfigEntry(
      {@required this.id,
      @required this.reviewPlanId,
      @required this.order,
      @required this.value,
      @required this.unit,
      @required this.createdBy});
  factory ReviewPlanConfigEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return ReviewPlanConfigEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      reviewPlanId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reviewPlanId']),
      order: intType.mapFromDatabaseResponse(data['${effectivePrefix}order']),
      value: intType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      unit: intType.mapFromDatabaseResponse(data['${effectivePrefix}unit']),
      createdBy:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}createdBy']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || reviewPlanId != null) {
      map['reviewPlanId'] = Variable<int>(reviewPlanId);
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
    if (!nullToAbsent || createdBy != null) {
      map['createdBy'] = Variable<int>(createdBy);
    }
    return map;
  }

  ReviewPlanConfigsCompanion toCompanion(bool nullToAbsent) {
    return ReviewPlanConfigsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      reviewPlanId: reviewPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewPlanId),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory ReviewPlanConfigEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ReviewPlanConfigEntry(
      id: serializer.fromJson<int>(json['id']),
      reviewPlanId: serializer.fromJson<int>(json['reviewPlanId']),
      order: serializer.fromJson<int>(json['order']),
      value: serializer.fromJson<int>(json['value']),
      unit: serializer.fromJson<int>(json['unit']),
      createdBy: serializer.fromJson<int>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reviewPlanId': serializer.toJson<int>(reviewPlanId),
      'order': serializer.toJson<int>(order),
      'value': serializer.toJson<int>(value),
      'unit': serializer.toJson<int>(unit),
      'createdBy': serializer.toJson<int>(createdBy),
    };
  }

  ReviewPlanConfigEntry copyWith(
          {int id,
          int reviewPlanId,
          int order,
          int value,
          int unit,
          int createdBy}) =>
      ReviewPlanConfigEntry(
        id: id ?? this.id,
        reviewPlanId: reviewPlanId ?? this.reviewPlanId,
        order: order ?? this.order,
        value: value ?? this.value,
        unit: unit ?? this.unit,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('ReviewPlanConfigEntry(')
          ..write('id: $id, ')
          ..write('reviewPlanId: $reviewPlanId, ')
          ..write('order: $order, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          reviewPlanId.hashCode,
          $mrjc(
              order.hashCode,
              $mrjc(
                  value.hashCode, $mrjc(unit.hashCode, createdBy.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ReviewPlanConfigEntry &&
          other.id == this.id &&
          other.reviewPlanId == this.reviewPlanId &&
          other.order == this.order &&
          other.value == this.value &&
          other.unit == this.unit &&
          other.createdBy == this.createdBy);
}

class ReviewPlanConfigsCompanion
    extends UpdateCompanion<ReviewPlanConfigEntry> {
  final Value<int> id;
  final Value<int> reviewPlanId;
  final Value<int> order;
  final Value<int> value;
  final Value<int> unit;
  final Value<int> createdBy;
  const ReviewPlanConfigsCompanion({
    this.id = const Value.absent(),
    this.reviewPlanId = const Value.absent(),
    this.order = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  ReviewPlanConfigsCompanion.insert({
    this.id = const Value.absent(),
    @required int reviewPlanId,
    @required int order,
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.createdBy = const Value.absent(),
  })  : reviewPlanId = Value(reviewPlanId),
        order = Value(order);
  static Insertable<ReviewPlanConfigEntry> custom({
    Expression<int> id,
    Expression<int> reviewPlanId,
    Expression<int> order,
    Expression<int> value,
    Expression<int> unit,
    Expression<int> createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reviewPlanId != null) 'reviewPlanId': reviewPlanId,
      if (order != null) 'order': order,
      if (value != null) 'value': value,
      if (unit != null) 'unit': unit,
      if (createdBy != null) 'createdBy': createdBy,
    });
  }

  ReviewPlanConfigsCompanion copyWith(
      {Value<int> id,
      Value<int> reviewPlanId,
      Value<int> order,
      Value<int> value,
      Value<int> unit,
      Value<int> createdBy}) {
    return ReviewPlanConfigsCompanion(
      id: id ?? this.id,
      reviewPlanId: reviewPlanId ?? this.reviewPlanId,
      order: order ?? this.order,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reviewPlanId.present) {
      map['reviewPlanId'] = Variable<int>(reviewPlanId.value);
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
    if (createdBy.present) {
      map['createdBy'] = Variable<int>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewPlanConfigsCompanion(')
          ..write('id: $id, ')
          ..write('reviewPlanId: $reviewPlanId, ')
          ..write('order: $order, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('createdBy: $createdBy')
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

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedIntColumn _createdBy;
  @override
  GeneratedIntColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedIntColumn _constructCreatedBy() {
    return GeneratedIntColumn('createdBy', $tableName, false,
        defaultValue: const Constant(1));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, reviewPlanId, order, value, unit, createdBy];
  @override
  $ReviewPlanConfigsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reviewPlanConfigs';
  @override
  final String actualTableName = 'reviewPlanConfigs';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReviewPlanConfigEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('reviewPlanId')) {
      context.handle(
          _reviewPlanIdMeta,
          reviewPlanId.isAcceptableOrUnknown(
              data['reviewPlanId'], _reviewPlanIdMeta));
    } else if (isInserting) {
      context.missing(_reviewPlanIdMeta);
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
    if (data.containsKey('createdBy')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['createdBy'], _createdByMeta));
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
  $UsersTable _users;
  $UsersTable get users => _users ??= $UsersTable(this);
  $FoldersTable _folders;
  $FoldersTable get folders => _folders ??= $FoldersTable(this);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  $ReviewPlansTable _reviewPlans;
  $ReviewPlansTable get reviewPlans => _reviewPlans ??= $ReviewPlansTable(this);
  $ReviewPlanConfigsTable _reviewPlanConfigs;
  $ReviewPlanConfigsTable get reviewPlanConfigs =>
      _reviewPlanConfigs ??= $ReviewPlanConfigsTable(this);
  Selectable<GetFoldersWithUnreadTotalResult> getFoldersWithUnreadTotal(
      int createdBy) {
    return customSelect(
        'SELECT f.id, f.name, f.[order], CASE WHEN f.isDefaultFolder = 1 AND f.name = \'今天\' THEN( SELECT count( *) FROM notes n, folders f WHERE n.folderId = f.id AND f.reviewPlanId IS NOT NULL AND n.isDeleted = 0 AND strftime(\'%Y-%m-%d %H:%M:%S\', n.nextReviewTime) < strftime(\'%Y-%m-%d %H:%M:%S\', \'now\', \'localtime\', \'start of day\', \'+1 day\') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ) WHEN f.isDefaultFolder = 1 AND f.name = \'全部笔记\' THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ) WHEN f.isDefaultFolder = 1 AND f.name = \'删除笔记\' THEN ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ) ELSE ( SELECT count( * ) FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = f.id AND CASE WHEN f.reviewPlanId IS NOT NULL THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ) END numberToShow, f.isDefaultFolder, f.reviewPlanId, f.created, f.createdBy FROM folders f WHERE createdBy = :createdBy ORDER BY [order] ASC;',
        variables: [Variable.withInt(createdBy)],
        readsFrom: {folders, notes}).map((QueryRow row) {
      return GetFoldersWithUnreadTotalResult(
        id: row.readInt('id'),
        name: row.readString('name'),
        order: row.readInt('order'),
        numberToShow: row.readInt('numberToShow'),
        isDefaultFolder: row.readBool('isDefaultFolder'),
        reviewPlanId: row.readInt('reviewPlanId'),
        created: $FoldersTable.$converter0.mapToDart(row.readString('created')),
        createdBy: row.readInt('createdBy'),
      );
    });
  }

  Selectable<GetNoteListForTodayResult> getNoteListForToday(
      int createdBy, int pageSize, double pageNo) {
    return customSelect(
        'SELECT n.id, n.folderId, CASE WHEN INSTR(content, \'&lt;/p&gt;\') > 0 THEN substr(content, 1, INSTR(content, \'&lt;/p&gt;\') + 9) ELSE content END AS title, n.content, n.created, n.updated, n.nextReviewTime, CASE WHEN n.reviewProgressNo IS NULL THEN 0 ELSE n.reviewProgressNo END AS reviewProgressNo, n.isReviewFinished, n.isDeleted, n.createdBy,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n, folders f WHERE n.folderId = f.id AND f.reviewPlanId IS NOT NULL AND n.isDeleted = 0 AND strftime(\'%Y-%m-%d %H:%M:%S\', n.nextReviewTime) < strftime(\'%Y-%m-%d %H:%M:%S\', \'now\', \'localtime\', \'start of day\', \'+1 day\') AND n.isReviewFinished = 0 AND n.createdBy = :createdBy ORDER BY n.nextReviewTime ASC, n.id ASC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1);',
        variables: [
          Variable.withInt(createdBy),
          Variable.withInt(pageSize),
          Variable.withReal(pageNo)
        ],
        readsFrom: {
          notes,
          reviewPlanConfigs,
          folders
        }).map((QueryRow row) {
      return GetNoteListForTodayResult(
        id: row.readInt('id'),
        folderId: row.readInt('folderId'),
        title: row.readString('title'),
        content: row.readString('content'),
        created: $NotesTable.$converter0.mapToDart(row.readString('created')),
        updated: $NotesTable.$converter1.mapToDart(row.readString('updated')),
        nextReviewTime:
            $NotesTable.$converter2.mapToDart(row.readString('nextReviewTime')),
        reviewProgressNo: row.readInt('reviewProgressNo'),
        isReviewFinished: row.readBool('isReviewFinished'),
        isDeleted: row.readBool('isDeleted'),
        createdBy: row.readInt('createdBy'),
        progressTotal: row.readInt('progressTotal'),
      );
    });
  }

  Selectable<GetNoteListForAllNotesResult> getNoteListForAllNotes(
      int createdBy, int pageSize, double pageNo) {
    return customSelect(
        'SELECT id, folderId, CASE WHEN INSTR(content, \'&lt;/p&gt;\') > 0 THEN substr(content, 1, INSTR(content, \'&lt;/p&gt;\') + 9) ELSE content END AS title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy ORDER BY n.updated DESC, n.id DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1);',
        variables: [
          Variable.withInt(createdBy),
          Variable.withInt(pageSize),
          Variable.withReal(pageNo)
        ],
        readsFrom: {
          notes,
          reviewPlanConfigs,
          folders
        }).map((QueryRow row) {
      return GetNoteListForAllNotesResult(
        id: row.readInt('id'),
        folderId: row.readInt('folderId'),
        title: row.readString('title'),
        content: row.readString('content'),
        created: $NotesTable.$converter0.mapToDart(row.readString('created')),
        updated: $NotesTable.$converter1.mapToDart(row.readString('updated')),
        nextReviewTime:
            $NotesTable.$converter2.mapToDart(row.readString('nextReviewTime')),
        reviewProgressNo: row.readInt('reviewProgressNo'),
        isReviewFinished: row.readBool('isReviewFinished'),
        isDeleted: row.readBool('isDeleted'),
        createdBy: row.readInt('createdBy'),
        progressTotal: row.readInt('progressTotal'),
      );
    });
  }

  Selectable<GetNoteListForDeletedNotesResult> getNoteListForDeletedNotes(
      int createdBy, int pageSize, double pageNo) {
    return customSelect(
        'SELECT id, folderId, CASE WHEN INSTR(content, \'&lt;/p&gt;\') > 0 THEN substr(content, 1, INSTR(content, \'&lt;/p&gt;\') + 9) ELSE content END AS title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy,( SELECT count( *) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 1 AND n.createdBy = :createdBy ORDER BY n.updated DESC, n.id DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1);',
        variables: [
          Variable.withInt(createdBy),
          Variable.withInt(pageSize),
          Variable.withReal(pageNo)
        ],
        readsFrom: {
          notes,
          reviewPlanConfigs,
          folders
        }).map((QueryRow row) {
      return GetNoteListForDeletedNotesResult(
        id: row.readInt('id'),
        folderId: row.readInt('folderId'),
        title: row.readString('title'),
        content: row.readString('content'),
        created: $NotesTable.$converter0.mapToDart(row.readString('created')),
        updated: $NotesTable.$converter1.mapToDart(row.readString('updated')),
        nextReviewTime:
            $NotesTable.$converter2.mapToDart(row.readString('nextReviewTime')),
        reviewProgressNo: row.readInt('reviewProgressNo'),
        isReviewFinished: row.readBool('isReviewFinished'),
        isDeleted: row.readBool('isDeleted'),
        createdBy: row.readInt('createdBy'),
        progressTotal: row.readInt('progressTotal'),
      );
    });
  }

  Selectable<GetNoteListForUserFoldersResult> getNoteListForUserFolders(
      int folderId, int createdBy, int pageSize, double pageNo) {
    return customSelect(
        'WITH isReviewFolderTable AS( SELECT CASE WHEN reviewPlanId IS NOT NULL THEN 1 ELSE 0 END AS isReviewFolder FROM folders WHERE id = :folderId) SELECT id, folderId, CASE WHEN INSTR(content, \'&lt;/p&gt;\') > 0 THEN substr(content, 1, INSTR(content, \'&lt;/p&gt;\') + 9) ELSE content END AS title, content, created, updated, nextReviewTime, CASE WHEN reviewProgressNo IS NULL THEN 0 ELSE reviewProgressNo END AS reviewProgressNo, isReviewFinished, isDeleted, createdBy, ( SELECT count( * ) FROM reviewPlanConfigs WHERE reviewPlanId = ( SELECT reviewPlanId FROM folders WHERE id = ( SELECT folderId FROM notes WHERE id = n.id ) ) ) AS progressTotal FROM notes n WHERE n.isDeleted = 0 AND n.createdBy = :createdBy AND n.folderId = :folderId AND CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.nextReviewTime IS NOT NULL ELSE n.nextReviewTime IS NULL END ORDER BY n.isReviewFinished ASC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.nextReviewTime END ASC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 0 THEN n.updated END DESC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 1 THEN n.updated END DESC, CASE WHEN ( SELECT isReviewFolder FROM isReviewFolderTable ) = 0 THEN n.id END DESC LIMIT :pageSize OFFSET :pageSize * (:pageNo - 1);',
        variables: [
          Variable.withInt(folderId),
          Variable.withInt(createdBy),
          Variable.withInt(pageSize),
          Variable.withReal(pageNo)
        ],
        readsFrom: {
          folders,
          notes,
          reviewPlanConfigs
        }).map((QueryRow row) {
      return GetNoteListForUserFoldersResult(
        id: row.readInt('id'),
        folderId: row.readInt('folderId'),
        title: row.readString('title'),
        content: row.readString('content'),
        created: $NotesTable.$converter0.mapToDart(row.readString('created')),
        updated: $NotesTable.$converter1.mapToDart(row.readString('updated')),
        nextReviewTime:
            $NotesTable.$converter2.mapToDart(row.readString('nextReviewTime')),
        reviewProgressNo: row.readInt('reviewProgressNo'),
        isReviewFinished: row.readBool('isReviewFinished'),
        isDeleted: row.readBool('isDeleted'),
        createdBy: row.readInt('createdBy'),
        progressTotal: row.readInt('progressTotal'),
      );
    });
  }

  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, folders, notes, reviewPlans, reviewPlanConfigs];
}

class GetFoldersWithUnreadTotalResult {
  final int id;
  final String name;
  final int order;
  final int numberToShow;
  final bool isDefaultFolder;
  final int reviewPlanId;
  final DateTime created;
  final int createdBy;
  GetFoldersWithUnreadTotalResult({
    this.id,
    this.name,
    this.order,
    this.numberToShow,
    this.isDefaultFolder,
    this.reviewPlanId,
    this.created,
    this.createdBy,
  });
}

class GetNoteListForTodayResult {
  final int id;
  final int folderId;
  final String title;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime nextReviewTime;
  final int reviewProgressNo;
  final bool isReviewFinished;
  final bool isDeleted;
  final int createdBy;
  final int progressTotal;
  GetNoteListForTodayResult({
    this.id,
    this.folderId,
    this.title,
    this.content,
    this.created,
    this.updated,
    this.nextReviewTime,
    this.reviewProgressNo,
    this.isReviewFinished,
    this.isDeleted,
    this.createdBy,
    this.progressTotal,
  });
}

class GetNoteListForAllNotesResult {
  final int id;
  final int folderId;
  final String title;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime nextReviewTime;
  final int reviewProgressNo;
  final bool isReviewFinished;
  final bool isDeleted;
  final int createdBy;
  final int progressTotal;
  GetNoteListForAllNotesResult({
    this.id,
    this.folderId,
    this.title,
    this.content,
    this.created,
    this.updated,
    this.nextReviewTime,
    this.reviewProgressNo,
    this.isReviewFinished,
    this.isDeleted,
    this.createdBy,
    this.progressTotal,
  });
}

class GetNoteListForDeletedNotesResult {
  final int id;
  final int folderId;
  final String title;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime nextReviewTime;
  final int reviewProgressNo;
  final bool isReviewFinished;
  final bool isDeleted;
  final int createdBy;
  final int progressTotal;
  GetNoteListForDeletedNotesResult({
    this.id,
    this.folderId,
    this.title,
    this.content,
    this.created,
    this.updated,
    this.nextReviewTime,
    this.reviewProgressNo,
    this.isReviewFinished,
    this.isDeleted,
    this.createdBy,
    this.progressTotal,
  });
}

class GetNoteListForUserFoldersResult {
  final int id;
  final int folderId;
  final String title;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime nextReviewTime;
  final int reviewProgressNo;
  final bool isReviewFinished;
  final bool isDeleted;
  final int createdBy;
  final int progressTotal;
  GetNoteListForUserFoldersResult({
    this.id,
    this.folderId,
    this.title,
    this.content,
    this.created,
    this.updated,
    this.nextReviewTime,
    this.reviewProgressNo,
    this.isReviewFinished,
    this.isDeleted,
    this.createdBy,
    this.progressTotal,
  });
}
