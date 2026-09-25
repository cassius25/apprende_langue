// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalLanguagesTable extends LocalLanguages
    with TableInfo<$LocalLanguagesTable, LocalLanguage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nativeNameMeta = const VerificationMeta(
    'nativeName',
  );
  @override
  late final GeneratedColumn<String> nativeName = GeneratedColumn<String>(
    'native_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagEmojiMeta = const VerificationMeta(
    'flagEmoji',
  );
  @override
  late final GeneratedColumn<String> flagEmoji = GeneratedColumn<String>(
    'flag_emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    nativeName,
    flagEmoji,
    isActive,
    serverUpdatedAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_languages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLanguage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('native_name')) {
      context.handle(
        _nativeNameMeta,
        nativeName.isAcceptableOrUnknown(data['native_name']!, _nativeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_nativeNameMeta);
    }
    if (data.containsKey('flag_emoji')) {
      context.handle(
        _flagEmojiMeta,
        flagEmoji.isAcceptableOrUnknown(data['flag_emoji']!, _flagEmojiMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLanguage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLanguage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nativeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}native_name'],
      )!,
      flagEmoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_emoji'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $LocalLanguagesTable createAlias(String alias) {
    return $LocalLanguagesTable(attachedDatabase, alias);
  }
}

class LocalLanguage extends DataClass implements Insertable<LocalLanguage> {
  final String id;
  final String code;
  final String name;
  final String nativeName;
  final String? flagEmoji;
  final bool isActive;
  final DateTime serverUpdatedAt;
  final DateTime syncedAt;
  const LocalLanguage({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    this.flagEmoji,
    required this.isActive,
    required this.serverUpdatedAt,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['native_name'] = Variable<String>(nativeName);
    if (!nullToAbsent || flagEmoji != null) {
      map['flag_emoji'] = Variable<String>(flagEmoji);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  LocalLanguagesCompanion toCompanion(bool nullToAbsent) {
    return LocalLanguagesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      nativeName: Value(nativeName),
      flagEmoji: flagEmoji == null && nullToAbsent
          ? const Value.absent()
          : Value(flagEmoji),
      isActive: Value(isActive),
      serverUpdatedAt: Value(serverUpdatedAt),
      syncedAt: Value(syncedAt),
    );
  }

  factory LocalLanguage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLanguage(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      nativeName: serializer.fromJson<String>(json['nativeName']),
      flagEmoji: serializer.fromJson<String?>(json['flagEmoji']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'nativeName': serializer.toJson<String>(nativeName),
      'flagEmoji': serializer.toJson<String?>(flagEmoji),
      'isActive': serializer.toJson<bool>(isActive),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  LocalLanguage copyWith({
    String? id,
    String? code,
    String? name,
    String? nativeName,
    Value<String?> flagEmoji = const Value.absent(),
    bool? isActive,
    DateTime? serverUpdatedAt,
    DateTime? syncedAt,
  }) => LocalLanguage(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    nativeName: nativeName ?? this.nativeName,
    flagEmoji: flagEmoji.present ? flagEmoji.value : this.flagEmoji,
    isActive: isActive ?? this.isActive,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  LocalLanguage copyWithCompanion(LocalLanguagesCompanion data) {
    return LocalLanguage(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      nativeName: data.nativeName.present
          ? data.nativeName.value
          : this.nativeName,
      flagEmoji: data.flagEmoji.present ? data.flagEmoji.value : this.flagEmoji,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLanguage(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nativeName: $nativeName, ')
          ..write('flagEmoji: $flagEmoji, ')
          ..write('isActive: $isActive, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    nativeName,
    flagEmoji,
    isActive,
    serverUpdatedAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLanguage &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.nativeName == this.nativeName &&
          other.flagEmoji == this.flagEmoji &&
          other.isActive == this.isActive &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.syncedAt == this.syncedAt);
}

class LocalLanguagesCompanion extends UpdateCompanion<LocalLanguage> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> nativeName;
  final Value<String?> flagEmoji;
  final Value<bool> isActive;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime> syncedAt;
  final Value<int> rowid;
  const LocalLanguagesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.nativeName = const Value.absent(),
    this.flagEmoji = const Value.absent(),
    this.isActive = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLanguagesCompanion.insert({
    required String id,
    required String code,
    required String name,
    required String nativeName,
    this.flagEmoji = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       nativeName = Value(nativeName),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalLanguage> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? nativeName,
    Expression<String>? flagEmoji,
    Expression<bool>? isActive,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (nativeName != null) 'native_name': nativeName,
      if (flagEmoji != null) 'flag_emoji': flagEmoji,
      if (isActive != null) 'is_active': isActive,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLanguagesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? nativeName,
    Value<String?>? flagEmoji,
    Value<bool>? isActive,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime>? syncedAt,
    Value<int>? rowid,
  }) {
    return LocalLanguagesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      flagEmoji: flagEmoji ?? this.flagEmoji,
      isActive: isActive ?? this.isActive,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nativeName.present) {
      map['native_name'] = Variable<String>(nativeName.value);
    }
    if (flagEmoji.present) {
      map['flag_emoji'] = Variable<String>(flagEmoji.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLanguagesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('nativeName: $nativeName, ')
          ..write('flagEmoji: $flagEmoji, ')
          ..write('isActive: $isActive, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLevelsTable extends LocalLevels
    with TableInfo<$LocalLevelsTable, LocalLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    description,
    order,
    serverUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLevel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLevel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
    );
  }

  @override
  $LocalLevelsTable createAlias(String alias) {
    return $LocalLevelsTable(attachedDatabase, alias);
  }
}

class LocalLevel extends DataClass implements Insertable<LocalLevel> {
  final String id;
  final String code;
  final String name;
  final String? description;
  final int order;
  final DateTime serverUpdatedAt;
  const LocalLevel({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.order,
    required this.serverUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order'] = Variable<int>(order);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    return map;
  }

  LocalLevelsCompanion toCompanion(bool nullToAbsent) {
    return LocalLevelsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      order: Value(order),
      serverUpdatedAt: Value(serverUpdatedAt),
    );
  }

  factory LocalLevel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLevel(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'order': serializer.toJson<int>(order),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
    };
  }

  LocalLevel copyWith({
    String? id,
    String? code,
    String? name,
    Value<String?> description = const Value.absent(),
    int? order,
    DateTime? serverUpdatedAt,
  }) => LocalLevel(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    order: order ?? this.order,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
  );
  LocalLevel copyWithCompanion(LocalLevelsCompanion data) {
    return LocalLevel(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      order: data.order.present ? data.order.value : this.order,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLevel(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, description, order, serverUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLevel &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.order == this.order &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class LocalLevelsCompanion extends UpdateCompanion<LocalLevel> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> order;
  final Value<DateTime> serverUpdatedAt;
  final Value<int> rowid;
  const LocalLevelsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLevelsCompanion.insert({
    required String id,
    required String code,
    required String name,
    this.description = const Value.absent(),
    required int order,
    required DateTime serverUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       order = Value(order),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalLevel> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? order,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLevelsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? order,
    Value<DateTime>? serverUpdatedAt,
    Value<int>? rowid,
  }) {
    return LocalLevelsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      order: order ?? this.order,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLevelsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCoursesTable extends LocalCourses
    with TableInfo<$LocalCoursesTable, LocalCourse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageIdMeta = const VerificationMeta(
    'languageId',
  );
  @override
  late final GeneratedColumn<String> languageId = GeneratedColumn<String>(
    'language_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    languageId,
    levelId,
    title,
    description,
    order,
    isPublished,
    serverUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCourse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language_id')) {
      context.handle(
        _languageIdMeta,
        languageId.isAcceptableOrUnknown(data['language_id']!, _languageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_languageIdMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCourse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCourse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      languageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_id'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalCoursesTable createAlias(String alias) {
    return $LocalCoursesTable(attachedDatabase, alias);
  }
}

class LocalCourse extends DataClass implements Insertable<LocalCourse> {
  final String id;
  final String languageId;
  final String levelId;
  final String title;
  final String? description;
  final int order;
  final bool isPublished;
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  const LocalCourse({
    required this.id,
    required this.languageId,
    required this.levelId,
    required this.title,
    this.description,
    required this.order,
    required this.isPublished,
    required this.serverUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language_id'] = Variable<String>(languageId);
    map['level_id'] = Variable<String>(levelId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order'] = Variable<int>(order);
    map['is_published'] = Variable<bool>(isPublished);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalCoursesCompanion toCompanion(bool nullToAbsent) {
    return LocalCoursesCompanion(
      id: Value(id),
      languageId: Value(languageId),
      levelId: Value(levelId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      order: Value(order),
      isPublished: Value(isPublished),
      serverUpdatedAt: Value(serverUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalCourse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCourse(
      id: serializer.fromJson<String>(json['id']),
      languageId: serializer.fromJson<String>(json['languageId']),
      levelId: serializer.fromJson<String>(json['levelId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'languageId': serializer.toJson<String>(languageId),
      'levelId': serializer.toJson<String>(levelId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'order': serializer.toJson<int>(order),
      'isPublished': serializer.toJson<bool>(isPublished),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalCourse copyWith({
    String? id,
    String? languageId,
    String? levelId,
    String? title,
    Value<String?> description = const Value.absent(),
    int? order,
    bool? isPublished,
    DateTime? serverUpdatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalCourse(
    id: id ?? this.id,
    languageId: languageId ?? this.languageId,
    levelId: levelId ?? this.levelId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    order: order ?? this.order,
    isPublished: isPublished ?? this.isPublished,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalCourse copyWithCompanion(LocalCoursesCompanion data) {
    return LocalCourse(
      id: data.id.present ? data.id.value : this.id,
      languageId: data.languageId.present
          ? data.languageId.value
          : this.languageId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      order: data.order.present ? data.order.value : this.order,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCourse(')
          ..write('id: $id, ')
          ..write('languageId: $languageId, ')
          ..write('levelId: $levelId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('isPublished: $isPublished, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    languageId,
    levelId,
    title,
    description,
    order,
    isPublished,
    serverUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCourse &&
          other.id == this.id &&
          other.languageId == this.languageId &&
          other.levelId == this.levelId &&
          other.title == this.title &&
          other.description == this.description &&
          other.order == this.order &&
          other.isPublished == this.isPublished &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalCoursesCompanion extends UpdateCompanion<LocalCourse> {
  final Value<String> id;
  final Value<String> languageId;
  final Value<String> levelId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> order;
  final Value<bool> isPublished;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalCoursesCompanion({
    this.id = const Value.absent(),
    this.languageId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCoursesCompanion.insert({
    required String id,
    required String languageId,
    required String levelId,
    required String title,
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.isPublished = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       languageId = Value(languageId),
       levelId = Value(levelId),
       title = Value(title),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalCourse> custom({
    Expression<String>? id,
    Expression<String>? languageId,
    Expression<String>? levelId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? order,
    Expression<bool>? isPublished,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (languageId != null) 'language_id': languageId,
      if (levelId != null) 'level_id': levelId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (isPublished != null) 'is_published': isPublished,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCoursesCompanion copyWith({
    Value<String>? id,
    Value<String>? languageId,
    Value<String>? levelId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? order,
    Value<bool>? isPublished,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalCoursesCompanion(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      levelId: levelId ?? this.levelId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isPublished: isPublished ?? this.isPublished,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (languageId.present) {
      map['language_id'] = Variable<String>(languageId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCoursesCompanion(')
          ..write('id: $id, ')
          ..write('languageId: $languageId, ')
          ..write('levelId: $levelId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('isPublished: $isPublished, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalModulesTable extends LocalModules
    with TableInfo<$LocalModulesTable, LocalModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    title,
    description,
    order,
    serverUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_modules';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalModule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalModule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalModulesTable createAlias(String alias) {
    return $LocalModulesTable(attachedDatabase, alias);
  }
}

class LocalModule extends DataClass implements Insertable<LocalModule> {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int order;
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  const LocalModule({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.order,
    required this.serverUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order'] = Variable<int>(order);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalModulesCompanion toCompanion(bool nullToAbsent) {
    return LocalModulesCompanion(
      id: Value(id),
      courseId: Value(courseId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      order: Value(order),
      serverUpdatedAt: Value(serverUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalModule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalModule(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'order': serializer.toJson<int>(order),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalModule copyWith({
    String? id,
    String? courseId,
    String? title,
    Value<String?> description = const Value.absent(),
    int? order,
    DateTime? serverUpdatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalModule(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    order: order ?? this.order,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalModule copyWithCompanion(LocalModulesCompanion data) {
    return LocalModule(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      order: data.order.present ? data.order.value : this.order,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalModule(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    title,
    description,
    order,
    serverUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalModule &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.description == this.description &&
          other.order == this.order &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalModulesCompanion extends UpdateCompanion<LocalModule> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> order;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalModulesCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalModulesCompanion.insert({
    required String id,
    required String courseId,
    required String title,
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       title = Value(title),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalModule> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? order,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalModulesCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? order,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalModulesCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalModulesCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLessonsTable extends LocalLessons
    with TableInfo<$LocalLessonsTable, LocalLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _estimatedDurationMeta = const VerificationMeta(
    'estimatedDuration',
  );
  @override
  late final GeneratedColumn<int> estimatedDuration = GeneratedColumn<int>(
    'estimated_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    moduleId,
    title,
    description,
    order,
    estimatedDuration,
    isPublished,
    serverUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    if (data.containsKey('estimated_duration')) {
      context.handle(
        _estimatedDurationMeta,
        estimatedDuration.isAcceptableOrUnknown(
          data['estimated_duration']!,
          _estimatedDurationMeta,
        ),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      estimatedDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_duration'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalLessonsTable createAlias(String alias) {
    return $LocalLessonsTable(attachedDatabase, alias);
  }
}

class LocalLesson extends DataClass implements Insertable<LocalLesson> {
  final String id;
  final String moduleId;
  final String title;
  final String? description;
  final int order;
  final int estimatedDuration;
  final bool isPublished;
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  const LocalLesson({
    required this.id,
    required this.moduleId,
    required this.title,
    this.description,
    required this.order,
    required this.estimatedDuration,
    required this.isPublished,
    required this.serverUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['module_id'] = Variable<String>(moduleId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order'] = Variable<int>(order);
    map['estimated_duration'] = Variable<int>(estimatedDuration);
    map['is_published'] = Variable<bool>(isPublished);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalLessonsCompanion toCompanion(bool nullToAbsent) {
    return LocalLessonsCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      order: Value(order),
      estimatedDuration: Value(estimatedDuration),
      isPublished: Value(isPublished),
      serverUpdatedAt: Value(serverUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLesson(
      id: serializer.fromJson<String>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      order: serializer.fromJson<int>(json['order']),
      estimatedDuration: serializer.fromJson<int>(json['estimatedDuration']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'order': serializer.toJson<int>(order),
      'estimatedDuration': serializer.toJson<int>(estimatedDuration),
      'isPublished': serializer.toJson<bool>(isPublished),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalLesson copyWith({
    String? id,
    String? moduleId,
    String? title,
    Value<String?> description = const Value.absent(),
    int? order,
    int? estimatedDuration,
    bool? isPublished,
    DateTime? serverUpdatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalLesson(
    id: id ?? this.id,
    moduleId: moduleId ?? this.moduleId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    order: order ?? this.order,
    estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    isPublished: isPublished ?? this.isPublished,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalLesson copyWithCompanion(LocalLessonsCompanion data) {
    return LocalLesson(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      order: data.order.present ? data.order.value : this.order,
      estimatedDuration: data.estimatedDuration.present
          ? data.estimatedDuration.value
          : this.estimatedDuration,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLesson(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('estimatedDuration: $estimatedDuration, ')
          ..write('isPublished: $isPublished, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    moduleId,
    title,
    description,
    order,
    estimatedDuration,
    isPublished,
    serverUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLesson &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.title == this.title &&
          other.description == this.description &&
          other.order == this.order &&
          other.estimatedDuration == this.estimatedDuration &&
          other.isPublished == this.isPublished &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalLessonsCompanion extends UpdateCompanion<LocalLesson> {
  final Value<String> id;
  final Value<String> moduleId;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> order;
  final Value<int> estimatedDuration;
  final Value<bool> isPublished;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalLessonsCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.estimatedDuration = const Value.absent(),
    this.isPublished = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLessonsCompanion.insert({
    required String id,
    required String moduleId,
    required String title,
    this.description = const Value.absent(),
    this.order = const Value.absent(),
    this.estimatedDuration = const Value.absent(),
    this.isPublished = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       moduleId = Value(moduleId),
       title = Value(title),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalLesson> custom({
    Expression<String>? id,
    Expression<String>? moduleId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? order,
    Expression<int>? estimatedDuration,
    Expression<bool>? isPublished,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (order != null) 'order': order,
      if (estimatedDuration != null) 'estimated_duration': estimatedDuration,
      if (isPublished != null) 'is_published': isPublished,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLessonsCompanion copyWith({
    Value<String>? id,
    Value<String>? moduleId,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? order,
    Value<int>? estimatedDuration,
    Value<bool>? isPublished,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalLessonsCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isPublished: isPublished ?? this.isPublished,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (estimatedDuration.present) {
      map['estimated_duration'] = Variable<int>(estimatedDuration.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLessonsCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('order: $order, ')
          ..write('estimatedDuration: $estimatedDuration, ')
          ..write('isPublished: $isPublished, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLessonContentsTable extends LocalLessonContents
    with TableInfo<$LocalLessonContentsTable, LocalLessonContent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLessonContentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, type, content, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_lesson_contents';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLessonContent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLessonContent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLessonContent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $LocalLessonContentsTable createAlias(String alias) {
    return $LocalLessonContentsTable(attachedDatabase, alias);
  }
}

class LocalLessonContent extends DataClass
    implements Insertable<LocalLessonContent> {
  final String id;
  final String lessonId;
  final String type;
  final String content;
  final int order;
  const LocalLessonContent({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.content,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['type'] = Variable<String>(type);
    map['content'] = Variable<String>(content);
    map['order'] = Variable<int>(order);
    return map;
  }

  LocalLessonContentsCompanion toCompanion(bool nullToAbsent) {
    return LocalLessonContentsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      type: Value(type),
      content: Value(content),
      order: Value(order),
    );
  }

  factory LocalLessonContent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLessonContent(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      type: serializer.fromJson<String>(json['type']),
      content: serializer.fromJson<String>(json['content']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'type': serializer.toJson<String>(type),
      'content': serializer.toJson<String>(content),
      'order': serializer.toJson<int>(order),
    };
  }

  LocalLessonContent copyWith({
    String? id,
    String? lessonId,
    String? type,
    String? content,
    int? order,
  }) => LocalLessonContent(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    type: type ?? this.type,
    content: content ?? this.content,
    order: order ?? this.order,
  );
  LocalLessonContent copyWithCompanion(LocalLessonContentsCompanion data) {
    return LocalLessonContent(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      type: data.type.present ? data.type.value : this.type,
      content: data.content.present ? data.content.value : this.content,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLessonContent(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, type, content, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLessonContent &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.type == this.type &&
          other.content == this.content &&
          other.order == this.order);
}

class LocalLessonContentsCompanion extends UpdateCompanion<LocalLessonContent> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> type;
  final Value<String> content;
  final Value<int> order;
  final Value<int> rowid;
  const LocalLessonContentsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.type = const Value.absent(),
    this.content = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLessonContentsCompanion.insert({
    required String id,
    required String lessonId,
    required String type,
    required String content,
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lessonId = Value(lessonId),
       type = Value(type),
       content = Value(content);
  static Insertable<LocalLessonContent> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? type,
    Expression<String>? content,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (type != null) 'type': type,
      if (content != null) 'content': content,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLessonContentsCompanion copyWith({
    Value<String>? id,
    Value<String>? lessonId,
    Value<String>? type,
    Value<String>? content,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return LocalLessonContentsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      type: type ?? this.type,
      content: content ?? this.content,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLessonContentsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('type: $type, ')
          ..write('content: $content, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVocabularyTable extends LocalVocabulary
    with TableInfo<$LocalVocabularyTable, LocalVocabularyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVocabularyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageIdMeta = const VerificationMeta(
    'languageId',
  );
  @override
  late final GeneratedColumn<String> languageId = GeneratedColumn<String>(
    'language_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneticMeta = const VerificationMeta(
    'phonetic',
  );
  @override
  late final GeneratedColumn<String> phonetic = GeneratedColumn<String>(
    'phonetic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partOfSpeechMeta = const VerificationMeta(
    'partOfSpeech',
  );
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
    'part_of_speech',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    languageId,
    levelId,
    word,
    phonetic,
    audioUrl,
    imageUrl,
    category,
    partOfSpeech,
    serverUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vocabulary';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVocabularyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language_id')) {
      context.handle(
        _languageIdMeta,
        languageId.isAcceptableOrUnknown(data['language_id']!, _languageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_languageIdMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('phonetic')) {
      context.handle(
        _phoneticMeta,
        phonetic.isAcceptableOrUnknown(data['phonetic']!, _phoneticMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
        _partOfSpeechMeta,
        partOfSpeech.isAcceptableOrUnknown(
          data['part_of_speech']!,
          _partOfSpeechMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVocabularyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVocabularyData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      languageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_id'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      phonetic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phonetic'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      partOfSpeech: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_of_speech'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalVocabularyTable createAlias(String alias) {
    return $LocalVocabularyTable(attachedDatabase, alias);
  }
}

class LocalVocabularyData extends DataClass
    implements Insertable<LocalVocabularyData> {
  final String id;
  final String languageId;
  final String levelId;
  final String word;
  final String? phonetic;
  final String? audioUrl;
  final String? imageUrl;
  final String? category;
  final String? partOfSpeech;
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  const LocalVocabularyData({
    required this.id,
    required this.languageId,
    required this.levelId,
    required this.word,
    this.phonetic,
    this.audioUrl,
    this.imageUrl,
    this.category,
    this.partOfSpeech,
    required this.serverUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language_id'] = Variable<String>(languageId);
    map['level_id'] = Variable<String>(levelId);
    map['word'] = Variable<String>(word);
    if (!nullToAbsent || phonetic != null) {
      map['phonetic'] = Variable<String>(phonetic);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || partOfSpeech != null) {
      map['part_of_speech'] = Variable<String>(partOfSpeech);
    }
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalVocabularyCompanion toCompanion(bool nullToAbsent) {
    return LocalVocabularyCompanion(
      id: Value(id),
      languageId: Value(languageId),
      levelId: Value(levelId),
      word: Value(word),
      phonetic: phonetic == null && nullToAbsent
          ? const Value.absent()
          : Value(phonetic),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      partOfSpeech: partOfSpeech == null && nullToAbsent
          ? const Value.absent()
          : Value(partOfSpeech),
      serverUpdatedAt: Value(serverUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalVocabularyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVocabularyData(
      id: serializer.fromJson<String>(json['id']),
      languageId: serializer.fromJson<String>(json['languageId']),
      levelId: serializer.fromJson<String>(json['levelId']),
      word: serializer.fromJson<String>(json['word']),
      phonetic: serializer.fromJson<String?>(json['phonetic']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      category: serializer.fromJson<String?>(json['category']),
      partOfSpeech: serializer.fromJson<String?>(json['partOfSpeech']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'languageId': serializer.toJson<String>(languageId),
      'levelId': serializer.toJson<String>(levelId),
      'word': serializer.toJson<String>(word),
      'phonetic': serializer.toJson<String?>(phonetic),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'category': serializer.toJson<String?>(category),
      'partOfSpeech': serializer.toJson<String?>(partOfSpeech),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalVocabularyData copyWith({
    String? id,
    String? languageId,
    String? levelId,
    String? word,
    Value<String?> phonetic = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> partOfSpeech = const Value.absent(),
    DateTime? serverUpdatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalVocabularyData(
    id: id ?? this.id,
    languageId: languageId ?? this.languageId,
    levelId: levelId ?? this.levelId,
    word: word ?? this.word,
    phonetic: phonetic.present ? phonetic.value : this.phonetic,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    category: category.present ? category.value : this.category,
    partOfSpeech: partOfSpeech.present ? partOfSpeech.value : this.partOfSpeech,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalVocabularyData copyWithCompanion(LocalVocabularyCompanion data) {
    return LocalVocabularyData(
      id: data.id.present ? data.id.value : this.id,
      languageId: data.languageId.present
          ? data.languageId.value
          : this.languageId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      word: data.word.present ? data.word.value : this.word,
      phonetic: data.phonetic.present ? data.phonetic.value : this.phonetic,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      category: data.category.present ? data.category.value : this.category,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVocabularyData(')
          ..write('id: $id, ')
          ..write('languageId: $languageId, ')
          ..write('levelId: $levelId, ')
          ..write('word: $word, ')
          ..write('phonetic: $phonetic, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('category: $category, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    languageId,
    levelId,
    word,
    phonetic,
    audioUrl,
    imageUrl,
    category,
    partOfSpeech,
    serverUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVocabularyData &&
          other.id == this.id &&
          other.languageId == this.languageId &&
          other.levelId == this.levelId &&
          other.word == this.word &&
          other.phonetic == this.phonetic &&
          other.audioUrl == this.audioUrl &&
          other.imageUrl == this.imageUrl &&
          other.category == this.category &&
          other.partOfSpeech == this.partOfSpeech &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalVocabularyCompanion extends UpdateCompanion<LocalVocabularyData> {
  final Value<String> id;
  final Value<String> languageId;
  final Value<String> levelId;
  final Value<String> word;
  final Value<String?> phonetic;
  final Value<String?> audioUrl;
  final Value<String?> imageUrl;
  final Value<String?> category;
  final Value<String?> partOfSpeech;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalVocabularyCompanion({
    this.id = const Value.absent(),
    this.languageId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.word = const Value.absent(),
    this.phonetic = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVocabularyCompanion.insert({
    required String id,
    required String languageId,
    required String levelId,
    required String word,
    this.phonetic = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       languageId = Value(languageId),
       levelId = Value(levelId),
       word = Value(word),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalVocabularyData> custom({
    Expression<String>? id,
    Expression<String>? languageId,
    Expression<String>? levelId,
    Expression<String>? word,
    Expression<String>? phonetic,
    Expression<String>? audioUrl,
    Expression<String>? imageUrl,
    Expression<String>? category,
    Expression<String>? partOfSpeech,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (languageId != null) 'language_id': languageId,
      if (levelId != null) 'level_id': levelId,
      if (word != null) 'word': word,
      if (phonetic != null) 'phonetic': phonetic,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (imageUrl != null) 'image_url': imageUrl,
      if (category != null) 'category': category,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVocabularyCompanion copyWith({
    Value<String>? id,
    Value<String>? languageId,
    Value<String>? levelId,
    Value<String>? word,
    Value<String?>? phonetic,
    Value<String?>? audioUrl,
    Value<String?>? imageUrl,
    Value<String?>? category,
    Value<String?>? partOfSpeech,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalVocabularyCompanion(
      id: id ?? this.id,
      languageId: languageId ?? this.languageId,
      levelId: levelId ?? this.levelId,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (languageId.present) {
      map['language_id'] = Variable<String>(languageId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (phonetic.present) {
      map['phonetic'] = Variable<String>(phonetic.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVocabularyCompanion(')
          ..write('id: $id, ')
          ..write('languageId: $languageId, ')
          ..write('levelId: $levelId, ')
          ..write('word: $word, ')
          ..write('phonetic: $phonetic, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('category: $category, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVocabularyTranslationsTable extends LocalVocabularyTranslations
    with
        TableInfo<
          $LocalVocabularyTranslationsTable,
          LocalVocabularyTranslation
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVocabularyTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<String> vocabularyId = GeneratedColumn<String>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageIdMeta = const VerificationMeta(
    'languageId',
  );
  @override
  late final GeneratedColumn<String> languageId = GeneratedColumn<String>(
    'language_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularyId,
    languageId,
    languageCode,
    translation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vocabulary_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVocabularyTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('language_id')) {
      context.handle(
        _languageIdMeta,
        languageId.isAcceptableOrUnknown(data['language_id']!, _languageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_languageIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVocabularyTranslation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVocabularyTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      languageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
    );
  }

  @override
  $LocalVocabularyTranslationsTable createAlias(String alias) {
    return $LocalVocabularyTranslationsTable(attachedDatabase, alias);
  }
}

class LocalVocabularyTranslation extends DataClass
    implements Insertable<LocalVocabularyTranslation> {
  final String id;
  final String vocabularyId;
  final String languageId;
  final String languageCode;
  final String translation;
  const LocalVocabularyTranslation({
    required this.id,
    required this.vocabularyId,
    required this.languageId,
    required this.languageCode,
    required this.translation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vocabulary_id'] = Variable<String>(vocabularyId);
    map['language_id'] = Variable<String>(languageId);
    map['language_code'] = Variable<String>(languageCode);
    map['translation'] = Variable<String>(translation);
    return map;
  }

  LocalVocabularyTranslationsCompanion toCompanion(bool nullToAbsent) {
    return LocalVocabularyTranslationsCompanion(
      id: Value(id),
      vocabularyId: Value(vocabularyId),
      languageId: Value(languageId),
      languageCode: Value(languageCode),
      translation: Value(translation),
    );
  }

  factory LocalVocabularyTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVocabularyTranslation(
      id: serializer.fromJson<String>(json['id']),
      vocabularyId: serializer.fromJson<String>(json['vocabularyId']),
      languageId: serializer.fromJson<String>(json['languageId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      translation: serializer.fromJson<String>(json['translation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vocabularyId': serializer.toJson<String>(vocabularyId),
      'languageId': serializer.toJson<String>(languageId),
      'languageCode': serializer.toJson<String>(languageCode),
      'translation': serializer.toJson<String>(translation),
    };
  }

  LocalVocabularyTranslation copyWith({
    String? id,
    String? vocabularyId,
    String? languageId,
    String? languageCode,
    String? translation,
  }) => LocalVocabularyTranslation(
    id: id ?? this.id,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    languageId: languageId ?? this.languageId,
    languageCode: languageCode ?? this.languageCode,
    translation: translation ?? this.translation,
  );
  LocalVocabularyTranslation copyWithCompanion(
    LocalVocabularyTranslationsCompanion data,
  ) {
    return LocalVocabularyTranslation(
      id: data.id.present ? data.id.value : this.id,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      languageId: data.languageId.present
          ? data.languageId.value
          : this.languageId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVocabularyTranslation(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('languageId: $languageId, ')
          ..write('languageCode: $languageCode, ')
          ..write('translation: $translation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vocabularyId, languageId, languageCode, translation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVocabularyTranslation &&
          other.id == this.id &&
          other.vocabularyId == this.vocabularyId &&
          other.languageId == this.languageId &&
          other.languageCode == this.languageCode &&
          other.translation == this.translation);
}

class LocalVocabularyTranslationsCompanion
    extends UpdateCompanion<LocalVocabularyTranslation> {
  final Value<String> id;
  final Value<String> vocabularyId;
  final Value<String> languageId;
  final Value<String> languageCode;
  final Value<String> translation;
  final Value<int> rowid;
  const LocalVocabularyTranslationsCompanion({
    this.id = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.languageId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.translation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVocabularyTranslationsCompanion.insert({
    required String id,
    required String vocabularyId,
    required String languageId,
    required String languageCode,
    required String translation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vocabularyId = Value(vocabularyId),
       languageId = Value(languageId),
       languageCode = Value(languageCode),
       translation = Value(translation);
  static Insertable<LocalVocabularyTranslation> custom({
    Expression<String>? id,
    Expression<String>? vocabularyId,
    Expression<String>? languageId,
    Expression<String>? languageCode,
    Expression<String>? translation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (languageId != null) 'language_id': languageId,
      if (languageCode != null) 'language_code': languageCode,
      if (translation != null) 'translation': translation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVocabularyTranslationsCompanion copyWith({
    Value<String>? id,
    Value<String>? vocabularyId,
    Value<String>? languageId,
    Value<String>? languageCode,
    Value<String>? translation,
    Value<int>? rowid,
  }) {
    return LocalVocabularyTranslationsCompanion(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      languageId: languageId ?? this.languageId,
      languageCode: languageCode ?? this.languageCode,
      translation: translation ?? this.translation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<String>(vocabularyId.value);
    }
    if (languageId.present) {
      map['language_id'] = Variable<String>(languageId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVocabularyTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('languageId: $languageId, ')
          ..write('languageCode: $languageCode, ')
          ..write('translation: $translation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVocabularyExamplesTable extends LocalVocabularyExamples
    with TableInfo<$LocalVocabularyExamplesTable, LocalVocabularyExample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVocabularyExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<String> vocabularyId = GeneratedColumn<String>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabularyId,
    sentence,
    translation,
    audioUrl,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_vocabulary_examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVocabularyExample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVocabularyExample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVocabularyExample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      sentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sentence'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      ),
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $LocalVocabularyExamplesTable createAlias(String alias) {
    return $LocalVocabularyExamplesTable(attachedDatabase, alias);
  }
}

class LocalVocabularyExample extends DataClass
    implements Insertable<LocalVocabularyExample> {
  final String id;
  final String vocabularyId;
  final String sentence;
  final String? translation;
  final String? audioUrl;
  final int order;
  const LocalVocabularyExample({
    required this.id,
    required this.vocabularyId,
    required this.sentence,
    this.translation,
    this.audioUrl,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vocabulary_id'] = Variable<String>(vocabularyId);
    map['sentence'] = Variable<String>(sentence);
    if (!nullToAbsent || translation != null) {
      map['translation'] = Variable<String>(translation);
    }
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['order'] = Variable<int>(order);
    return map;
  }

  LocalVocabularyExamplesCompanion toCompanion(bool nullToAbsent) {
    return LocalVocabularyExamplesCompanion(
      id: Value(id),
      vocabularyId: Value(vocabularyId),
      sentence: Value(sentence),
      translation: translation == null && nullToAbsent
          ? const Value.absent()
          : Value(translation),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      order: Value(order),
    );
  }

  factory LocalVocabularyExample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVocabularyExample(
      id: serializer.fromJson<String>(json['id']),
      vocabularyId: serializer.fromJson<String>(json['vocabularyId']),
      sentence: serializer.fromJson<String>(json['sentence']),
      translation: serializer.fromJson<String?>(json['translation']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vocabularyId': serializer.toJson<String>(vocabularyId),
      'sentence': serializer.toJson<String>(sentence),
      'translation': serializer.toJson<String?>(translation),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'order': serializer.toJson<int>(order),
    };
  }

  LocalVocabularyExample copyWith({
    String? id,
    String? vocabularyId,
    String? sentence,
    Value<String?> translation = const Value.absent(),
    Value<String?> audioUrl = const Value.absent(),
    int? order,
  }) => LocalVocabularyExample(
    id: id ?? this.id,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    sentence: sentence ?? this.sentence,
    translation: translation.present ? translation.value : this.translation,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    order: order ?? this.order,
  );
  LocalVocabularyExample copyWithCompanion(
    LocalVocabularyExamplesCompanion data,
  ) {
    return LocalVocabularyExample(
      id: data.id.present ? data.id.value : this.id,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVocabularyExample(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('sentence: $sentence, ')
          ..write('translation: $translation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vocabularyId, sentence, translation, audioUrl, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVocabularyExample &&
          other.id == this.id &&
          other.vocabularyId == this.vocabularyId &&
          other.sentence == this.sentence &&
          other.translation == this.translation &&
          other.audioUrl == this.audioUrl &&
          other.order == this.order);
}

class LocalVocabularyExamplesCompanion
    extends UpdateCompanion<LocalVocabularyExample> {
  final Value<String> id;
  final Value<String> vocabularyId;
  final Value<String> sentence;
  final Value<String?> translation;
  final Value<String?> audioUrl;
  final Value<int> order;
  final Value<int> rowid;
  const LocalVocabularyExamplesCompanion({
    this.id = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.sentence = const Value.absent(),
    this.translation = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVocabularyExamplesCompanion.insert({
    required String id,
    required String vocabularyId,
    required String sentence,
    this.translation = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vocabularyId = Value(vocabularyId),
       sentence = Value(sentence);
  static Insertable<LocalVocabularyExample> custom({
    Expression<String>? id,
    Expression<String>? vocabularyId,
    Expression<String>? sentence,
    Expression<String>? translation,
    Expression<String>? audioUrl,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (sentence != null) 'sentence': sentence,
      if (translation != null) 'translation': translation,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVocabularyExamplesCompanion copyWith({
    Value<String>? id,
    Value<String>? vocabularyId,
    Value<String>? sentence,
    Value<String?>? translation,
    Value<String?>? audioUrl,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return LocalVocabularyExamplesCompanion(
      id: id ?? this.id,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      sentence: sentence ?? this.sentence,
      translation: translation ?? this.translation,
      audioUrl: audioUrl ?? this.audioUrl,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<String>(vocabularyId.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVocabularyExamplesCompanion(')
          ..write('id: $id, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('sentence: $sentence, ')
          ..write('translation: $translation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExercisesTable extends LocalExercises
    with TableInfo<$LocalExercisesTable, LocalExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    type,
    question,
    dataJson,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $LocalExercisesTable createAlias(String alias) {
    return $LocalExercisesTable(attachedDatabase, alias);
  }
}

class LocalExercise extends DataClass implements Insertable<LocalExercise> {
  final String id;
  final String lessonId;
  final String type;
  final String question;
  final String? dataJson;
  final int order;
  const LocalExercise({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.question,
    this.dataJson,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['type'] = Variable<String>(type);
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || dataJson != null) {
      map['data_json'] = Variable<String>(dataJson);
    }
    map['order'] = Variable<int>(order);
    return map;
  }

  LocalExercisesCompanion toCompanion(bool nullToAbsent) {
    return LocalExercisesCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      type: Value(type),
      question: Value(question),
      dataJson: dataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dataJson),
      order: Value(order),
    );
  }

  factory LocalExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExercise(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      type: serializer.fromJson<String>(json['type']),
      question: serializer.fromJson<String>(json['question']),
      dataJson: serializer.fromJson<String?>(json['dataJson']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'type': serializer.toJson<String>(type),
      'question': serializer.toJson<String>(question),
      'dataJson': serializer.toJson<String?>(dataJson),
      'order': serializer.toJson<int>(order),
    };
  }

  LocalExercise copyWith({
    String? id,
    String? lessonId,
    String? type,
    String? question,
    Value<String?> dataJson = const Value.absent(),
    int? order,
  }) => LocalExercise(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    type: type ?? this.type,
    question: question ?? this.question,
    dataJson: dataJson.present ? dataJson.value : this.dataJson,
    order: order ?? this.order,
  );
  LocalExercise copyWithCompanion(LocalExercisesCompanion data) {
    return LocalExercise(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      type: data.type.present ? data.type.value : this.type,
      question: data.question.present ? data.question.value : this.question,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExercise(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('type: $type, ')
          ..write('question: $question, ')
          ..write('dataJson: $dataJson, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lessonId, type, question, dataJson, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExercise &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.type == this.type &&
          other.question == this.question &&
          other.dataJson == this.dataJson &&
          other.order == this.order);
}

class LocalExercisesCompanion extends UpdateCompanion<LocalExercise> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> type;
  final Value<String> question;
  final Value<String?> dataJson;
  final Value<int> order;
  final Value<int> rowid;
  const LocalExercisesCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.type = const Value.absent(),
    this.question = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExercisesCompanion.insert({
    required String id,
    required String lessonId,
    required String type,
    required String question,
    this.dataJson = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lessonId = Value(lessonId),
       type = Value(type),
       question = Value(question);
  static Insertable<LocalExercise> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? type,
    Expression<String>? question,
    Expression<String>? dataJson,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (type != null) 'type': type,
      if (question != null) 'question': question,
      if (dataJson != null) 'data_json': dataJson,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? lessonId,
    Value<String>? type,
    Value<String>? question,
    Value<String?>? dataJson,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return LocalExercisesCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      type: type ?? this.type,
      question: question ?? this.question,
      dataJson: dataJson ?? this.dataJson,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExercisesCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('type: $type, ')
          ..write('question: $question, ')
          ..write('dataJson: $dataJson, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExerciseOptionsTable extends LocalExerciseOptions
    with TableInfo<$LocalExerciseOptionsTable, LocalExerciseOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExerciseOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, exerciseId, label, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_exercise_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExerciseOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalExerciseOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExerciseOption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $LocalExerciseOptionsTable createAlias(String alias) {
    return $LocalExerciseOptionsTable(attachedDatabase, alias);
  }
}

class LocalExerciseOption extends DataClass
    implements Insertable<LocalExerciseOption> {
  final String id;
  final String exerciseId;
  final String label;
  final int order;
  const LocalExerciseOption({
    required this.id,
    required this.exerciseId,
    required this.label,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['label'] = Variable<String>(label);
    map['order'] = Variable<int>(order);
    return map;
  }

  LocalExerciseOptionsCompanion toCompanion(bool nullToAbsent) {
    return LocalExerciseOptionsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      label: Value(label),
      order: Value(order),
    );
  }

  factory LocalExerciseOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExerciseOption(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      label: serializer.fromJson<String>(json['label']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'label': serializer.toJson<String>(label),
      'order': serializer.toJson<int>(order),
    };
  }

  LocalExerciseOption copyWith({
    String? id,
    String? exerciseId,
    String? label,
    int? order,
  }) => LocalExerciseOption(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    label: label ?? this.label,
    order: order ?? this.order,
  );
  LocalExerciseOption copyWithCompanion(LocalExerciseOptionsCompanion data) {
    return LocalExerciseOption(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      label: data.label.present ? data.label.value : this.label,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExerciseOption(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('label: $label, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, label, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExerciseOption &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.label == this.label &&
          other.order == this.order);
}

class LocalExerciseOptionsCompanion
    extends UpdateCompanion<LocalExerciseOption> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<String> label;
  final Value<int> order;
  final Value<int> rowid;
  const LocalExerciseOptionsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.label = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExerciseOptionsCompanion.insert({
    required String id,
    required String exerciseId,
    required String label,
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       exerciseId = Value(exerciseId),
       label = Value(label);
  static Insertable<LocalExerciseOption> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<String>? label,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (label != null) 'label': label,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExerciseOptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? exerciseId,
    Value<String>? label,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return LocalExerciseOptionsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      label: label ?? this.label,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExerciseOptionsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('label: $label, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserProfileTable extends LocalUserProfile
    with TableInfo<$LocalUserProfileTable, LocalUserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailVerifiedMeta = const VerificationMeta(
    'emailVerified',
  );
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
    'email_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nativeLanguageIdMeta = const VerificationMeta(
    'nativeLanguageId',
  );
  @override
  late final GeneratedColumn<String> nativeLanguageId = GeneratedColumn<String>(
    'native_language_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userLevelMeta = const VerificationMeta(
    'userLevel',
  );
  @override
  late final GeneratedColumn<int> userLevel = GeneratedColumn<int>(
    'user_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    firstName,
    lastName,
    role,
    emailVerified,
    nativeLanguageId,
    xp,
    userLevel,
    serverUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('email_verified')) {
      context.handle(
        _emailVerifiedMeta,
        emailVerified.isAcceptableOrUnknown(
          data['email_verified']!,
          _emailVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('native_language_id')) {
      context.handle(
        _nativeLanguageIdMeta,
        nativeLanguageId.isAcceptableOrUnknown(
          data['native_language_id']!,
          _nativeLanguageIdMeta,
        ),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('user_level')) {
      context.handle(
        _userLevelMeta,
        userLevel.isAcceptableOrUnknown(data['user_level']!, _userLevelMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      emailVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_verified'],
      )!,
      nativeLanguageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}native_language_id'],
      ),
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      userLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_level'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
    );
  }

  @override
  $LocalUserProfileTable createAlias(String alias) {
    return $LocalUserProfileTable(attachedDatabase, alias);
  }
}

class LocalUserProfileData extends DataClass
    implements Insertable<LocalUserProfileData> {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool emailVerified;
  final String? nativeLanguageId;
  final int xp;
  final int userLevel;
  final DateTime serverUpdatedAt;
  const LocalUserProfileData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.emailVerified,
    this.nativeLanguageId,
    required this.xp,
    required this.userLevel,
    required this.serverUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['role'] = Variable<String>(role);
    map['email_verified'] = Variable<bool>(emailVerified);
    if (!nullToAbsent || nativeLanguageId != null) {
      map['native_language_id'] = Variable<String>(nativeLanguageId);
    }
    map['xp'] = Variable<int>(xp);
    map['user_level'] = Variable<int>(userLevel);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    return map;
  }

  LocalUserProfileCompanion toCompanion(bool nullToAbsent) {
    return LocalUserProfileCompanion(
      id: Value(id),
      email: Value(email),
      firstName: Value(firstName),
      lastName: Value(lastName),
      role: Value(role),
      emailVerified: Value(emailVerified),
      nativeLanguageId: nativeLanguageId == null && nullToAbsent
          ? const Value.absent()
          : Value(nativeLanguageId),
      xp: Value(xp),
      userLevel: Value(userLevel),
      serverUpdatedAt: Value(serverUpdatedAt),
    );
  }

  factory LocalUserProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserProfileData(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      role: serializer.fromJson<String>(json['role']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
      nativeLanguageId: serializer.fromJson<String?>(json['nativeLanguageId']),
      xp: serializer.fromJson<int>(json['xp']),
      userLevel: serializer.fromJson<int>(json['userLevel']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'role': serializer.toJson<String>(role),
      'emailVerified': serializer.toJson<bool>(emailVerified),
      'nativeLanguageId': serializer.toJson<String?>(nativeLanguageId),
      'xp': serializer.toJson<int>(xp),
      'userLevel': serializer.toJson<int>(userLevel),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
    };
  }

  LocalUserProfileData copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    bool? emailVerified,
    Value<String?> nativeLanguageId = const Value.absent(),
    int? xp,
    int? userLevel,
    DateTime? serverUpdatedAt,
  }) => LocalUserProfileData(
    id: id ?? this.id,
    email: email ?? this.email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    role: role ?? this.role,
    emailVerified: emailVerified ?? this.emailVerified,
    nativeLanguageId: nativeLanguageId.present
        ? nativeLanguageId.value
        : this.nativeLanguageId,
    xp: xp ?? this.xp,
    userLevel: userLevel ?? this.userLevel,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
  );
  LocalUserProfileData copyWithCompanion(LocalUserProfileCompanion data) {
    return LocalUserProfileData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      role: data.role.present ? data.role.value : this.role,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
      nativeLanguageId: data.nativeLanguageId.present
          ? data.nativeLanguageId.value
          : this.nativeLanguageId,
      xp: data.xp.present ? data.xp.value : this.xp,
      userLevel: data.userLevel.present ? data.userLevel.value : this.userLevel,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfileData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('role: $role, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('nativeLanguageId: $nativeLanguageId, ')
          ..write('xp: $xp, ')
          ..write('userLevel: $userLevel, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    firstName,
    lastName,
    role,
    emailVerified,
    nativeLanguageId,
    xp,
    userLevel,
    serverUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserProfileData &&
          other.id == this.id &&
          other.email == this.email &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.role == this.role &&
          other.emailVerified == this.emailVerified &&
          other.nativeLanguageId == this.nativeLanguageId &&
          other.xp == this.xp &&
          other.userLevel == this.userLevel &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class LocalUserProfileCompanion extends UpdateCompanion<LocalUserProfileData> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> role;
  final Value<bool> emailVerified;
  final Value<String?> nativeLanguageId;
  final Value<int> xp;
  final Value<int> userLevel;
  final Value<DateTime> serverUpdatedAt;
  final Value<int> rowid;
  const LocalUserProfileCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.role = const Value.absent(),
    this.emailVerified = const Value.absent(),
    this.nativeLanguageId = const Value.absent(),
    this.xp = const Value.absent(),
    this.userLevel = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserProfileCompanion.insert({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
    this.emailVerified = const Value.absent(),
    this.nativeLanguageId = const Value.absent(),
    this.xp = const Value.absent(),
    this.userLevel = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       firstName = Value(firstName),
       lastName = Value(lastName),
       role = Value(role),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalUserProfileData> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? role,
    Expression<bool>? emailVerified,
    Expression<String>? nativeLanguageId,
    Expression<int>? xp,
    Expression<int>? userLevel,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (role != null) 'role': role,
      if (emailVerified != null) 'email_verified': emailVerified,
      if (nativeLanguageId != null) 'native_language_id': nativeLanguageId,
      if (xp != null) 'xp': xp,
      if (userLevel != null) 'user_level': userLevel,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserProfileCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? role,
    Value<bool>? emailVerified,
    Value<String?>? nativeLanguageId,
    Value<int>? xp,
    Value<int>? userLevel,
    Value<DateTime>? serverUpdatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserProfileCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      emailVerified: emailVerified ?? this.emailVerified,
      nativeLanguageId: nativeLanguageId ?? this.nativeLanguageId,
      xp: xp ?? this.xp,
      userLevel: userLevel ?? this.userLevel,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    if (nativeLanguageId.present) {
      map['native_language_id'] = Variable<String>(nativeLanguageId.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (userLevel.present) {
      map['user_level'] = Variable<int>(userLevel.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProfileCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('role: $role, ')
          ..write('emailVerified: $emailVerified, ')
          ..write('nativeLanguageId: $nativeLanguageId, ')
          ..write('xp: $xp, ')
          ..write('userLevel: $userLevel, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserLanguagesTable extends LocalUserLanguages
    with TableInfo<$LocalUserLanguagesTable, LocalUserLanguage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserLanguagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageIdMeta = const VerificationMeta(
    'languageId',
  );
  @override
  late final GeneratedColumn<String> languageId = GeneratedColumn<String>(
    'language_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _progressPercentMeta = const VerificationMeta(
    'progressPercent',
  );
  @override
  late final GeneratedColumn<double> progressPercent = GeneratedColumn<double>(
    'progress_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    languageId,
    levelId,
    isActive,
    progressPercent,
    startedAt,
    serverUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_languages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserLanguage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('language_id')) {
      context.handle(
        _languageIdMeta,
        languageId.isAcceptableOrUnknown(data['language_id']!, _languageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_languageIdMeta);
    }
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('progress_percent')) {
      context.handle(
        _progressPercentMeta,
        progressPercent.isAcceptableOrUnknown(
          data['progress_percent']!,
          _progressPercentMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserLanguage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserLanguage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      languageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_id'],
      )!,
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      progressPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress_percent'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalUserLanguagesTable createAlias(String alias) {
    return $LocalUserLanguagesTable(attachedDatabase, alias);
  }
}

class LocalUserLanguage extends DataClass
    implements Insertable<LocalUserLanguage> {
  final String id;
  final String userId;
  final String languageId;
  final String? levelId;
  final bool isActive;
  final double progressPercent;
  final DateTime startedAt;
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  const LocalUserLanguage({
    required this.id,
    required this.userId,
    required this.languageId,
    this.levelId,
    required this.isActive,
    required this.progressPercent,
    required this.startedAt,
    required this.serverUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['language_id'] = Variable<String>(languageId);
    if (!nullToAbsent || levelId != null) {
      map['level_id'] = Variable<String>(levelId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['progress_percent'] = Variable<double>(progressPercent);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalUserLanguagesCompanion toCompanion(bool nullToAbsent) {
    return LocalUserLanguagesCompanion(
      id: Value(id),
      userId: Value(userId),
      languageId: Value(languageId),
      levelId: levelId == null && nullToAbsent
          ? const Value.absent()
          : Value(levelId),
      isActive: Value(isActive),
      progressPercent: Value(progressPercent),
      startedAt: Value(startedAt),
      serverUpdatedAt: Value(serverUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalUserLanguage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserLanguage(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      languageId: serializer.fromJson<String>(json['languageId']),
      levelId: serializer.fromJson<String?>(json['levelId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      progressPercent: serializer.fromJson<double>(json['progressPercent']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'languageId': serializer.toJson<String>(languageId),
      'levelId': serializer.toJson<String?>(levelId),
      'isActive': serializer.toJson<bool>(isActive),
      'progressPercent': serializer.toJson<double>(progressPercent),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalUserLanguage copyWith({
    String? id,
    String? userId,
    String? languageId,
    Value<String?> levelId = const Value.absent(),
    bool? isActive,
    double? progressPercent,
    DateTime? startedAt,
    DateTime? serverUpdatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalUserLanguage(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    languageId: languageId ?? this.languageId,
    levelId: levelId.present ? levelId.value : this.levelId,
    isActive: isActive ?? this.isActive,
    progressPercent: progressPercent ?? this.progressPercent,
    startedAt: startedAt ?? this.startedAt,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalUserLanguage copyWithCompanion(LocalUserLanguagesCompanion data) {
    return LocalUserLanguage(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      languageId: data.languageId.present
          ? data.languageId.value
          : this.languageId,
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      progressPercent: data.progressPercent.present
          ? data.progressPercent.value
          : this.progressPercent,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserLanguage(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('languageId: $languageId, ')
          ..write('levelId: $levelId, ')
          ..write('isActive: $isActive, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('startedAt: $startedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    languageId,
    levelId,
    isActive,
    progressPercent,
    startedAt,
    serverUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserLanguage &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.languageId == this.languageId &&
          other.levelId == this.levelId &&
          other.isActive == this.isActive &&
          other.progressPercent == this.progressPercent &&
          other.startedAt == this.startedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalUserLanguagesCompanion extends UpdateCompanion<LocalUserLanguage> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> languageId;
  final Value<String?> levelId;
  final Value<bool> isActive;
  final Value<double> progressPercent;
  final Value<DateTime> startedAt;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalUserLanguagesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.languageId = const Value.absent(),
    this.levelId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.progressPercent = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserLanguagesCompanion.insert({
    required String id,
    required String userId,
    required String languageId,
    this.levelId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.progressPercent = const Value.absent(),
    required DateTime startedAt,
    required DateTime serverUpdatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       languageId = Value(languageId),
       startedAt = Value(startedAt),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalUserLanguage> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? languageId,
    Expression<String>? levelId,
    Expression<bool>? isActive,
    Expression<double>? progressPercent,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (languageId != null) 'language_id': languageId,
      if (levelId != null) 'level_id': levelId,
      if (isActive != null) 'is_active': isActive,
      if (progressPercent != null) 'progress_percent': progressPercent,
      if (startedAt != null) 'started_at': startedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserLanguagesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? languageId,
    Value<String?>? levelId,
    Value<bool>? isActive,
    Value<double>? progressPercent,
    Value<DateTime>? startedAt,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalUserLanguagesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      languageId: languageId ?? this.languageId,
      levelId: levelId ?? this.levelId,
      isActive: isActive ?? this.isActive,
      progressPercent: progressPercent ?? this.progressPercent,
      startedAt: startedAt ?? this.startedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (languageId.present) {
      map['language_id'] = Variable<String>(languageId.value);
    }
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (progressPercent.present) {
      map['progress_percent'] = Variable<double>(progressPercent.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserLanguagesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('languageId: $languageId, ')
          ..write('levelId: $levelId, ')
          ..write('isActive: $isActive, ')
          ..write('progressPercent: $progressPercent, ')
          ..write('startedAt: $startedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserProgressTable extends LocalUserProgress
    with TableInfo<$LocalUserProgressTable, LocalUserProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeSpentSecMeta = const VerificationMeta(
    'timeSpentSec',
  );
  @override
  late final GeneratedColumn<int> timeSpentSec = GeneratedColumn<int>(
    'time_spent_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    lessonId,
    status,
    score,
    timeSpentSec,
    completedAt,
    serverUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('time_spent_sec')) {
      context.handle(
        _timeSpentSecMeta,
        timeSpentSec.isAcceptableOrUnknown(
          data['time_spent_sec']!,
          _timeSpentSecMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      timeSpentSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent_sec'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
    );
  }

  @override
  $LocalUserProgressTable createAlias(String alias) {
    return $LocalUserProgressTable(attachedDatabase, alias);
  }
}

class LocalUserProgressData extends DataClass
    implements Insertable<LocalUserProgressData> {
  final String id;
  final String userId;
  final String lessonId;
  final String status;
  final int score;
  final int timeSpentSec;
  final DateTime? completedAt;
  final DateTime serverUpdatedAt;
  const LocalUserProgressData({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.status,
    required this.score,
    required this.timeSpentSec,
    this.completedAt,
    required this.serverUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['status'] = Variable<String>(status);
    map['score'] = Variable<int>(score);
    map['time_spent_sec'] = Variable<int>(timeSpentSec);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    return map;
  }

  LocalUserProgressCompanion toCompanion(bool nullToAbsent) {
    return LocalUserProgressCompanion(
      id: Value(id),
      userId: Value(userId),
      lessonId: Value(lessonId),
      status: Value(status),
      score: Value(score),
      timeSpentSec: Value(timeSpentSec),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      serverUpdatedAt: Value(serverUpdatedAt),
    );
  }

  factory LocalUserProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserProgressData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      status: serializer.fromJson<String>(json['status']),
      score: serializer.fromJson<int>(json['score']),
      timeSpentSec: serializer.fromJson<int>(json['timeSpentSec']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'lessonId': serializer.toJson<String>(lessonId),
      'status': serializer.toJson<String>(status),
      'score': serializer.toJson<int>(score),
      'timeSpentSec': serializer.toJson<int>(timeSpentSec),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
    };
  }

  LocalUserProgressData copyWith({
    String? id,
    String? userId,
    String? lessonId,
    String? status,
    int? score,
    int? timeSpentSec,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? serverUpdatedAt,
  }) => LocalUserProgressData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    lessonId: lessonId ?? this.lessonId,
    status: status ?? this.status,
    score: score ?? this.score,
    timeSpentSec: timeSpentSec ?? this.timeSpentSec,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
  );
  LocalUserProgressData copyWithCompanion(LocalUserProgressCompanion data) {
    return LocalUserProgressData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      status: data.status.present ? data.status.value : this.status,
      score: data.score.present ? data.score.value : this.score,
      timeSpentSec: data.timeSpentSec.present
          ? data.timeSpentSec.value
          : this.timeSpentSec,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProgressData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('timeSpentSec: $timeSpentSec, ')
          ..write('completedAt: $completedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    lessonId,
    status,
    score,
    timeSpentSec,
    completedAt,
    serverUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserProgressData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.lessonId == this.lessonId &&
          other.status == this.status &&
          other.score == this.score &&
          other.timeSpentSec == this.timeSpentSec &&
          other.completedAt == this.completedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class LocalUserProgressCompanion
    extends UpdateCompanion<LocalUserProgressData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> lessonId;
  final Value<String> status;
  final Value<int> score;
  final Value<int> timeSpentSec;
  final Value<DateTime?> completedAt;
  final Value<DateTime> serverUpdatedAt;
  final Value<int> rowid;
  const LocalUserProgressCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.timeSpentSec = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserProgressCompanion.insert({
    required String id,
    required String userId,
    required String lessonId,
    required String status,
    this.score = const Value.absent(),
    this.timeSpentSec = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       lessonId = Value(lessonId),
       status = Value(status),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalUserProgressData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? lessonId,
    Expression<String>? status,
    Expression<int>? score,
    Expression<int>? timeSpentSec,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (timeSpentSec != null) 'time_spent_sec': timeSpentSec,
      if (completedAt != null) 'completed_at': completedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? lessonId,
    Value<String>? status,
    Value<int>? score,
    Value<int>? timeSpentSec,
    Value<DateTime?>? completedAt,
    Value<DateTime>? serverUpdatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserProgressCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      score: score ?? this.score,
      timeSpentSec: timeSpentSec ?? this.timeSpentSec,
      completedAt: completedAt ?? this.completedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (timeSpentSec.present) {
      map['time_spent_sec'] = Variable<int>(timeSpentSec.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserProgressCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('timeSpentSec: $timeSpentSec, ')
          ..write('completedAt: $completedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserVocabularyTable extends LocalUserVocabulary
    with TableInfo<$LocalUserVocabularyTable, LocalUserVocabularyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserVocabularyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vocabularyIdMeta = const VerificationMeta(
    'vocabularyId',
  );
  @override
  late final GeneratedColumn<String> vocabularyId = GeneratedColumn<String>(
    'vocabulary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _successRateMeta = const VerificationMeta(
    'successRate',
  );
  @override
  late final GeneratedColumn<double> successRate = GeneratedColumn<double>(
    'success_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextReviewAtMeta = const VerificationMeta(
    'nextReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
    'next_review_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    vocabularyId,
    state,
    isFavorite,
    repetitions,
    intervalDays,
    easeFactor,
    successRate,
    difficulty,
    nextReviewAt,
    lastReviewedAt,
    serverUpdatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_vocabulary';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserVocabularyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('vocabulary_id')) {
      context.handle(
        _vocabularyIdMeta,
        vocabularyId.isAcceptableOrUnknown(
          data['vocabulary_id']!,
          _vocabularyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabularyIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('success_rate')) {
      context.handle(
        _successRateMeta,
        successRate.isAcceptableOrUnknown(
          data['success_rate']!,
          _successRateMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
        _nextReviewAtMeta,
        nextReviewAt.isAcceptableOrUnknown(
          data['next_review_at']!,
          _nextReviewAtMeta,
        ),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserVocabularyData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserVocabularyData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      vocabularyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vocabulary_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      successRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}success_rate'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      )!,
      nextReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_at'],
      ),
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $LocalUserVocabularyTable createAlias(String alias) {
    return $LocalUserVocabularyTable(attachedDatabase, alias);
  }
}

class LocalUserVocabularyData extends DataClass
    implements Insertable<LocalUserVocabularyData> {
  final String id;
  final String userId;
  final String vocabularyId;
  final String state;
  final bool isFavorite;
  final int repetitions;
  final int intervalDays;
  final double easeFactor;
  final double successRate;
  final double difficulty;
  final DateTime? nextReviewAt;
  final DateTime? lastReviewedAt;
  final DateTime serverUpdatedAt;
  final DateTime? deletedAt;
  const LocalUserVocabularyData({
    required this.id,
    required this.userId,
    required this.vocabularyId,
    required this.state,
    required this.isFavorite,
    required this.repetitions,
    required this.intervalDays,
    required this.easeFactor,
    required this.successRate,
    required this.difficulty,
    this.nextReviewAt,
    this.lastReviewedAt,
    required this.serverUpdatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['vocabulary_id'] = Variable<String>(vocabularyId);
    map['state'] = Variable<String>(state);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['repetitions'] = Variable<int>(repetitions);
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['success_rate'] = Variable<double>(successRate);
    map['difficulty'] = Variable<double>(difficulty);
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  LocalUserVocabularyCompanion toCompanion(bool nullToAbsent) {
    return LocalUserVocabularyCompanion(
      id: Value(id),
      userId: Value(userId),
      vocabularyId: Value(vocabularyId),
      state: Value(state),
      isFavorite: Value(isFavorite),
      repetitions: Value(repetitions),
      intervalDays: Value(intervalDays),
      easeFactor: Value(easeFactor),
      successRate: Value(successRate),
      difficulty: Value(difficulty),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      serverUpdatedAt: Value(serverUpdatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory LocalUserVocabularyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserVocabularyData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      vocabularyId: serializer.fromJson<String>(json['vocabularyId']),
      state: serializer.fromJson<String>(json['state']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      successRate: serializer.fromJson<double>(json['successRate']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'vocabularyId': serializer.toJson<String>(vocabularyId),
      'state': serializer.toJson<String>(state),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'repetitions': serializer.toJson<int>(repetitions),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'successRate': serializer.toJson<double>(successRate),
      'difficulty': serializer.toJson<double>(difficulty),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  LocalUserVocabularyData copyWith({
    String? id,
    String? userId,
    String? vocabularyId,
    String? state,
    bool? isFavorite,
    int? repetitions,
    int? intervalDays,
    double? easeFactor,
    double? successRate,
    double? difficulty,
    Value<DateTime?> nextReviewAt = const Value.absent(),
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    DateTime? serverUpdatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => LocalUserVocabularyData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    vocabularyId: vocabularyId ?? this.vocabularyId,
    state: state ?? this.state,
    isFavorite: isFavorite ?? this.isFavorite,
    repetitions: repetitions ?? this.repetitions,
    intervalDays: intervalDays ?? this.intervalDays,
    easeFactor: easeFactor ?? this.easeFactor,
    successRate: successRate ?? this.successRate,
    difficulty: difficulty ?? this.difficulty,
    nextReviewAt: nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  LocalUserVocabularyData copyWithCompanion(LocalUserVocabularyCompanion data) {
    return LocalUserVocabularyData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      vocabularyId: data.vocabularyId.present
          ? data.vocabularyId.value
          : this.vocabularyId,
      state: data.state.present ? data.state.value : this.state,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      successRate: data.successRate.present
          ? data.successRate.value
          : this.successRate,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserVocabularyData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('state: $state, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('repetitions: $repetitions, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('successRate: $successRate, ')
          ..write('difficulty: $difficulty, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    vocabularyId,
    state,
    isFavorite,
    repetitions,
    intervalDays,
    easeFactor,
    successRate,
    difficulty,
    nextReviewAt,
    lastReviewedAt,
    serverUpdatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserVocabularyData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.vocabularyId == this.vocabularyId &&
          other.state == this.state &&
          other.isFavorite == this.isFavorite &&
          other.repetitions == this.repetitions &&
          other.intervalDays == this.intervalDays &&
          other.easeFactor == this.easeFactor &&
          other.successRate == this.successRate &&
          other.difficulty == this.difficulty &&
          other.nextReviewAt == this.nextReviewAt &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.deletedAt == this.deletedAt);
}

class LocalUserVocabularyCompanion
    extends UpdateCompanion<LocalUserVocabularyData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> vocabularyId;
  final Value<String> state;
  final Value<bool> isFavorite;
  final Value<int> repetitions;
  final Value<int> intervalDays;
  final Value<double> easeFactor;
  final Value<double> successRate;
  final Value<double> difficulty;
  final Value<DateTime?> nextReviewAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime> serverUpdatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const LocalUserVocabularyCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.vocabularyId = const Value.absent(),
    this.state = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.successRate = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserVocabularyCompanion.insert({
    required String id,
    required String userId,
    required String vocabularyId,
    required String state,
    this.isFavorite = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.successRate = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       vocabularyId = Value(vocabularyId),
       state = Value(state),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalUserVocabularyData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? vocabularyId,
    Expression<String>? state,
    Expression<bool>? isFavorite,
    Expression<int>? repetitions,
    Expression<int>? intervalDays,
    Expression<double>? easeFactor,
    Expression<double>? successRate,
    Expression<double>? difficulty,
    Expression<DateTime>? nextReviewAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (vocabularyId != null) 'vocabulary_id': vocabularyId,
      if (state != null) 'state': state,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (repetitions != null) 'repetitions': repetitions,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (successRate != null) 'success_rate': successRate,
      if (difficulty != null) 'difficulty': difficulty,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserVocabularyCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? vocabularyId,
    Value<String>? state,
    Value<bool>? isFavorite,
    Value<int>? repetitions,
    Value<int>? intervalDays,
    Value<double>? easeFactor,
    Value<double>? successRate,
    Value<double>? difficulty,
    Value<DateTime?>? nextReviewAt,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime>? serverUpdatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return LocalUserVocabularyCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      state: state ?? this.state,
      isFavorite: isFavorite ?? this.isFavorite,
      repetitions: repetitions ?? this.repetitions,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      successRate: successRate ?? this.successRate,
      difficulty: difficulty ?? this.difficulty,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (vocabularyId.present) {
      map['vocabulary_id'] = Variable<String>(vocabularyId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (successRate.present) {
      map['success_rate'] = Variable<double>(successRate.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserVocabularyCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('vocabularyId: $vocabularyId, ')
          ..write('state: $state, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('repetitions: $repetitions, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('successRate: $successRate, ')
          ..write('difficulty: $difficulty, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDailyGoalsTable extends LocalDailyGoals
    with TableInfo<$LocalDailyGoalsTable, LocalDailyGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDailyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    target,
    isActive,
    serverUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_daily_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDailyGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDailyGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDailyGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
    );
  }

  @override
  $LocalDailyGoalsTable createAlias(String alias) {
    return $LocalDailyGoalsTable(attachedDatabase, alias);
  }
}

class LocalDailyGoal extends DataClass implements Insertable<LocalDailyGoal> {
  final String id;
  final String userId;
  final String type;
  final int target;
  final bool isActive;
  final DateTime serverUpdatedAt;
  const LocalDailyGoal({
    required this.id,
    required this.userId,
    required this.type,
    required this.target,
    required this.isActive,
    required this.serverUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['target'] = Variable<int>(target);
    map['is_active'] = Variable<bool>(isActive);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    return map;
  }

  LocalDailyGoalsCompanion toCompanion(bool nullToAbsent) {
    return LocalDailyGoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      target: Value(target),
      isActive: Value(isActive),
      serverUpdatedAt: Value(serverUpdatedAt),
    );
  }

  factory LocalDailyGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDailyGoal(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      target: serializer.fromJson<int>(json['target']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'target': serializer.toJson<int>(target),
      'isActive': serializer.toJson<bool>(isActive),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
    };
  }

  LocalDailyGoal copyWith({
    String? id,
    String? userId,
    String? type,
    int? target,
    bool? isActive,
    DateTime? serverUpdatedAt,
  }) => LocalDailyGoal(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    target: target ?? this.target,
    isActive: isActive ?? this.isActive,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
  );
  LocalDailyGoal copyWithCompanion(LocalDailyGoalsCompanion data) {
    return LocalDailyGoal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      target: data.target.present ? data.target.value : this.target,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDailyGoal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('isActive: $isActive, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, type, target, isActive, serverUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDailyGoal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.target == this.target &&
          other.isActive == this.isActive &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class LocalDailyGoalsCompanion extends UpdateCompanion<LocalDailyGoal> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> type;
  final Value<int> target;
  final Value<bool> isActive;
  final Value<DateTime> serverUpdatedAt;
  final Value<int> rowid;
  const LocalDailyGoalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.target = const Value.absent(),
    this.isActive = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDailyGoalsCompanion.insert({
    required String id,
    required String userId,
    required String type,
    required int target,
    this.isActive = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       type = Value(type),
       target = Value(target),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalDailyGoal> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<int>? target,
    Expression<bool>? isActive,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (target != null) 'target': target,
      if (isActive != null) 'is_active': isActive,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDailyGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? type,
    Value<int>? target,
    Value<bool>? isActive,
    Value<DateTime>? serverUpdatedAt,
    Value<int>? rowid,
  }) {
    return LocalDailyGoalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      target: target ?? this.target,
      isActive: isActive ?? this.isActive,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDailyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('isActive: $isActive, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStreaksTable extends LocalStreaks
    with TableInfo<$LocalStreaksTable, LocalStreak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalActiveDaysMeta = const VerificationMeta(
    'totalActiveDays',
  );
  @override
  late final GeneratedColumn<int> totalActiveDays = GeneratedColumn<int>(
    'total_active_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastActiveDateMeta = const VerificationMeta(
    'lastActiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastActiveDate =
      GeneratedColumn<DateTime>(
        'last_active_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    currentStreak,
    longestStreak,
    totalActiveDays,
    lastActiveDate,
    serverUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalStreak> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('total_active_days')) {
      context.handle(
        _totalActiveDaysMeta,
        totalActiveDays.isAcceptableOrUnknown(
          data['total_active_days']!,
          _totalActiveDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_active_date')) {
      context.handle(
        _lastActiveDateMeta,
        lastActiveDate.isAcceptableOrUnknown(
          data['last_active_date']!,
          _lastActiveDateMeta,
        ),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStreak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStreak(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      totalActiveDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_active_days'],
      )!,
      lastActiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_active_date'],
      ),
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
    );
  }

  @override
  $LocalStreaksTable createAlias(String alias) {
    return $LocalStreaksTable(attachedDatabase, alias);
  }
}

class LocalStreak extends DataClass implements Insertable<LocalStreak> {
  final String id;
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final int totalActiveDays;
  final DateTime? lastActiveDate;
  final DateTime serverUpdatedAt;
  const LocalStreak({
    required this.id,
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalActiveDays,
    this.lastActiveDate,
    required this.serverUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['total_active_days'] = Variable<int>(totalActiveDays);
    if (!nullToAbsent || lastActiveDate != null) {
      map['last_active_date'] = Variable<DateTime>(lastActiveDate);
    }
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    return map;
  }

  LocalStreaksCompanion toCompanion(bool nullToAbsent) {
    return LocalStreaksCompanion(
      id: Value(id),
      userId: Value(userId),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      totalActiveDays: Value(totalActiveDays),
      lastActiveDate: lastActiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActiveDate),
      serverUpdatedAt: Value(serverUpdatedAt),
    );
  }

  factory LocalStreak.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStreak(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      totalActiveDays: serializer.fromJson<int>(json['totalActiveDays']),
      lastActiveDate: serializer.fromJson<DateTime?>(json['lastActiveDate']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'totalActiveDays': serializer.toJson<int>(totalActiveDays),
      'lastActiveDate': serializer.toJson<DateTime?>(lastActiveDate),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
    };
  }

  LocalStreak copyWith({
    String? id,
    String? userId,
    int? currentStreak,
    int? longestStreak,
    int? totalActiveDays,
    Value<DateTime?> lastActiveDate = const Value.absent(),
    DateTime? serverUpdatedAt,
  }) => LocalStreak(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    totalActiveDays: totalActiveDays ?? this.totalActiveDays,
    lastActiveDate: lastActiveDate.present
        ? lastActiveDate.value
        : this.lastActiveDate,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
  );
  LocalStreak copyWithCompanion(LocalStreaksCompanion data) {
    return LocalStreak(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      totalActiveDays: data.totalActiveDays.present
          ? data.totalActiveDays.value
          : this.totalActiveDays,
      lastActiveDate: data.lastActiveDate.present
          ? data.lastActiveDate.value
          : this.lastActiveDate,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStreak(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalActiveDays: $totalActiveDays, ')
          ..write('lastActiveDate: $lastActiveDate, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    currentStreak,
    longestStreak,
    totalActiveDays,
    lastActiveDate,
    serverUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStreak &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.totalActiveDays == this.totalActiveDays &&
          other.lastActiveDate == this.lastActiveDate &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class LocalStreaksCompanion extends UpdateCompanion<LocalStreak> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<int> totalActiveDays;
  final Value<DateTime?> lastActiveDate;
  final Value<DateTime> serverUpdatedAt;
  final Value<int> rowid;
  const LocalStreaksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalActiveDays = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStreaksCompanion.insert({
    required String id,
    required String userId,
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalActiveDays = const Value.absent(),
    this.lastActiveDate = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalStreak> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<int>? totalActiveDays,
    Expression<DateTime>? lastActiveDate,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (totalActiveDays != null) 'total_active_days': totalActiveDays,
      if (lastActiveDate != null) 'last_active_date': lastActiveDate,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStreaksCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<int>? totalActiveDays,
    Value<DateTime?>? lastActiveDate,
    Value<DateTime>? serverUpdatedAt,
    Value<int>? rowid,
  }) {
    return LocalStreaksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalActiveDays: totalActiveDays ?? this.totalActiveDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (totalActiveDays.present) {
      map['total_active_days'] = Variable<int>(totalActiveDays.value);
    }
    if (lastActiveDate.present) {
      map['last_active_date'] = Variable<DateTime>(lastActiveDate.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStreaksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalActiveDays: $totalActiveDays, ')
          ..write('lastActiveDate: $lastActiveDate, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDailyActivitiesTable extends LocalDailyActivities
    with TableInfo<$LocalDailyActivitiesTable, LocalDailyActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDailyActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesLearnedMeta = const VerificationMeta(
    'minutesLearned',
  );
  @override
  late final GeneratedColumn<int> minutesLearned = GeneratedColumn<int>(
    'minutes_learned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wordsLearnedMeta = const VerificationMeta(
    'wordsLearned',
  );
  @override
  late final GeneratedColumn<int> wordsLearned = GeneratedColumn<int>(
    'words_learned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wordsReviewedMeta = const VerificationMeta(
    'wordsReviewed',
  );
  @override
  late final GeneratedColumn<int> wordsReviewed = GeneratedColumn<int>(
    'words_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exercisesDoneMeta = const VerificationMeta(
    'exercisesDone',
  );
  @override
  late final GeneratedColumn<int> exercisesDone = GeneratedColumn<int>(
    'exercises_done',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _exercisesCorrectMeta = const VerificationMeta(
    'exercisesCorrect',
  );
  @override
  late final GeneratedColumn<int> exercisesCorrect = GeneratedColumn<int>(
    'exercises_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _xpEarnedMeta = const VerificationMeta(
    'xpEarned',
  );
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
    'xp_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    date,
    minutesLearned,
    wordsLearned,
    wordsReviewed,
    exercisesDone,
    exercisesCorrect,
    xpEarned,
    serverUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_daily_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDailyActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('minutes_learned')) {
      context.handle(
        _minutesLearnedMeta,
        minutesLearned.isAcceptableOrUnknown(
          data['minutes_learned']!,
          _minutesLearnedMeta,
        ),
      );
    }
    if (data.containsKey('words_learned')) {
      context.handle(
        _wordsLearnedMeta,
        wordsLearned.isAcceptableOrUnknown(
          data['words_learned']!,
          _wordsLearnedMeta,
        ),
      );
    }
    if (data.containsKey('words_reviewed')) {
      context.handle(
        _wordsReviewedMeta,
        wordsReviewed.isAcceptableOrUnknown(
          data['words_reviewed']!,
          _wordsReviewedMeta,
        ),
      );
    }
    if (data.containsKey('exercises_done')) {
      context.handle(
        _exercisesDoneMeta,
        exercisesDone.isAcceptableOrUnknown(
          data['exercises_done']!,
          _exercisesDoneMeta,
        ),
      );
    }
    if (data.containsKey('exercises_correct')) {
      context.handle(
        _exercisesCorrectMeta,
        exercisesCorrect.isAcceptableOrUnknown(
          data['exercises_correct']!,
          _exercisesCorrectMeta,
        ),
      );
    }
    if (data.containsKey('xp_earned')) {
      context.handle(
        _xpEarnedMeta,
        xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta),
      );
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDailyActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDailyActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      minutesLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_learned'],
      )!,
      wordsLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}words_learned'],
      )!,
      wordsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}words_reviewed'],
      )!,
      exercisesDone: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercises_done'],
      )!,
      exercisesCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercises_correct'],
      )!,
      xpEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_earned'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      )!,
    );
  }

  @override
  $LocalDailyActivitiesTable createAlias(String alias) {
    return $LocalDailyActivitiesTable(attachedDatabase, alias);
  }
}

class LocalDailyActivity extends DataClass
    implements Insertable<LocalDailyActivity> {
  final String id;
  final String userId;
  final DateTime date;
  final int minutesLearned;
  final int wordsLearned;
  final int wordsReviewed;
  final int exercisesDone;
  final int exercisesCorrect;
  final int xpEarned;
  final DateTime serverUpdatedAt;
  const LocalDailyActivity({
    required this.id,
    required this.userId,
    required this.date,
    required this.minutesLearned,
    required this.wordsLearned,
    required this.wordsReviewed,
    required this.exercisesDone,
    required this.exercisesCorrect,
    required this.xpEarned,
    required this.serverUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['minutes_learned'] = Variable<int>(minutesLearned);
    map['words_learned'] = Variable<int>(wordsLearned);
    map['words_reviewed'] = Variable<int>(wordsReviewed);
    map['exercises_done'] = Variable<int>(exercisesDone);
    map['exercises_correct'] = Variable<int>(exercisesCorrect);
    map['xp_earned'] = Variable<int>(xpEarned);
    map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    return map;
  }

  LocalDailyActivitiesCompanion toCompanion(bool nullToAbsent) {
    return LocalDailyActivitiesCompanion(
      id: Value(id),
      userId: Value(userId),
      date: Value(date),
      minutesLearned: Value(minutesLearned),
      wordsLearned: Value(wordsLearned),
      wordsReviewed: Value(wordsReviewed),
      exercisesDone: Value(exercisesDone),
      exercisesCorrect: Value(exercisesCorrect),
      xpEarned: Value(xpEarned),
      serverUpdatedAt: Value(serverUpdatedAt),
    );
  }

  factory LocalDailyActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDailyActivity(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      minutesLearned: serializer.fromJson<int>(json['minutesLearned']),
      wordsLearned: serializer.fromJson<int>(json['wordsLearned']),
      wordsReviewed: serializer.fromJson<int>(json['wordsReviewed']),
      exercisesDone: serializer.fromJson<int>(json['exercisesDone']),
      exercisesCorrect: serializer.fromJson<int>(json['exercisesCorrect']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      serverUpdatedAt: serializer.fromJson<DateTime>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'minutesLearned': serializer.toJson<int>(minutesLearned),
      'wordsLearned': serializer.toJson<int>(wordsLearned),
      'wordsReviewed': serializer.toJson<int>(wordsReviewed),
      'exercisesDone': serializer.toJson<int>(exercisesDone),
      'exercisesCorrect': serializer.toJson<int>(exercisesCorrect),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'serverUpdatedAt': serializer.toJson<DateTime>(serverUpdatedAt),
    };
  }

  LocalDailyActivity copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? minutesLearned,
    int? wordsLearned,
    int? wordsReviewed,
    int? exercisesDone,
    int? exercisesCorrect,
    int? xpEarned,
    DateTime? serverUpdatedAt,
  }) => LocalDailyActivity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    date: date ?? this.date,
    minutesLearned: minutesLearned ?? this.minutesLearned,
    wordsLearned: wordsLearned ?? this.wordsLearned,
    wordsReviewed: wordsReviewed ?? this.wordsReviewed,
    exercisesDone: exercisesDone ?? this.exercisesDone,
    exercisesCorrect: exercisesCorrect ?? this.exercisesCorrect,
    xpEarned: xpEarned ?? this.xpEarned,
    serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
  );
  LocalDailyActivity copyWithCompanion(LocalDailyActivitiesCompanion data) {
    return LocalDailyActivity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      minutesLearned: data.minutesLearned.present
          ? data.minutesLearned.value
          : this.minutesLearned,
      wordsLearned: data.wordsLearned.present
          ? data.wordsLearned.value
          : this.wordsLearned,
      wordsReviewed: data.wordsReviewed.present
          ? data.wordsReviewed.value
          : this.wordsReviewed,
      exercisesDone: data.exercisesDone.present
          ? data.exercisesDone.value
          : this.exercisesDone,
      exercisesCorrect: data.exercisesCorrect.present
          ? data.exercisesCorrect.value
          : this.exercisesCorrect,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDailyActivity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('minutesLearned: $minutesLearned, ')
          ..write('wordsLearned: $wordsLearned, ')
          ..write('wordsReviewed: $wordsReviewed, ')
          ..write('exercisesDone: $exercisesDone, ')
          ..write('exercisesCorrect: $exercisesCorrect, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    date,
    minutesLearned,
    wordsLearned,
    wordsReviewed,
    exercisesDone,
    exercisesCorrect,
    xpEarned,
    serverUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDailyActivity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.minutesLearned == this.minutesLearned &&
          other.wordsLearned == this.wordsLearned &&
          other.wordsReviewed == this.wordsReviewed &&
          other.exercisesDone == this.exercisesDone &&
          other.exercisesCorrect == this.exercisesCorrect &&
          other.xpEarned == this.xpEarned &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class LocalDailyActivitiesCompanion
    extends UpdateCompanion<LocalDailyActivity> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<int> minutesLearned;
  final Value<int> wordsLearned;
  final Value<int> wordsReviewed;
  final Value<int> exercisesDone;
  final Value<int> exercisesCorrect;
  final Value<int> xpEarned;
  final Value<DateTime> serverUpdatedAt;
  final Value<int> rowid;
  const LocalDailyActivitiesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.minutesLearned = const Value.absent(),
    this.wordsLearned = const Value.absent(),
    this.wordsReviewed = const Value.absent(),
    this.exercisesDone = const Value.absent(),
    this.exercisesCorrect = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDailyActivitiesCompanion.insert({
    required String id,
    required String userId,
    required DateTime date,
    this.minutesLearned = const Value.absent(),
    this.wordsLearned = const Value.absent(),
    this.wordsReviewed = const Value.absent(),
    this.exercisesDone = const Value.absent(),
    this.exercisesCorrect = const Value.absent(),
    this.xpEarned = const Value.absent(),
    required DateTime serverUpdatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       date = Value(date),
       serverUpdatedAt = Value(serverUpdatedAt);
  static Insertable<LocalDailyActivity> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<int>? minutesLearned,
    Expression<int>? wordsLearned,
    Expression<int>? wordsReviewed,
    Expression<int>? exercisesDone,
    Expression<int>? exercisesCorrect,
    Expression<int>? xpEarned,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (minutesLearned != null) 'minutes_learned': minutesLearned,
      if (wordsLearned != null) 'words_learned': wordsLearned,
      if (wordsReviewed != null) 'words_reviewed': wordsReviewed,
      if (exercisesDone != null) 'exercises_done': exercisesDone,
      if (exercisesCorrect != null) 'exercises_correct': exercisesCorrect,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDailyActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<DateTime>? date,
    Value<int>? minutesLearned,
    Value<int>? wordsLearned,
    Value<int>? wordsReviewed,
    Value<int>? exercisesDone,
    Value<int>? exercisesCorrect,
    Value<int>? xpEarned,
    Value<DateTime>? serverUpdatedAt,
    Value<int>? rowid,
  }) {
    return LocalDailyActivitiesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      minutesLearned: minutesLearned ?? this.minutesLearned,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      wordsReviewed: wordsReviewed ?? this.wordsReviewed,
      exercisesDone: exercisesDone ?? this.exercisesDone,
      exercisesCorrect: exercisesCorrect ?? this.exercisesCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (minutesLearned.present) {
      map['minutes_learned'] = Variable<int>(minutesLearned.value);
    }
    if (wordsLearned.present) {
      map['words_learned'] = Variable<int>(wordsLearned.value);
    }
    if (wordsReviewed.present) {
      map['words_reviewed'] = Variable<int>(wordsReviewed.value);
    }
    if (exercisesDone.present) {
      map['exercises_done'] = Variable<int>(exercisesDone.value);
    }
    if (exercisesCorrect.present) {
      map['exercises_correct'] = Variable<int>(exercisesCorrect.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDailyActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('minutesLearned: $minutesLearned, ')
          ..write('wordsLearned: $wordsLearned, ')
          ..write('wordsReviewed: $wordsReviewed, ')
          ..write('exercisesDone: $exercisesDone, ')
          ..write('exercisesCorrect: $exercisesCorrect, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUserBadgesTable extends LocalUserBadges
    with TableInfo<$LocalUserBadgesTable, LocalUserBadge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserBadgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _badgeIdMeta = const VerificationMeta(
    'badgeId',
  );
  @override
  late final GeneratedColumn<String> badgeId = GeneratedColumn<String>(
    'badge_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, badgeId, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_badges';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserBadge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('badge_id')) {
      context.handle(
        _badgeIdMeta,
        badgeId.isAcceptableOrUnknown(data['badge_id']!, _badgeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_badgeIdMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserBadge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserBadge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      badgeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}badge_id'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $LocalUserBadgesTable createAlias(String alias) {
    return $LocalUserBadgesTable(attachedDatabase, alias);
  }
}

class LocalUserBadge extends DataClass implements Insertable<LocalUserBadge> {
  final String id;
  final String userId;
  final String badgeId;
  final DateTime earnedAt;
  const LocalUserBadge({
    required this.id,
    required this.userId,
    required this.badgeId,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['badge_id'] = Variable<String>(badgeId);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    return map;
  }

  LocalUserBadgesCompanion toCompanion(bool nullToAbsent) {
    return LocalUserBadgesCompanion(
      id: Value(id),
      userId: Value(userId),
      badgeId: Value(badgeId),
      earnedAt: Value(earnedAt),
    );
  }

  factory LocalUserBadge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserBadge(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      badgeId: serializer.fromJson<String>(json['badgeId']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'badgeId': serializer.toJson<String>(badgeId),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
    };
  }

  LocalUserBadge copyWith({
    String? id,
    String? userId,
    String? badgeId,
    DateTime? earnedAt,
  }) => LocalUserBadge(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    badgeId: badgeId ?? this.badgeId,
    earnedAt: earnedAt ?? this.earnedAt,
  );
  LocalUserBadge copyWithCompanion(LocalUserBadgesCompanion data) {
    return LocalUserBadge(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      badgeId: data.badgeId.present ? data.badgeId.value : this.badgeId,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserBadge(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('badgeId: $badgeId, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, badgeId, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserBadge &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.badgeId == this.badgeId &&
          other.earnedAt == this.earnedAt);
}

class LocalUserBadgesCompanion extends UpdateCompanion<LocalUserBadge> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> badgeId;
  final Value<DateTime> earnedAt;
  final Value<int> rowid;
  const LocalUserBadgesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.badgeId = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserBadgesCompanion.insert({
    required String id,
    required String userId,
    required String badgeId,
    required DateTime earnedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       badgeId = Value(badgeId),
       earnedAt = Value(earnedAt);
  static Insertable<LocalUserBadge> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? badgeId,
    Expression<DateTime>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (badgeId != null) 'badge_id': badgeId,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserBadgesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? badgeId,
    Value<DateTime>? earnedAt,
    Value<int>? rowid,
  }) {
    return LocalUserBadgesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      badgeId: badgeId ?? this.badgeId,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (badgeId.present) {
      map['badge_id'] = Variable<String>(badgeId.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserBadgesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('badgeId: $badgeId, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueEntriesTable extends SyncQueueEntries
    with TableInfo<$SyncQueueEntriesTable, SyncQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientTimestampMeta = const VerificationMeta(
    'clientTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> clientTimestamp =
      GeneratedColumn<DateTime>(
        'client_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    entityId,
    op,
    payloadJson,
    status,
    retryCount,
    errorMessage,
    clientTimestamp,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('client_timestamp')) {
      context.handle(
        _clientTimestampMeta,
        clientTimestamp.isAcceptableOrUnknown(
          data['client_timestamp']!,
          _clientTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientTimestampMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      clientTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_timestamp'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueEntriesTable createAlias(String alias) {
    return $SyncQueueEntriesTable(attachedDatabase, alias);
  }
}

class SyncQueueEntry extends DataClass implements Insertable<SyncQueueEntry> {
  final String id;
  final String entity;
  final String entityId;
  final String op;
  final String? payloadJson;
  final String status;
  final int retryCount;
  final String? errorMessage;
  final DateTime clientTimestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueEntry({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.op,
    this.payloadJson,
    required this.status,
    required this.retryCount,
    this.errorMessage,
    required this.clientTimestamp,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['op'] = Variable<String>(op);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['client_timestamp'] = Variable<DateTime>(clientTimestamp);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueEntriesCompanion(
      id: Value(id),
      entity: Value(entity),
      entityId: Value(entityId),
      op: Value(op),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      clientTimestamp: Value(clientTimestamp),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntry(
      id: serializer.fromJson<String>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      op: serializer.fromJson<String>(json['op']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      clientTimestamp: serializer.fromJson<DateTime>(json['clientTimestamp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'op': serializer.toJson<String>(op),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'clientTimestamp': serializer.toJson<DateTime>(clientTimestamp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueEntry copyWith({
    String? id,
    String? entity,
    String? entityId,
    String? op,
    Value<String?> payloadJson = const Value.absent(),
    String? status,
    int? retryCount,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? clientTimestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncQueueEntry(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    entityId: entityId ?? this.entityId,
    op: op ?? this.op,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    clientTimestamp: clientTimestamp ?? this.clientTimestamp,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueEntry copyWithCompanion(SyncQueueEntriesCompanion data) {
    return SyncQueueEntry(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      op: data.op.present ? data.op.value : this.op,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      clientTimestamp: data.clientTimestamp.present
          ? data.clientTimestamp.value
          : this.clientTimestamp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntry(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    entityId,
    op,
    payloadJson,
    status,
    retryCount,
    errorMessage,
    clientTimestamp,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntry &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.op == this.op &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage &&
          other.clientTimestamp == this.clientTimestamp &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueEntriesCompanion extends UpdateCompanion<SyncQueueEntry> {
  final Value<String> id;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> op;
  final Value<String?> payloadJson;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<DateTime> clientTimestamp;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueEntriesCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.op = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.clientTimestamp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueEntriesCompanion.insert({
    required String id,
    required String entity,
    required String entityId,
    required String op,
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime clientTimestamp,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entity = Value(entity),
       entityId = Value(entityId),
       op = Value(op),
       clientTimestamp = Value(clientTimestamp);
  static Insertable<SyncQueueEntry> custom({
    Expression<String>? id,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? op,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<DateTime>? clientTimestamp,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (op != null) 'op': op,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (clientTimestamp != null) 'client_timestamp': clientTimestamp,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? entity,
    Value<String>? entityId,
    Value<String>? op,
    Value<String?>? payloadJson,
    Value<String>? status,
    Value<int>? retryCount,
    Value<String?>? errorMessage,
    Value<DateTime>? clientTimestamp,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueEntriesCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      op: op ?? this.op,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      clientTimestamp: clientTimestamp ?? this.clientTimestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (clientTimestamp.present) {
      map['client_timestamp'] = Variable<DateTime>(clientTimestamp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalLanguagesTable localLanguages = $LocalLanguagesTable(this);
  late final $LocalLevelsTable localLevels = $LocalLevelsTable(this);
  late final $LocalCoursesTable localCourses = $LocalCoursesTable(this);
  late final $LocalModulesTable localModules = $LocalModulesTable(this);
  late final $LocalLessonsTable localLessons = $LocalLessonsTable(this);
  late final $LocalLessonContentsTable localLessonContents =
      $LocalLessonContentsTable(this);
  late final $LocalVocabularyTable localVocabulary = $LocalVocabularyTable(
    this,
  );
  late final $LocalVocabularyTranslationsTable localVocabularyTranslations =
      $LocalVocabularyTranslationsTable(this);
  late final $LocalVocabularyExamplesTable localVocabularyExamples =
      $LocalVocabularyExamplesTable(this);
  late final $LocalExercisesTable localExercises = $LocalExercisesTable(this);
  late final $LocalExerciseOptionsTable localExerciseOptions =
      $LocalExerciseOptionsTable(this);
  late final $LocalUserProfileTable localUserProfile = $LocalUserProfileTable(
    this,
  );
  late final $LocalUserLanguagesTable localUserLanguages =
      $LocalUserLanguagesTable(this);
  late final $LocalUserProgressTable localUserProgress =
      $LocalUserProgressTable(this);
  late final $LocalUserVocabularyTable localUserVocabulary =
      $LocalUserVocabularyTable(this);
  late final $LocalDailyGoalsTable localDailyGoals = $LocalDailyGoalsTable(
    this,
  );
  late final $LocalStreaksTable localStreaks = $LocalStreaksTable(this);
  late final $LocalDailyActivitiesTable localDailyActivities =
      $LocalDailyActivitiesTable(this);
  late final $LocalUserBadgesTable localUserBadges = $LocalUserBadgesTable(
    this,
  );
  late final $SyncQueueEntriesTable syncQueueEntries = $SyncQueueEntriesTable(
    this,
  );
  late final CatalogDao catalogDao = CatalogDao(this as AppDatabase);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final VocabularyDao vocabularyDao = VocabularyDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localLanguages,
    localLevels,
    localCourses,
    localModules,
    localLessons,
    localLessonContents,
    localVocabulary,
    localVocabularyTranslations,
    localVocabularyExamples,
    localExercises,
    localExerciseOptions,
    localUserProfile,
    localUserLanguages,
    localUserProgress,
    localUserVocabulary,
    localDailyGoals,
    localStreaks,
    localDailyActivities,
    localUserBadges,
    syncQueueEntries,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$LocalLanguagesTableCreateCompanionBuilder =
    LocalLanguagesCompanion Function({
      required String id,
      required String code,
      required String name,
      required String nativeName,
      Value<String?> flagEmoji,
      Value<bool> isActive,
      required DateTime serverUpdatedAt,
      Value<DateTime> syncedAt,
      Value<int> rowid,
    });
typedef $$LocalLanguagesTableUpdateCompanionBuilder =
    LocalLanguagesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String> nativeName,
      Value<String?> flagEmoji,
      Value<bool> isActive,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime> syncedAt,
      Value<int> rowid,
    });

class $$LocalLanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLanguagesTable> {
  $$LocalLanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nativeName => $composableBuilder(
    column: $table.nativeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flagEmoji => $composableBuilder(
    column: $table.flagEmoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLanguagesTable> {
  $$LocalLanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nativeName => $composableBuilder(
    column: $table.nativeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagEmoji => $composableBuilder(
    column: $table.flagEmoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLanguagesTable> {
  $$LocalLanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nativeName => $composableBuilder(
    column: $table.nativeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flagEmoji =>
      $composableBuilder(column: $table.flagEmoji, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LocalLanguagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLanguagesTable,
          LocalLanguage,
          $$LocalLanguagesTableFilterComposer,
          $$LocalLanguagesTableOrderingComposer,
          $$LocalLanguagesTableAnnotationComposer,
          $$LocalLanguagesTableCreateCompanionBuilder,
          $$LocalLanguagesTableUpdateCompanionBuilder,
          (
            LocalLanguage,
            BaseReferences<_$AppDatabase, $LocalLanguagesTable, LocalLanguage>,
          ),
          LocalLanguage,
          PrefetchHooks Function()
        > {
  $$LocalLanguagesTableTableManager(
    _$AppDatabase db,
    $LocalLanguagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalLanguagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nativeName = const Value.absent(),
                Value<String?> flagEmoji = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLanguagesCompanion(
                id: id,
                code: code,
                name: name,
                nativeName: nativeName,
                flagEmoji: flagEmoji,
                isActive: isActive,
                serverUpdatedAt: serverUpdatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required String nativeName,
                Value<String?> flagEmoji = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<DateTime> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLanguagesCompanion.insert(
                id: id,
                code: code,
                name: name,
                nativeName: nativeName,
                flagEmoji: flagEmoji,
                isActive: isActive,
                serverUpdatedAt: serverUpdatedAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLanguagesTable,
      LocalLanguage,
      $$LocalLanguagesTableFilterComposer,
      $$LocalLanguagesTableOrderingComposer,
      $$LocalLanguagesTableAnnotationComposer,
      $$LocalLanguagesTableCreateCompanionBuilder,
      $$LocalLanguagesTableUpdateCompanionBuilder,
      (
        LocalLanguage,
        BaseReferences<_$AppDatabase, $LocalLanguagesTable, LocalLanguage>,
      ),
      LocalLanguage,
      PrefetchHooks Function()
    >;
typedef $$LocalLevelsTableCreateCompanionBuilder =
    LocalLevelsCompanion Function({
      required String id,
      required String code,
      required String name,
      Value<String?> description,
      required int order,
      required DateTime serverUpdatedAt,
      Value<int> rowid,
    });
typedef $$LocalLevelsTableUpdateCompanionBuilder =
    LocalLevelsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String?> description,
      Value<int> order,
      Value<DateTime> serverUpdatedAt,
      Value<int> rowid,
    });

class $$LocalLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLevelsTable> {
  $$LocalLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLevelsTable> {
  $$LocalLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLevelsTable> {
  $$LocalLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );
}

class $$LocalLevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLevelsTable,
          LocalLevel,
          $$LocalLevelsTableFilterComposer,
          $$LocalLevelsTableOrderingComposer,
          $$LocalLevelsTableAnnotationComposer,
          $$LocalLevelsTableCreateCompanionBuilder,
          $$LocalLevelsTableUpdateCompanionBuilder,
          (
            LocalLevel,
            BaseReferences<_$AppDatabase, $LocalLevelsTable, LocalLevel>,
          ),
          LocalLevel,
          PrefetchHooks Function()
        > {
  $$LocalLevelsTableTableManager(_$AppDatabase db, $LocalLevelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLevelsCompanion(
                id: id,
                code: code,
                name: name,
                description: description,
                order: order,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                Value<String?> description = const Value.absent(),
                required int order,
                required DateTime serverUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalLevelsCompanion.insert(
                id: id,
                code: code,
                name: name,
                description: description,
                order: order,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLevelsTable,
      LocalLevel,
      $$LocalLevelsTableFilterComposer,
      $$LocalLevelsTableOrderingComposer,
      $$LocalLevelsTableAnnotationComposer,
      $$LocalLevelsTableCreateCompanionBuilder,
      $$LocalLevelsTableUpdateCompanionBuilder,
      (
        LocalLevel,
        BaseReferences<_$AppDatabase, $LocalLevelsTable, LocalLevel>,
      ),
      LocalLevel,
      PrefetchHooks Function()
    >;
typedef $$LocalCoursesTableCreateCompanionBuilder =
    LocalCoursesCompanion Function({
      required String id,
      required String languageId,
      required String levelId,
      required String title,
      Value<String?> description,
      Value<int> order,
      Value<bool> isPublished,
      required DateTime serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalCoursesTableUpdateCompanionBuilder =
    LocalCoursesCompanion Function({
      Value<String> id,
      Value<String> languageId,
      Value<String> levelId,
      Value<String> title,
      Value<String?> description,
      Value<int> order,
      Value<bool> isPublished,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalCoursesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCoursesTable> {
  $$LocalCoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCoursesTable> {
  $$LocalCoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCoursesTable> {
  $$LocalCoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalCoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCoursesTable,
          LocalCourse,
          $$LocalCoursesTableFilterComposer,
          $$LocalCoursesTableOrderingComposer,
          $$LocalCoursesTableAnnotationComposer,
          $$LocalCoursesTableCreateCompanionBuilder,
          $$LocalCoursesTableUpdateCompanionBuilder,
          (
            LocalCourse,
            BaseReferences<_$AppDatabase, $LocalCoursesTable, LocalCourse>,
          ),
          LocalCourse,
          PrefetchHooks Function()
        > {
  $$LocalCoursesTableTableManager(_$AppDatabase db, $LocalCoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> languageId = const Value.absent(),
                Value<String> levelId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCoursesCompanion(
                id: id,
                languageId: languageId,
                levelId: levelId,
                title: title,
                description: description,
                order: order,
                isPublished: isPublished,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String languageId,
                required String levelId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCoursesCompanion.insert(
                id: id,
                languageId: languageId,
                levelId: levelId,
                title: title,
                description: description,
                order: order,
                isPublished: isPublished,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCoursesTable,
      LocalCourse,
      $$LocalCoursesTableFilterComposer,
      $$LocalCoursesTableOrderingComposer,
      $$LocalCoursesTableAnnotationComposer,
      $$LocalCoursesTableCreateCompanionBuilder,
      $$LocalCoursesTableUpdateCompanionBuilder,
      (
        LocalCourse,
        BaseReferences<_$AppDatabase, $LocalCoursesTable, LocalCourse>,
      ),
      LocalCourse,
      PrefetchHooks Function()
    >;
typedef $$LocalModulesTableCreateCompanionBuilder =
    LocalModulesCompanion Function({
      required String id,
      required String courseId,
      required String title,
      Value<String?> description,
      Value<int> order,
      required DateTime serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalModulesTableUpdateCompanionBuilder =
    LocalModulesCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> title,
      Value<String?> description,
      Value<int> order,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalModulesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalModulesTable> {
  $$LocalModulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalModulesTable> {
  $$LocalModulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalModulesTable> {
  $$LocalModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalModulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalModulesTable,
          LocalModule,
          $$LocalModulesTableFilterComposer,
          $$LocalModulesTableOrderingComposer,
          $$LocalModulesTableAnnotationComposer,
          $$LocalModulesTableCreateCompanionBuilder,
          $$LocalModulesTableUpdateCompanionBuilder,
          (
            LocalModule,
            BaseReferences<_$AppDatabase, $LocalModulesTable, LocalModule>,
          ),
          LocalModule,
          PrefetchHooks Function()
        > {
  $$LocalModulesTableTableManager(_$AppDatabase db, $LocalModulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalModulesCompanion(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                order: order,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalModulesCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                order: order,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalModulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalModulesTable,
      LocalModule,
      $$LocalModulesTableFilterComposer,
      $$LocalModulesTableOrderingComposer,
      $$LocalModulesTableAnnotationComposer,
      $$LocalModulesTableCreateCompanionBuilder,
      $$LocalModulesTableUpdateCompanionBuilder,
      (
        LocalModule,
        BaseReferences<_$AppDatabase, $LocalModulesTable, LocalModule>,
      ),
      LocalModule,
      PrefetchHooks Function()
    >;
typedef $$LocalLessonsTableCreateCompanionBuilder =
    LocalLessonsCompanion Function({
      required String id,
      required String moduleId,
      required String title,
      Value<String?> description,
      Value<int> order,
      Value<int> estimatedDuration,
      Value<bool> isPublished,
      required DateTime serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalLessonsTableUpdateCompanionBuilder =
    LocalLessonsCompanion Function({
      Value<String> id,
      Value<String> moduleId,
      Value<String> title,
      Value<String?> description,
      Value<int> order,
      Value<int> estimatedDuration,
      Value<bool> isPublished,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLessonsTable> {
  $$LocalLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedDuration => $composableBuilder(
    column: $table.estimatedDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLessonsTable> {
  $$LocalLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedDuration => $composableBuilder(
    column: $table.estimatedDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLessonsTable> {
  $$LocalLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get estimatedDuration => $composableBuilder(
    column: $table.estimatedDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLessonsTable,
          LocalLesson,
          $$LocalLessonsTableFilterComposer,
          $$LocalLessonsTableOrderingComposer,
          $$LocalLessonsTableAnnotationComposer,
          $$LocalLessonsTableCreateCompanionBuilder,
          $$LocalLessonsTableUpdateCompanionBuilder,
          (
            LocalLesson,
            BaseReferences<_$AppDatabase, $LocalLessonsTable, LocalLesson>,
          ),
          LocalLesson,
          PrefetchHooks Function()
        > {
  $$LocalLessonsTableTableManager(_$AppDatabase db, $LocalLessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> estimatedDuration = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLessonsCompanion(
                id: id,
                moduleId: moduleId,
                title: title,
                description: description,
                order: order,
                estimatedDuration: estimatedDuration,
                isPublished: isPublished,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String moduleId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> estimatedDuration = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLessonsCompanion.insert(
                id: id,
                moduleId: moduleId,
                title: title,
                description: description,
                order: order,
                estimatedDuration: estimatedDuration,
                isPublished: isPublished,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLessonsTable,
      LocalLesson,
      $$LocalLessonsTableFilterComposer,
      $$LocalLessonsTableOrderingComposer,
      $$LocalLessonsTableAnnotationComposer,
      $$LocalLessonsTableCreateCompanionBuilder,
      $$LocalLessonsTableUpdateCompanionBuilder,
      (
        LocalLesson,
        BaseReferences<_$AppDatabase, $LocalLessonsTable, LocalLesson>,
      ),
      LocalLesson,
      PrefetchHooks Function()
    >;
typedef $$LocalLessonContentsTableCreateCompanionBuilder =
    LocalLessonContentsCompanion Function({
      required String id,
      required String lessonId,
      required String type,
      required String content,
      Value<int> order,
      Value<int> rowid,
    });
typedef $$LocalLessonContentsTableUpdateCompanionBuilder =
    LocalLessonContentsCompanion Function({
      Value<String> id,
      Value<String> lessonId,
      Value<String> type,
      Value<String> content,
      Value<int> order,
      Value<int> rowid,
    });

class $$LocalLessonContentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLessonContentsTable> {
  $$LocalLessonContentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLessonContentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLessonContentsTable> {
  $$LocalLessonContentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLessonContentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLessonContentsTable> {
  $$LocalLessonContentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$LocalLessonContentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLessonContentsTable,
          LocalLessonContent,
          $$LocalLessonContentsTableFilterComposer,
          $$LocalLessonContentsTableOrderingComposer,
          $$LocalLessonContentsTableAnnotationComposer,
          $$LocalLessonContentsTableCreateCompanionBuilder,
          $$LocalLessonContentsTableUpdateCompanionBuilder,
          (
            LocalLessonContent,
            BaseReferences<
              _$AppDatabase,
              $LocalLessonContentsTable,
              LocalLessonContent
            >,
          ),
          LocalLessonContent,
          PrefetchHooks Function()
        > {
  $$LocalLessonContentsTableTableManager(
    _$AppDatabase db,
    $LocalLessonContentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLessonContentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLessonContentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLessonContentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLessonContentsCompanion(
                id: id,
                lessonId: lessonId,
                type: type,
                content: content,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lessonId,
                required String type,
                required String content,
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLessonContentsCompanion.insert(
                id: id,
                lessonId: lessonId,
                type: type,
                content: content,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLessonContentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLessonContentsTable,
      LocalLessonContent,
      $$LocalLessonContentsTableFilterComposer,
      $$LocalLessonContentsTableOrderingComposer,
      $$LocalLessonContentsTableAnnotationComposer,
      $$LocalLessonContentsTableCreateCompanionBuilder,
      $$LocalLessonContentsTableUpdateCompanionBuilder,
      (
        LocalLessonContent,
        BaseReferences<
          _$AppDatabase,
          $LocalLessonContentsTable,
          LocalLessonContent
        >,
      ),
      LocalLessonContent,
      PrefetchHooks Function()
    >;
typedef $$LocalVocabularyTableCreateCompanionBuilder =
    LocalVocabularyCompanion Function({
      required String id,
      required String languageId,
      required String levelId,
      required String word,
      Value<String?> phonetic,
      Value<String?> audioUrl,
      Value<String?> imageUrl,
      Value<String?> category,
      Value<String?> partOfSpeech,
      required DateTime serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalVocabularyTableUpdateCompanionBuilder =
    LocalVocabularyCompanion Function({
      Value<String> id,
      Value<String> languageId,
      Value<String> levelId,
      Value<String> word,
      Value<String?> phonetic,
      Value<String?> audioUrl,
      Value<String?> imageUrl,
      Value<String?> category,
      Value<String?> partOfSpeech,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalVocabularyTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVocabularyTable> {
  $$LocalVocabularyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phonetic => $composableBuilder(
    column: $table.phonetic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVocabularyTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVocabularyTable> {
  $$LocalVocabularyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phonetic => $composableBuilder(
    column: $table.phonetic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVocabularyTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVocabularyTable> {
  $$LocalVocabularyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get phonetic =>
      $composableBuilder(column: $table.phonetic, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
    column: $table.partOfSpeech,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalVocabularyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVocabularyTable,
          LocalVocabularyData,
          $$LocalVocabularyTableFilterComposer,
          $$LocalVocabularyTableOrderingComposer,
          $$LocalVocabularyTableAnnotationComposer,
          $$LocalVocabularyTableCreateCompanionBuilder,
          $$LocalVocabularyTableUpdateCompanionBuilder,
          (
            LocalVocabularyData,
            BaseReferences<
              _$AppDatabase,
              $LocalVocabularyTable,
              LocalVocabularyData
            >,
          ),
          LocalVocabularyData,
          PrefetchHooks Function()
        > {
  $$LocalVocabularyTableTableManager(
    _$AppDatabase db,
    $LocalVocabularyTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVocabularyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVocabularyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVocabularyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> languageId = const Value.absent(),
                Value<String> levelId = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String?> phonetic = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVocabularyCompanion(
                id: id,
                languageId: languageId,
                levelId: levelId,
                word: word,
                phonetic: phonetic,
                audioUrl: audioUrl,
                imageUrl: imageUrl,
                category: category,
                partOfSpeech: partOfSpeech,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String languageId,
                required String levelId,
                required String word,
                Value<String?> phonetic = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> partOfSpeech = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVocabularyCompanion.insert(
                id: id,
                languageId: languageId,
                levelId: levelId,
                word: word,
                phonetic: phonetic,
                audioUrl: audioUrl,
                imageUrl: imageUrl,
                category: category,
                partOfSpeech: partOfSpeech,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVocabularyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVocabularyTable,
      LocalVocabularyData,
      $$LocalVocabularyTableFilterComposer,
      $$LocalVocabularyTableOrderingComposer,
      $$LocalVocabularyTableAnnotationComposer,
      $$LocalVocabularyTableCreateCompanionBuilder,
      $$LocalVocabularyTableUpdateCompanionBuilder,
      (
        LocalVocabularyData,
        BaseReferences<
          _$AppDatabase,
          $LocalVocabularyTable,
          LocalVocabularyData
        >,
      ),
      LocalVocabularyData,
      PrefetchHooks Function()
    >;
typedef $$LocalVocabularyTranslationsTableCreateCompanionBuilder =
    LocalVocabularyTranslationsCompanion Function({
      required String id,
      required String vocabularyId,
      required String languageId,
      required String languageCode,
      required String translation,
      Value<int> rowid,
    });
typedef $$LocalVocabularyTranslationsTableUpdateCompanionBuilder =
    LocalVocabularyTranslationsCompanion Function({
      Value<String> id,
      Value<String> vocabularyId,
      Value<String> languageId,
      Value<String> languageCode,
      Value<String> translation,
      Value<int> rowid,
    });

class $$LocalVocabularyTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVocabularyTranslationsTable> {
  $$LocalVocabularyTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVocabularyTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVocabularyTranslationsTable> {
  $$LocalVocabularyTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVocabularyTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVocabularyTranslationsTable> {
  $$LocalVocabularyTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );
}

class $$LocalVocabularyTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVocabularyTranslationsTable,
          LocalVocabularyTranslation,
          $$LocalVocabularyTranslationsTableFilterComposer,
          $$LocalVocabularyTranslationsTableOrderingComposer,
          $$LocalVocabularyTranslationsTableAnnotationComposer,
          $$LocalVocabularyTranslationsTableCreateCompanionBuilder,
          $$LocalVocabularyTranslationsTableUpdateCompanionBuilder,
          (
            LocalVocabularyTranslation,
            BaseReferences<
              _$AppDatabase,
              $LocalVocabularyTranslationsTable,
              LocalVocabularyTranslation
            >,
          ),
          LocalVocabularyTranslation,
          PrefetchHooks Function()
        > {
  $$LocalVocabularyTranslationsTableTableManager(
    _$AppDatabase db,
    $LocalVocabularyTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVocabularyTranslationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalVocabularyTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalVocabularyTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vocabularyId = const Value.absent(),
                Value<String> languageId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVocabularyTranslationsCompanion(
                id: id,
                vocabularyId: vocabularyId,
                languageId: languageId,
                languageCode: languageCode,
                translation: translation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vocabularyId,
                required String languageId,
                required String languageCode,
                required String translation,
                Value<int> rowid = const Value.absent(),
              }) => LocalVocabularyTranslationsCompanion.insert(
                id: id,
                vocabularyId: vocabularyId,
                languageId: languageId,
                languageCode: languageCode,
                translation: translation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVocabularyTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVocabularyTranslationsTable,
      LocalVocabularyTranslation,
      $$LocalVocabularyTranslationsTableFilterComposer,
      $$LocalVocabularyTranslationsTableOrderingComposer,
      $$LocalVocabularyTranslationsTableAnnotationComposer,
      $$LocalVocabularyTranslationsTableCreateCompanionBuilder,
      $$LocalVocabularyTranslationsTableUpdateCompanionBuilder,
      (
        LocalVocabularyTranslation,
        BaseReferences<
          _$AppDatabase,
          $LocalVocabularyTranslationsTable,
          LocalVocabularyTranslation
        >,
      ),
      LocalVocabularyTranslation,
      PrefetchHooks Function()
    >;
typedef $$LocalVocabularyExamplesTableCreateCompanionBuilder =
    LocalVocabularyExamplesCompanion Function({
      required String id,
      required String vocabularyId,
      required String sentence,
      Value<String?> translation,
      Value<String?> audioUrl,
      Value<int> order,
      Value<int> rowid,
    });
typedef $$LocalVocabularyExamplesTableUpdateCompanionBuilder =
    LocalVocabularyExamplesCompanion Function({
      Value<String> id,
      Value<String> vocabularyId,
      Value<String> sentence,
      Value<String?> translation,
      Value<String?> audioUrl,
      Value<int> order,
      Value<int> rowid,
    });

class $$LocalVocabularyExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVocabularyExamplesTable> {
  $$LocalVocabularyExamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVocabularyExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVocabularyExamplesTable> {
  $$LocalVocabularyExamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVocabularyExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVocabularyExamplesTable> {
  $$LocalVocabularyExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$LocalVocabularyExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVocabularyExamplesTable,
          LocalVocabularyExample,
          $$LocalVocabularyExamplesTableFilterComposer,
          $$LocalVocabularyExamplesTableOrderingComposer,
          $$LocalVocabularyExamplesTableAnnotationComposer,
          $$LocalVocabularyExamplesTableCreateCompanionBuilder,
          $$LocalVocabularyExamplesTableUpdateCompanionBuilder,
          (
            LocalVocabularyExample,
            BaseReferences<
              _$AppDatabase,
              $LocalVocabularyExamplesTable,
              LocalVocabularyExample
            >,
          ),
          LocalVocabularyExample,
          PrefetchHooks Function()
        > {
  $$LocalVocabularyExamplesTableTableManager(
    _$AppDatabase db,
    $LocalVocabularyExamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVocabularyExamplesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalVocabularyExamplesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalVocabularyExamplesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vocabularyId = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVocabularyExamplesCompanion(
                id: id,
                vocabularyId: vocabularyId,
                sentence: sentence,
                translation: translation,
                audioUrl: audioUrl,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vocabularyId,
                required String sentence,
                Value<String?> translation = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVocabularyExamplesCompanion.insert(
                id: id,
                vocabularyId: vocabularyId,
                sentence: sentence,
                translation: translation,
                audioUrl: audioUrl,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVocabularyExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVocabularyExamplesTable,
      LocalVocabularyExample,
      $$LocalVocabularyExamplesTableFilterComposer,
      $$LocalVocabularyExamplesTableOrderingComposer,
      $$LocalVocabularyExamplesTableAnnotationComposer,
      $$LocalVocabularyExamplesTableCreateCompanionBuilder,
      $$LocalVocabularyExamplesTableUpdateCompanionBuilder,
      (
        LocalVocabularyExample,
        BaseReferences<
          _$AppDatabase,
          $LocalVocabularyExamplesTable,
          LocalVocabularyExample
        >,
      ),
      LocalVocabularyExample,
      PrefetchHooks Function()
    >;
typedef $$LocalExercisesTableCreateCompanionBuilder =
    LocalExercisesCompanion Function({
      required String id,
      required String lessonId,
      required String type,
      required String question,
      Value<String?> dataJson,
      Value<int> order,
      Value<int> rowid,
    });
typedef $$LocalExercisesTableUpdateCompanionBuilder =
    LocalExercisesCompanion Function({
      Value<String> id,
      Value<String> lessonId,
      Value<String> type,
      Value<String> question,
      Value<String?> dataJson,
      Value<int> order,
      Value<int> rowid,
    });

class $$LocalExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExercisesTable> {
  $$LocalExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExercisesTable> {
  $$LocalExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExercisesTable> {
  $$LocalExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$LocalExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExercisesTable,
          LocalExercise,
          $$LocalExercisesTableFilterComposer,
          $$LocalExercisesTableOrderingComposer,
          $$LocalExercisesTableAnnotationComposer,
          $$LocalExercisesTableCreateCompanionBuilder,
          $$LocalExercisesTableUpdateCompanionBuilder,
          (
            LocalExercise,
            BaseReferences<_$AppDatabase, $LocalExercisesTable, LocalExercise>,
          ),
          LocalExercise,
          PrefetchHooks Function()
        > {
  $$LocalExercisesTableTableManager(
    _$AppDatabase db,
    $LocalExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExercisesCompanion(
                id: id,
                lessonId: lessonId,
                type: type,
                question: question,
                dataJson: dataJson,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lessonId,
                required String type,
                required String question,
                Value<String?> dataJson = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExercisesCompanion.insert(
                id: id,
                lessonId: lessonId,
                type: type,
                question: question,
                dataJson: dataJson,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExercisesTable,
      LocalExercise,
      $$LocalExercisesTableFilterComposer,
      $$LocalExercisesTableOrderingComposer,
      $$LocalExercisesTableAnnotationComposer,
      $$LocalExercisesTableCreateCompanionBuilder,
      $$LocalExercisesTableUpdateCompanionBuilder,
      (
        LocalExercise,
        BaseReferences<_$AppDatabase, $LocalExercisesTable, LocalExercise>,
      ),
      LocalExercise,
      PrefetchHooks Function()
    >;
typedef $$LocalExerciseOptionsTableCreateCompanionBuilder =
    LocalExerciseOptionsCompanion Function({
      required String id,
      required String exerciseId,
      required String label,
      Value<int> order,
      Value<int> rowid,
    });
typedef $$LocalExerciseOptionsTableUpdateCompanionBuilder =
    LocalExerciseOptionsCompanion Function({
      Value<String> id,
      Value<String> exerciseId,
      Value<String> label,
      Value<int> order,
      Value<int> rowid,
    });

class $$LocalExerciseOptionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExerciseOptionsTable> {
  $$LocalExerciseOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExerciseOptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExerciseOptionsTable> {
  $$LocalExerciseOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExerciseOptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExerciseOptionsTable> {
  $$LocalExerciseOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$LocalExerciseOptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExerciseOptionsTable,
          LocalExerciseOption,
          $$LocalExerciseOptionsTableFilterComposer,
          $$LocalExerciseOptionsTableOrderingComposer,
          $$LocalExerciseOptionsTableAnnotationComposer,
          $$LocalExerciseOptionsTableCreateCompanionBuilder,
          $$LocalExerciseOptionsTableUpdateCompanionBuilder,
          (
            LocalExerciseOption,
            BaseReferences<
              _$AppDatabase,
              $LocalExerciseOptionsTable,
              LocalExerciseOption
            >,
          ),
          LocalExerciseOption,
          PrefetchHooks Function()
        > {
  $$LocalExerciseOptionsTableTableManager(
    _$AppDatabase db,
    $LocalExerciseOptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExerciseOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExerciseOptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalExerciseOptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExerciseOptionsCompanion(
                id: id,
                exerciseId: exerciseId,
                label: label,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String exerciseId,
                required String label,
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExerciseOptionsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                label: label,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExerciseOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExerciseOptionsTable,
      LocalExerciseOption,
      $$LocalExerciseOptionsTableFilterComposer,
      $$LocalExerciseOptionsTableOrderingComposer,
      $$LocalExerciseOptionsTableAnnotationComposer,
      $$LocalExerciseOptionsTableCreateCompanionBuilder,
      $$LocalExerciseOptionsTableUpdateCompanionBuilder,
      (
        LocalExerciseOption,
        BaseReferences<
          _$AppDatabase,
          $LocalExerciseOptionsTable,
          LocalExerciseOption
        >,
      ),
      LocalExerciseOption,
      PrefetchHooks Function()
    >;
typedef $$LocalUserProfileTableCreateCompanionBuilder =
    LocalUserProfileCompanion Function({
      required String id,
      required String email,
      required String firstName,
      required String lastName,
      required String role,
      Value<bool> emailVerified,
      Value<String?> nativeLanguageId,
      Value<int> xp,
      Value<int> userLevel,
      required DateTime serverUpdatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserProfileTableUpdateCompanionBuilder =
    LocalUserProfileCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> role,
      Value<bool> emailVerified,
      Value<String?> nativeLanguageId,
      Value<int> xp,
      Value<int> userLevel,
      Value<DateTime> serverUpdatedAt,
      Value<int> rowid,
    });

class $$LocalUserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserProfileTable> {
  $$LocalUserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nativeLanguageId => $composableBuilder(
    column: $table.nativeLanguageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userLevel => $composableBuilder(
    column: $table.userLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserProfileTable> {
  $$LocalUserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nativeLanguageId => $composableBuilder(
    column: $table.nativeLanguageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userLevel => $composableBuilder(
    column: $table.userLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserProfileTable> {
  $$LocalUserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get emailVerified => $composableBuilder(
    column: $table.emailVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nativeLanguageId => $composableBuilder(
    column: $table.nativeLanguageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get userLevel =>
      $composableBuilder(column: $table.userLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );
}

class $$LocalUserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserProfileTable,
          LocalUserProfileData,
          $$LocalUserProfileTableFilterComposer,
          $$LocalUserProfileTableOrderingComposer,
          $$LocalUserProfileTableAnnotationComposer,
          $$LocalUserProfileTableCreateCompanionBuilder,
          $$LocalUserProfileTableUpdateCompanionBuilder,
          (
            LocalUserProfileData,
            BaseReferences<
              _$AppDatabase,
              $LocalUserProfileTable,
              LocalUserProfileData
            >,
          ),
          LocalUserProfileData,
          PrefetchHooks Function()
        > {
  $$LocalUserProfileTableTableManager(
    _$AppDatabase db,
    $LocalUserProfileTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> emailVerified = const Value.absent(),
                Value<String?> nativeLanguageId = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> userLevel = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfileCompanion(
                id: id,
                email: email,
                firstName: firstName,
                lastName: lastName,
                role: role,
                emailVerified: emailVerified,
                nativeLanguageId: nativeLanguageId,
                xp: xp,
                userLevel: userLevel,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String firstName,
                required String lastName,
                required String role,
                Value<bool> emailVerified = const Value.absent(),
                Value<String?> nativeLanguageId = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> userLevel = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProfileCompanion.insert(
                id: id,
                email: email,
                firstName: firstName,
                lastName: lastName,
                role: role,
                emailVerified: emailVerified,
                nativeLanguageId: nativeLanguageId,
                xp: xp,
                userLevel: userLevel,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserProfileTable,
      LocalUserProfileData,
      $$LocalUserProfileTableFilterComposer,
      $$LocalUserProfileTableOrderingComposer,
      $$LocalUserProfileTableAnnotationComposer,
      $$LocalUserProfileTableCreateCompanionBuilder,
      $$LocalUserProfileTableUpdateCompanionBuilder,
      (
        LocalUserProfileData,
        BaseReferences<
          _$AppDatabase,
          $LocalUserProfileTable,
          LocalUserProfileData
        >,
      ),
      LocalUserProfileData,
      PrefetchHooks Function()
    >;
typedef $$LocalUserLanguagesTableCreateCompanionBuilder =
    LocalUserLanguagesCompanion Function({
      required String id,
      required String userId,
      required String languageId,
      Value<String?> levelId,
      Value<bool> isActive,
      Value<double> progressPercent,
      required DateTime startedAt,
      required DateTime serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalUserLanguagesTableUpdateCompanionBuilder =
    LocalUserLanguagesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> languageId,
      Value<String?> levelId,
      Value<bool> isActive,
      Value<double> progressPercent,
      Value<DateTime> startedAt,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalUserLanguagesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserLanguagesTable> {
  $$LocalUserLanguagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserLanguagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserLanguagesTable> {
  $$LocalUserLanguagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserLanguagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserLanguagesTable> {
  $$LocalUserLanguagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get languageId => $composableBuilder(
    column: $table.languageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<double> get progressPercent => $composableBuilder(
    column: $table.progressPercent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalUserLanguagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserLanguagesTable,
          LocalUserLanguage,
          $$LocalUserLanguagesTableFilterComposer,
          $$LocalUserLanguagesTableOrderingComposer,
          $$LocalUserLanguagesTableAnnotationComposer,
          $$LocalUserLanguagesTableCreateCompanionBuilder,
          $$LocalUserLanguagesTableUpdateCompanionBuilder,
          (
            LocalUserLanguage,
            BaseReferences<
              _$AppDatabase,
              $LocalUserLanguagesTable,
              LocalUserLanguage
            >,
          ),
          LocalUserLanguage,
          PrefetchHooks Function()
        > {
  $$LocalUserLanguagesTableTableManager(
    _$AppDatabase db,
    $LocalUserLanguagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserLanguagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserLanguagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserLanguagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> languageId = const Value.absent(),
                Value<String?> levelId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<double> progressPercent = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserLanguagesCompanion(
                id: id,
                userId: userId,
                languageId: languageId,
                levelId: levelId,
                isActive: isActive,
                progressPercent: progressPercent,
                startedAt: startedAt,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String languageId,
                Value<String?> levelId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<double> progressPercent = const Value.absent(),
                required DateTime startedAt,
                required DateTime serverUpdatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserLanguagesCompanion.insert(
                id: id,
                userId: userId,
                languageId: languageId,
                levelId: levelId,
                isActive: isActive,
                progressPercent: progressPercent,
                startedAt: startedAt,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserLanguagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserLanguagesTable,
      LocalUserLanguage,
      $$LocalUserLanguagesTableFilterComposer,
      $$LocalUserLanguagesTableOrderingComposer,
      $$LocalUserLanguagesTableAnnotationComposer,
      $$LocalUserLanguagesTableCreateCompanionBuilder,
      $$LocalUserLanguagesTableUpdateCompanionBuilder,
      (
        LocalUserLanguage,
        BaseReferences<
          _$AppDatabase,
          $LocalUserLanguagesTable,
          LocalUserLanguage
        >,
      ),
      LocalUserLanguage,
      PrefetchHooks Function()
    >;
typedef $$LocalUserProgressTableCreateCompanionBuilder =
    LocalUserProgressCompanion Function({
      required String id,
      required String userId,
      required String lessonId,
      required String status,
      Value<int> score,
      Value<int> timeSpentSec,
      Value<DateTime?> completedAt,
      required DateTime serverUpdatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserProgressTableUpdateCompanionBuilder =
    LocalUserProgressCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> lessonId,
      Value<String> status,
      Value<int> score,
      Value<int> timeSpentSec,
      Value<DateTime?> completedAt,
      Value<DateTime> serverUpdatedAt,
      Value<int> rowid,
    });

class $$LocalUserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserProgressTable> {
  $$LocalUserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpentSec => $composableBuilder(
    column: $table.timeSpentSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserProgressTable> {
  $$LocalUserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpentSec => $composableBuilder(
    column: $table.timeSpentSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserProgressTable> {
  $$LocalUserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get timeSpentSec => $composableBuilder(
    column: $table.timeSpentSec,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );
}

class $$LocalUserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserProgressTable,
          LocalUserProgressData,
          $$LocalUserProgressTableFilterComposer,
          $$LocalUserProgressTableOrderingComposer,
          $$LocalUserProgressTableAnnotationComposer,
          $$LocalUserProgressTableCreateCompanionBuilder,
          $$LocalUserProgressTableUpdateCompanionBuilder,
          (
            LocalUserProgressData,
            BaseReferences<
              _$AppDatabase,
              $LocalUserProgressTable,
              LocalUserProgressData
            >,
          ),
          LocalUserProgressData,
          PrefetchHooks Function()
        > {
  $$LocalUserProgressTableTableManager(
    _$AppDatabase db,
    $LocalUserProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> timeSpentSec = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProgressCompanion(
                id: id,
                userId: userId,
                lessonId: lessonId,
                status: status,
                score: score,
                timeSpentSec: timeSpentSec,
                completedAt: completedAt,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String lessonId,
                required String status,
                Value<int> score = const Value.absent(),
                Value<int> timeSpentSec = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUserProgressCompanion.insert(
                id: id,
                userId: userId,
                lessonId: lessonId,
                status: status,
                score: score,
                timeSpentSec: timeSpentSec,
                completedAt: completedAt,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserProgressTable,
      LocalUserProgressData,
      $$LocalUserProgressTableFilterComposer,
      $$LocalUserProgressTableOrderingComposer,
      $$LocalUserProgressTableAnnotationComposer,
      $$LocalUserProgressTableCreateCompanionBuilder,
      $$LocalUserProgressTableUpdateCompanionBuilder,
      (
        LocalUserProgressData,
        BaseReferences<
          _$AppDatabase,
          $LocalUserProgressTable,
          LocalUserProgressData
        >,
      ),
      LocalUserProgressData,
      PrefetchHooks Function()
    >;
typedef $$LocalUserVocabularyTableCreateCompanionBuilder =
    LocalUserVocabularyCompanion Function({
      required String id,
      required String userId,
      required String vocabularyId,
      required String state,
      Value<bool> isFavorite,
      Value<int> repetitions,
      Value<int> intervalDays,
      Value<double> easeFactor,
      Value<double> successRate,
      Value<double> difficulty,
      Value<DateTime?> nextReviewAt,
      Value<DateTime?> lastReviewedAt,
      required DateTime serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$LocalUserVocabularyTableUpdateCompanionBuilder =
    LocalUserVocabularyCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> vocabularyId,
      Value<String> state,
      Value<bool> isFavorite,
      Value<int> repetitions,
      Value<int> intervalDays,
      Value<double> easeFactor,
      Value<double> successRate,
      Value<double> difficulty,
      Value<DateTime?> nextReviewAt,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime> serverUpdatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$LocalUserVocabularyTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserVocabularyTable> {
  $$LocalUserVocabularyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get successRate => $composableBuilder(
    column: $table.successRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserVocabularyTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserVocabularyTable> {
  $$LocalUserVocabularyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get successRate => $composableBuilder(
    column: $table.successRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserVocabularyTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserVocabularyTable> {
  $$LocalUserVocabularyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get vocabularyId => $composableBuilder(
    column: $table.vocabularyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<double> get successRate => $composableBuilder(
    column: $table.successRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$LocalUserVocabularyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserVocabularyTable,
          LocalUserVocabularyData,
          $$LocalUserVocabularyTableFilterComposer,
          $$LocalUserVocabularyTableOrderingComposer,
          $$LocalUserVocabularyTableAnnotationComposer,
          $$LocalUserVocabularyTableCreateCompanionBuilder,
          $$LocalUserVocabularyTableUpdateCompanionBuilder,
          (
            LocalUserVocabularyData,
            BaseReferences<
              _$AppDatabase,
              $LocalUserVocabularyTable,
              LocalUserVocabularyData
            >,
          ),
          LocalUserVocabularyData,
          PrefetchHooks Function()
        > {
  $$LocalUserVocabularyTableTableManager(
    _$AppDatabase db,
    $LocalUserVocabularyTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserVocabularyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserVocabularyTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalUserVocabularyTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> vocabularyId = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<double> successRate = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<DateTime?> nextReviewAt = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserVocabularyCompanion(
                id: id,
                userId: userId,
                vocabularyId: vocabularyId,
                state: state,
                isFavorite: isFavorite,
                repetitions: repetitions,
                intervalDays: intervalDays,
                easeFactor: easeFactor,
                successRate: successRate,
                difficulty: difficulty,
                nextReviewAt: nextReviewAt,
                lastReviewedAt: lastReviewedAt,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String vocabularyId,
                required String state,
                Value<bool> isFavorite = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<double> successRate = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<DateTime?> nextReviewAt = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserVocabularyCompanion.insert(
                id: id,
                userId: userId,
                vocabularyId: vocabularyId,
                state: state,
                isFavorite: isFavorite,
                repetitions: repetitions,
                intervalDays: intervalDays,
                easeFactor: easeFactor,
                successRate: successRate,
                difficulty: difficulty,
                nextReviewAt: nextReviewAt,
                lastReviewedAt: lastReviewedAt,
                serverUpdatedAt: serverUpdatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserVocabularyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserVocabularyTable,
      LocalUserVocabularyData,
      $$LocalUserVocabularyTableFilterComposer,
      $$LocalUserVocabularyTableOrderingComposer,
      $$LocalUserVocabularyTableAnnotationComposer,
      $$LocalUserVocabularyTableCreateCompanionBuilder,
      $$LocalUserVocabularyTableUpdateCompanionBuilder,
      (
        LocalUserVocabularyData,
        BaseReferences<
          _$AppDatabase,
          $LocalUserVocabularyTable,
          LocalUserVocabularyData
        >,
      ),
      LocalUserVocabularyData,
      PrefetchHooks Function()
    >;
typedef $$LocalDailyGoalsTableCreateCompanionBuilder =
    LocalDailyGoalsCompanion Function({
      required String id,
      required String userId,
      required String type,
      required int target,
      Value<bool> isActive,
      required DateTime serverUpdatedAt,
      Value<int> rowid,
    });
typedef $$LocalDailyGoalsTableUpdateCompanionBuilder =
    LocalDailyGoalsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> type,
      Value<int> target,
      Value<bool> isActive,
      Value<DateTime> serverUpdatedAt,
      Value<int> rowid,
    });

class $$LocalDailyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDailyGoalsTable> {
  $$LocalDailyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDailyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDailyGoalsTable> {
  $$LocalDailyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDailyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDailyGoalsTable> {
  $$LocalDailyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );
}

class $$LocalDailyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDailyGoalsTable,
          LocalDailyGoal,
          $$LocalDailyGoalsTableFilterComposer,
          $$LocalDailyGoalsTableOrderingComposer,
          $$LocalDailyGoalsTableAnnotationComposer,
          $$LocalDailyGoalsTableCreateCompanionBuilder,
          $$LocalDailyGoalsTableUpdateCompanionBuilder,
          (
            LocalDailyGoal,
            BaseReferences<
              _$AppDatabase,
              $LocalDailyGoalsTable,
              LocalDailyGoal
            >,
          ),
          LocalDailyGoal,
          PrefetchHooks Function()
        > {
  $$LocalDailyGoalsTableTableManager(
    _$AppDatabase db,
    $LocalDailyGoalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDailyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDailyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDailyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDailyGoalsCompanion(
                id: id,
                userId: userId,
                type: type,
                target: target,
                isActive: isActive,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String type,
                required int target,
                Value<bool> isActive = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalDailyGoalsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                target: target,
                isActive: isActive,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDailyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDailyGoalsTable,
      LocalDailyGoal,
      $$LocalDailyGoalsTableFilterComposer,
      $$LocalDailyGoalsTableOrderingComposer,
      $$LocalDailyGoalsTableAnnotationComposer,
      $$LocalDailyGoalsTableCreateCompanionBuilder,
      $$LocalDailyGoalsTableUpdateCompanionBuilder,
      (
        LocalDailyGoal,
        BaseReferences<_$AppDatabase, $LocalDailyGoalsTable, LocalDailyGoal>,
      ),
      LocalDailyGoal,
      PrefetchHooks Function()
    >;
typedef $$LocalStreaksTableCreateCompanionBuilder =
    LocalStreaksCompanion Function({
      required String id,
      required String userId,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> totalActiveDays,
      Value<DateTime?> lastActiveDate,
      required DateTime serverUpdatedAt,
      Value<int> rowid,
    });
typedef $$LocalStreaksTableUpdateCompanionBuilder =
    LocalStreaksCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> totalActiveDays,
      Value<DateTime?> lastActiveDate,
      Value<DateTime> serverUpdatedAt,
      Value<int> rowid,
    });

class $$LocalStreaksTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStreaksTable> {
  $$LocalStreaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalActiveDays => $composableBuilder(
    column: $table.totalActiveDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActiveDate => $composableBuilder(
    column: $table.lastActiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalStreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStreaksTable> {
  $$LocalStreaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalActiveDays => $composableBuilder(
    column: $table.totalActiveDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActiveDate => $composableBuilder(
    column: $table.lastActiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalStreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStreaksTable> {
  $$LocalStreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalActiveDays => $composableBuilder(
    column: $table.totalActiveDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastActiveDate => $composableBuilder(
    column: $table.lastActiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );
}

class $$LocalStreaksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalStreaksTable,
          LocalStreak,
          $$LocalStreaksTableFilterComposer,
          $$LocalStreaksTableOrderingComposer,
          $$LocalStreaksTableAnnotationComposer,
          $$LocalStreaksTableCreateCompanionBuilder,
          $$LocalStreaksTableUpdateCompanionBuilder,
          (
            LocalStreak,
            BaseReferences<_$AppDatabase, $LocalStreaksTable, LocalStreak>,
          ),
          LocalStreak,
          PrefetchHooks Function()
        > {
  $$LocalStreaksTableTableManager(_$AppDatabase db, $LocalStreaksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalActiveDays = const Value.absent(),
                Value<DateTime?> lastActiveDate = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalStreaksCompanion(
                id: id,
                userId: userId,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                totalActiveDays: totalActiveDays,
                lastActiveDate: lastActiveDate,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalActiveDays = const Value.absent(),
                Value<DateTime?> lastActiveDate = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalStreaksCompanion.insert(
                id: id,
                userId: userId,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                totalActiveDays: totalActiveDays,
                lastActiveDate: lastActiveDate,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalStreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalStreaksTable,
      LocalStreak,
      $$LocalStreaksTableFilterComposer,
      $$LocalStreaksTableOrderingComposer,
      $$LocalStreaksTableAnnotationComposer,
      $$LocalStreaksTableCreateCompanionBuilder,
      $$LocalStreaksTableUpdateCompanionBuilder,
      (
        LocalStreak,
        BaseReferences<_$AppDatabase, $LocalStreaksTable, LocalStreak>,
      ),
      LocalStreak,
      PrefetchHooks Function()
    >;
typedef $$LocalDailyActivitiesTableCreateCompanionBuilder =
    LocalDailyActivitiesCompanion Function({
      required String id,
      required String userId,
      required DateTime date,
      Value<int> minutesLearned,
      Value<int> wordsLearned,
      Value<int> wordsReviewed,
      Value<int> exercisesDone,
      Value<int> exercisesCorrect,
      Value<int> xpEarned,
      required DateTime serverUpdatedAt,
      Value<int> rowid,
    });
typedef $$LocalDailyActivitiesTableUpdateCompanionBuilder =
    LocalDailyActivitiesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<DateTime> date,
      Value<int> minutesLearned,
      Value<int> wordsLearned,
      Value<int> wordsReviewed,
      Value<int> exercisesDone,
      Value<int> exercisesCorrect,
      Value<int> xpEarned,
      Value<DateTime> serverUpdatedAt,
      Value<int> rowid,
    });

class $$LocalDailyActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDailyActivitiesTable> {
  $$LocalDailyActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesLearned => $composableBuilder(
    column: $table.minutesLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordsLearned => $composableBuilder(
    column: $table.wordsLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordsReviewed => $composableBuilder(
    column: $table.wordsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exercisesDone => $composableBuilder(
    column: $table.exercisesDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exercisesCorrect => $composableBuilder(
    column: $table.exercisesCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDailyActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDailyActivitiesTable> {
  $$LocalDailyActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesLearned => $composableBuilder(
    column: $table.minutesLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordsLearned => $composableBuilder(
    column: $table.wordsLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordsReviewed => $composableBuilder(
    column: $table.wordsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exercisesDone => $composableBuilder(
    column: $table.exercisesDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exercisesCorrect => $composableBuilder(
    column: $table.exercisesCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDailyActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDailyActivitiesTable> {
  $$LocalDailyActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get minutesLearned => $composableBuilder(
    column: $table.minutesLearned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordsLearned => $composableBuilder(
    column: $table.wordsLearned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordsReviewed => $composableBuilder(
    column: $table.wordsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exercisesDone => $composableBuilder(
    column: $table.exercisesDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exercisesCorrect => $composableBuilder(
    column: $table.exercisesCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );
}

class $$LocalDailyActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDailyActivitiesTable,
          LocalDailyActivity,
          $$LocalDailyActivitiesTableFilterComposer,
          $$LocalDailyActivitiesTableOrderingComposer,
          $$LocalDailyActivitiesTableAnnotationComposer,
          $$LocalDailyActivitiesTableCreateCompanionBuilder,
          $$LocalDailyActivitiesTableUpdateCompanionBuilder,
          (
            LocalDailyActivity,
            BaseReferences<
              _$AppDatabase,
              $LocalDailyActivitiesTable,
              LocalDailyActivity
            >,
          ),
          LocalDailyActivity,
          PrefetchHooks Function()
        > {
  $$LocalDailyActivitiesTableTableManager(
    _$AppDatabase db,
    $LocalDailyActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDailyActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDailyActivitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalDailyActivitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> minutesLearned = const Value.absent(),
                Value<int> wordsLearned = const Value.absent(),
                Value<int> wordsReviewed = const Value.absent(),
                Value<int> exercisesDone = const Value.absent(),
                Value<int> exercisesCorrect = const Value.absent(),
                Value<int> xpEarned = const Value.absent(),
                Value<DateTime> serverUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDailyActivitiesCompanion(
                id: id,
                userId: userId,
                date: date,
                minutesLearned: minutesLearned,
                wordsLearned: wordsLearned,
                wordsReviewed: wordsReviewed,
                exercisesDone: exercisesDone,
                exercisesCorrect: exercisesCorrect,
                xpEarned: xpEarned,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required DateTime date,
                Value<int> minutesLearned = const Value.absent(),
                Value<int> wordsLearned = const Value.absent(),
                Value<int> wordsReviewed = const Value.absent(),
                Value<int> exercisesDone = const Value.absent(),
                Value<int> exercisesCorrect = const Value.absent(),
                Value<int> xpEarned = const Value.absent(),
                required DateTime serverUpdatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalDailyActivitiesCompanion.insert(
                id: id,
                userId: userId,
                date: date,
                minutesLearned: minutesLearned,
                wordsLearned: wordsLearned,
                wordsReviewed: wordsReviewed,
                exercisesDone: exercisesDone,
                exercisesCorrect: exercisesCorrect,
                xpEarned: xpEarned,
                serverUpdatedAt: serverUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDailyActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDailyActivitiesTable,
      LocalDailyActivity,
      $$LocalDailyActivitiesTableFilterComposer,
      $$LocalDailyActivitiesTableOrderingComposer,
      $$LocalDailyActivitiesTableAnnotationComposer,
      $$LocalDailyActivitiesTableCreateCompanionBuilder,
      $$LocalDailyActivitiesTableUpdateCompanionBuilder,
      (
        LocalDailyActivity,
        BaseReferences<
          _$AppDatabase,
          $LocalDailyActivitiesTable,
          LocalDailyActivity
        >,
      ),
      LocalDailyActivity,
      PrefetchHooks Function()
    >;
typedef $$LocalUserBadgesTableCreateCompanionBuilder =
    LocalUserBadgesCompanion Function({
      required String id,
      required String userId,
      required String badgeId,
      required DateTime earnedAt,
      Value<int> rowid,
    });
typedef $$LocalUserBadgesTableUpdateCompanionBuilder =
    LocalUserBadgesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> badgeId,
      Value<DateTime> earnedAt,
      Value<int> rowid,
    });

class $$LocalUserBadgesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserBadgesTable> {
  $$LocalUserBadgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get badgeId => $composableBuilder(
    column: $table.badgeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserBadgesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserBadgesTable> {
  $$LocalUserBadgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get badgeId => $composableBuilder(
    column: $table.badgeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserBadgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserBadgesTable> {
  $$LocalUserBadgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get badgeId =>
      $composableBuilder(column: $table.badgeId, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);
}

class $$LocalUserBadgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserBadgesTable,
          LocalUserBadge,
          $$LocalUserBadgesTableFilterComposer,
          $$LocalUserBadgesTableOrderingComposer,
          $$LocalUserBadgesTableAnnotationComposer,
          $$LocalUserBadgesTableCreateCompanionBuilder,
          $$LocalUserBadgesTableUpdateCompanionBuilder,
          (
            LocalUserBadge,
            BaseReferences<
              _$AppDatabase,
              $LocalUserBadgesTable,
              LocalUserBadge
            >,
          ),
          LocalUserBadge,
          PrefetchHooks Function()
        > {
  $$LocalUserBadgesTableTableManager(
    _$AppDatabase db,
    $LocalUserBadgesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserBadgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUserBadgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUserBadgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> badgeId = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserBadgesCompanion(
                id: id,
                userId: userId,
                badgeId: badgeId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String badgeId,
                required DateTime earnedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalUserBadgesCompanion.insert(
                id: id,
                userId: userId,
                badgeId: badgeId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserBadgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserBadgesTable,
      LocalUserBadge,
      $$LocalUserBadgesTableFilterComposer,
      $$LocalUserBadgesTableOrderingComposer,
      $$LocalUserBadgesTableAnnotationComposer,
      $$LocalUserBadgesTableCreateCompanionBuilder,
      $$LocalUserBadgesTableUpdateCompanionBuilder,
      (
        LocalUserBadge,
        BaseReferences<_$AppDatabase, $LocalUserBadgesTable, LocalUserBadge>,
      ),
      LocalUserBadge,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueEntriesTableCreateCompanionBuilder =
    SyncQueueEntriesCompanion Function({
      required String id,
      required String entity,
      required String entityId,
      required String op,
      Value<String?> payloadJson,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> errorMessage,
      required DateTime clientTimestamp,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SyncQueueEntriesTableUpdateCompanionBuilder =
    SyncQueueEntriesCompanion Function({
      Value<String> id,
      Value<String> entity,
      Value<String> entityId,
      Value<String> op,
      Value<String?> payloadJson,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> errorMessage,
      Value<DateTime> clientTimestamp,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncQueueEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueEntriesTable,
          SyncQueueEntry,
          $$SyncQueueEntriesTableFilterComposer,
          $$SyncQueueEntriesTableOrderingComposer,
          $$SyncQueueEntriesTableAnnotationComposer,
          $$SyncQueueEntriesTableCreateCompanionBuilder,
          $$SyncQueueEntriesTableUpdateCompanionBuilder,
          (
            SyncQueueEntry,
            BaseReferences<
              _$AppDatabase,
              $SyncQueueEntriesTable,
              SyncQueueEntry
            >,
          ),
          SyncQueueEntry,
          PrefetchHooks Function()
        > {
  $$SyncQueueEntriesTableTableManager(
    _$AppDatabase db,
    $SyncQueueEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> clientTimestamp = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueEntriesCompanion(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                status: status,
                retryCount: retryCount,
                errorMessage: errorMessage,
                clientTimestamp: clientTimestamp,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entity,
                required String entityId,
                required String op,
                Value<String?> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required DateTime clientTimestamp,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueEntriesCompanion.insert(
                id: id,
                entity: entity,
                entityId: entityId,
                op: op,
                payloadJson: payloadJson,
                status: status,
                retryCount: retryCount,
                errorMessage: errorMessage,
                clientTimestamp: clientTimestamp,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueEntriesTable,
      SyncQueueEntry,
      $$SyncQueueEntriesTableFilterComposer,
      $$SyncQueueEntriesTableOrderingComposer,
      $$SyncQueueEntriesTableAnnotationComposer,
      $$SyncQueueEntriesTableCreateCompanionBuilder,
      $$SyncQueueEntriesTableUpdateCompanionBuilder,
      (
        SyncQueueEntry,
        BaseReferences<_$AppDatabase, $SyncQueueEntriesTable, SyncQueueEntry>,
      ),
      SyncQueueEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalLanguagesTableTableManager get localLanguages =>
      $$LocalLanguagesTableTableManager(_db, _db.localLanguages);
  $$LocalLevelsTableTableManager get localLevels =>
      $$LocalLevelsTableTableManager(_db, _db.localLevels);
  $$LocalCoursesTableTableManager get localCourses =>
      $$LocalCoursesTableTableManager(_db, _db.localCourses);
  $$LocalModulesTableTableManager get localModules =>
      $$LocalModulesTableTableManager(_db, _db.localModules);
  $$LocalLessonsTableTableManager get localLessons =>
      $$LocalLessonsTableTableManager(_db, _db.localLessons);
  $$LocalLessonContentsTableTableManager get localLessonContents =>
      $$LocalLessonContentsTableTableManager(_db, _db.localLessonContents);
  $$LocalVocabularyTableTableManager get localVocabulary =>
      $$LocalVocabularyTableTableManager(_db, _db.localVocabulary);
  $$LocalVocabularyTranslationsTableTableManager
  get localVocabularyTranslations =>
      $$LocalVocabularyTranslationsTableTableManager(
        _db,
        _db.localVocabularyTranslations,
      );
  $$LocalVocabularyExamplesTableTableManager get localVocabularyExamples =>
      $$LocalVocabularyExamplesTableTableManager(
        _db,
        _db.localVocabularyExamples,
      );
  $$LocalExercisesTableTableManager get localExercises =>
      $$LocalExercisesTableTableManager(_db, _db.localExercises);
  $$LocalExerciseOptionsTableTableManager get localExerciseOptions =>
      $$LocalExerciseOptionsTableTableManager(_db, _db.localExerciseOptions);
  $$LocalUserProfileTableTableManager get localUserProfile =>
      $$LocalUserProfileTableTableManager(_db, _db.localUserProfile);
  $$LocalUserLanguagesTableTableManager get localUserLanguages =>
      $$LocalUserLanguagesTableTableManager(_db, _db.localUserLanguages);
  $$LocalUserProgressTableTableManager get localUserProgress =>
      $$LocalUserProgressTableTableManager(_db, _db.localUserProgress);
  $$LocalUserVocabularyTableTableManager get localUserVocabulary =>
      $$LocalUserVocabularyTableTableManager(_db, _db.localUserVocabulary);
  $$LocalDailyGoalsTableTableManager get localDailyGoals =>
      $$LocalDailyGoalsTableTableManager(_db, _db.localDailyGoals);
  $$LocalStreaksTableTableManager get localStreaks =>
      $$LocalStreaksTableTableManager(_db, _db.localStreaks);
  $$LocalDailyActivitiesTableTableManager get localDailyActivities =>
      $$LocalDailyActivitiesTableTableManager(_db, _db.localDailyActivities);
  $$LocalUserBadgesTableTableManager get localUserBadges =>
      $$LocalUserBadgesTableTableManager(_db, _db.localUserBadges);
  $$SyncQueueEntriesTableTableManager get syncQueueEntries =>
      $$SyncQueueEntriesTableTableManager(_db, _db.syncQueueEntries);
}
