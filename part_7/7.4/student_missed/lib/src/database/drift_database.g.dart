// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String name;
  const Group({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Group copyWith({int? id, String? name}) => Group(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group && other.id == this.id && other.name == this.name);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GroupsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, fullName, groupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(Insertable<Student> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final int id;
  final String fullName;
  final int groupId;
  const Student(
      {required this.id, required this.fullName, required this.groupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['full_name'] = Variable<String>(fullName);
    map['group_id'] = Variable<int>(groupId);
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      fullName: Value(fullName),
      groupId: Value(groupId),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<int>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fullName': serializer.toJson<String>(fullName),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  Student copyWith({int? id, String? fullName, int? groupId}) => Student(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        groupId: groupId ?? this.groupId,
      );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, groupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.groupId == this.groupId);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<int> id;
  final Value<String> fullName;
  final Value<int> groupId;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  StudentsCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    required int groupId,
  })  : fullName = Value(fullName),
        groupId = Value(groupId);
  static Insertable<Student> custom({
    Expression<int>? id,
    Expression<String>? fullName,
    Expression<int>? groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (groupId != null) 'group_id': groupId,
    });
  }

  StudentsCompanion copyWith(
      {Value<int>? id, Value<String>? fullName, Value<int>? groupId}) {
    return StudentsCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }
}

class $DisciplinesTable extends Disciplines
    with TableInfo<$DisciplinesTable, Discipline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DisciplinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'disciplines';
  @override
  VerificationContext validateIntegrity(Insertable<Discipline> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Discipline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Discipline(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $DisciplinesTable createAlias(String alias) {
    return $DisciplinesTable(attachedDatabase, alias);
  }
}

class Discipline extends DataClass implements Insertable<Discipline> {
  final int id;
  final String name;
  const Discipline({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  DisciplinesCompanion toCompanion(bool nullToAbsent) {
    return DisciplinesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Discipline.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Discipline(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Discipline copyWith({int? id, String? name}) => Discipline(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Discipline copyWithCompanion(DisciplinesCompanion data) {
    return Discipline(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Discipline(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Discipline && other.id == this.id && other.name == this.name);
}

class DisciplinesCompanion extends UpdateCompanion<Discipline> {
  final Value<int> id;
  final Value<String> name;
  const DisciplinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  DisciplinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Discipline> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  DisciplinesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return DisciplinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DisciplinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $MissedClassesTable extends MissedClasses
    with TableInfo<$MissedClassesTable, MissedClassesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissedClassesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _studentIdMeta =
      const VerificationMeta('studentId');
  @override
  late final GeneratedColumn<int> studentId = GeneratedColumn<int>(
      'student_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES students (id)'));
  static const VerificationMeta _disciplineIdMeta =
      const VerificationMeta('disciplineId');
  @override
  late final GeneratedColumn<int> disciplineId = GeneratedColumn<int>(
      'discipline_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES disciplines (id)'));
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
      'day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isMissedMeta =
      const VerificationMeta('isMissed');
  @override
  late final GeneratedColumn<bool> isMissed = GeneratedColumn<bool>(
      'is_missed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_missed" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, studentId, disciplineId, day, isMissed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'missed_classes';
  @override
  VerificationContext validateIntegrity(Insertable<MissedClassesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('student_id')) {
      context.handle(_studentIdMeta,
          studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta));
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('discipline_id')) {
      context.handle(
          _disciplineIdMeta,
          disciplineId.isAcceptableOrUnknown(
              data['discipline_id']!, _disciplineIdMeta));
    } else if (isInserting) {
      context.missing(_disciplineIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('is_missed')) {
      context.handle(_isMissedMeta,
          isMissed.isAcceptableOrUnknown(data['is_missed']!, _isMissedMeta));
    } else if (isInserting) {
      context.missing(_isMissedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MissedClassesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissedClassesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      studentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}student_id'])!,
      disciplineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discipline_id'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}day'])!,
      isMissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_missed'])!,
    );
  }

  @override
  $MissedClassesTable createAlias(String alias) {
    return $MissedClassesTable(attachedDatabase, alias);
  }
}

class MissedClassesData extends DataClass
    implements Insertable<MissedClassesData> {
  final int id;
  final int studentId;
  final int disciplineId;
  final DateTime day;
  final bool isMissed;
  const MissedClassesData(
      {required this.id,
      required this.studentId,
      required this.disciplineId,
      required this.day,
      required this.isMissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['student_id'] = Variable<int>(studentId);
    map['discipline_id'] = Variable<int>(disciplineId);
    map['day'] = Variable<DateTime>(day);
    map['is_missed'] = Variable<bool>(isMissed);
    return map;
  }

  MissedClassesCompanion toCompanion(bool nullToAbsent) {
    return MissedClassesCompanion(
      id: Value(id),
      studentId: Value(studentId),
      disciplineId: Value(disciplineId),
      day: Value(day),
      isMissed: Value(isMissed),
    );
  }

  factory MissedClassesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissedClassesData(
      id: serializer.fromJson<int>(json['id']),
      studentId: serializer.fromJson<int>(json['studentId']),
      disciplineId: serializer.fromJson<int>(json['disciplineId']),
      day: serializer.fromJson<DateTime>(json['day']),
      isMissed: serializer.fromJson<bool>(json['isMissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'studentId': serializer.toJson<int>(studentId),
      'disciplineId': serializer.toJson<int>(disciplineId),
      'day': serializer.toJson<DateTime>(day),
      'isMissed': serializer.toJson<bool>(isMissed),
    };
  }

  MissedClassesData copyWith(
          {int? id,
          int? studentId,
          int? disciplineId,
          DateTime? day,
          bool? isMissed}) =>
      MissedClassesData(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        disciplineId: disciplineId ?? this.disciplineId,
        day: day ?? this.day,
        isMissed: isMissed ?? this.isMissed,
      );
  MissedClassesData copyWithCompanion(MissedClassesCompanion data) {
    return MissedClassesData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      disciplineId: data.disciplineId.present
          ? data.disciplineId.value
          : this.disciplineId,
      day: data.day.present ? data.day.value : this.day,
      isMissed: data.isMissed.present ? data.isMissed.value : this.isMissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissedClassesData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('day: $day, ')
          ..write('isMissed: $isMissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studentId, disciplineId, day, isMissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissedClassesData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.disciplineId == this.disciplineId &&
          other.day == this.day &&
          other.isMissed == this.isMissed);
}

class MissedClassesCompanion extends UpdateCompanion<MissedClassesData> {
  final Value<int> id;
  final Value<int> studentId;
  final Value<int> disciplineId;
  final Value<DateTime> day;
  final Value<bool> isMissed;
  const MissedClassesCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.disciplineId = const Value.absent(),
    this.day = const Value.absent(),
    this.isMissed = const Value.absent(),
  });
  MissedClassesCompanion.insert({
    this.id = const Value.absent(),
    required int studentId,
    required int disciplineId,
    required DateTime day,
    required bool isMissed,
  })  : studentId = Value(studentId),
        disciplineId = Value(disciplineId),
        day = Value(day),
        isMissed = Value(isMissed);
  static Insertable<MissedClassesData> custom({
    Expression<int>? id,
    Expression<int>? studentId,
    Expression<int>? disciplineId,
    Expression<DateTime>? day,
    Expression<bool>? isMissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (day != null) 'day': day,
      if (isMissed != null) 'is_missed': isMissed,
    });
  }

  MissedClassesCompanion copyWith(
      {Value<int>? id,
      Value<int>? studentId,
      Value<int>? disciplineId,
      Value<DateTime>? day,
      Value<bool>? isMissed}) {
    return MissedClassesCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      disciplineId: disciplineId ?? this.disciplineId,
      day: day ?? this.day,
      isMissed: isMissed ?? this.isMissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<int>(studentId.value);
    }
    if (disciplineId.present) {
      map['discipline_id'] = Variable<int>(disciplineId.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (isMissed.present) {
      map['is_missed'] = Variable<bool>(isMissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissedClassesCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('day: $day, ')
          ..write('isMissed: $isMissed')
          ..write(')'))
        .toString();
  }
}

class $GroupDisciplinesTable extends GroupDisciplines
    with TableInfo<$GroupDisciplinesTable, GroupDiscipline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupDisciplinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES "groups" (id)'));
  static const VerificationMeta _disciplineIdMeta =
      const VerificationMeta('disciplineId');
  @override
  late final GeneratedColumn<int> disciplineId = GeneratedColumn<int>(
      'discipline_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES disciplines (id)'));
  @override
  List<GeneratedColumn> get $columns => [groupId, disciplineId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_disciplines';
  @override
  VerificationContext validateIntegrity(Insertable<GroupDiscipline> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('discipline_id')) {
      context.handle(
          _disciplineIdMeta,
          disciplineId.isAcceptableOrUnknown(
              data['discipline_id']!, _disciplineIdMeta));
    } else if (isInserting) {
      context.missing(_disciplineIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, disciplineId};
  @override
  GroupDiscipline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupDiscipline(
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      disciplineId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discipline_id'])!,
    );
  }

  @override
  $GroupDisciplinesTable createAlias(String alias) {
    return $GroupDisciplinesTable(attachedDatabase, alias);
  }
}

class GroupDiscipline extends DataClass implements Insertable<GroupDiscipline> {
  final int groupId;
  final int disciplineId;
  const GroupDiscipline({required this.groupId, required this.disciplineId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<int>(groupId);
    map['discipline_id'] = Variable<int>(disciplineId);
    return map;
  }

  GroupDisciplinesCompanion toCompanion(bool nullToAbsent) {
    return GroupDisciplinesCompanion(
      groupId: Value(groupId),
      disciplineId: Value(disciplineId),
    );
  }

  factory GroupDiscipline.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupDiscipline(
      groupId: serializer.fromJson<int>(json['groupId']),
      disciplineId: serializer.fromJson<int>(json['disciplineId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<int>(groupId),
      'disciplineId': serializer.toJson<int>(disciplineId),
    };
  }

  GroupDiscipline copyWith({int? groupId, int? disciplineId}) =>
      GroupDiscipline(
        groupId: groupId ?? this.groupId,
        disciplineId: disciplineId ?? this.disciplineId,
      );
  GroupDiscipline copyWithCompanion(GroupDisciplinesCompanion data) {
    return GroupDiscipline(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      disciplineId: data.disciplineId.present
          ? data.disciplineId.value
          : this.disciplineId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupDiscipline(')
          ..write('groupId: $groupId, ')
          ..write('disciplineId: $disciplineId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, disciplineId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupDiscipline &&
          other.groupId == this.groupId &&
          other.disciplineId == this.disciplineId);
}

class GroupDisciplinesCompanion extends UpdateCompanion<GroupDiscipline> {
  final Value<int> groupId;
  final Value<int> disciplineId;
  final Value<int> rowid;
  const GroupDisciplinesCompanion({
    this.groupId = const Value.absent(),
    this.disciplineId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupDisciplinesCompanion.insert({
    required int groupId,
    required int disciplineId,
    this.rowid = const Value.absent(),
  })  : groupId = Value(groupId),
        disciplineId = Value(disciplineId);
  static Insertable<GroupDiscipline> custom({
    Expression<int>? groupId,
    Expression<int>? disciplineId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (disciplineId != null) 'discipline_id': disciplineId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupDisciplinesCompanion copyWith(
      {Value<int>? groupId, Value<int>? disciplineId, Value<int>? rowid}) {
    return GroupDisciplinesCompanion(
      groupId: groupId ?? this.groupId,
      disciplineId: disciplineId ?? this.disciplineId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (disciplineId.present) {
      map['discipline_id'] = Variable<int>(disciplineId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupDisciplinesCompanion(')
          ..write('groupId: $groupId, ')
          ..write('disciplineId: $disciplineId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $DisciplinesTable disciplines = $DisciplinesTable(this);
  late final $MissedClassesTable missedClasses = $MissedClassesTable(this);
  late final $GroupDisciplinesTable groupDisciplines =
      $GroupDisciplinesTable(this);
  late final DisciplineDao disciplineDao = DisciplineDao(this as AppDatabase);
  late final GroupDao groupDao = GroupDao(this as AppDatabase);
  late final MissedClassDao missedClassDao =
      MissedClassDao(this as AppDatabase);
  late final StudentDao studentDao = StudentDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [groups, students, disciplines, missedClasses, groupDisciplines];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudentsTable, List<Student>> _studentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.students,
          aliasName: $_aliasNameGenerator(db.groups.id, db.students.groupId));

  $$StudentsTableProcessedTableManager get studentsRefs {
    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupDisciplinesTable, List<GroupDiscipline>>
      _groupDisciplinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupDisciplines,
              aliasName: $_aliasNameGenerator(
                  db.groups.id, db.groupDisciplines.groupId));

  $$GroupDisciplinesTableProcessedTableManager get groupDisciplinesRefs {
    final manager =
        $$GroupDisciplinesTableTableManager($_db, $_db.groupDisciplines)
            .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_groupDisciplinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> studentsRefs(
      Expression<bool> Function($$StudentsTableFilterComposer f) f) {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupDisciplinesRefs(
      Expression<bool> Function($$GroupDisciplinesTableFilterComposer f) f) {
    final $$GroupDisciplinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupDisciplines,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupDisciplinesTableFilterComposer(
              $db: $db,
              $table: $db.groupDisciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> studentsRefs<T extends Object>(
      Expression<T> Function($$StudentsTableAnnotationComposer a) f) {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> groupDisciplinesRefs<T extends Object>(
      Expression<T> Function($$GroupDisciplinesTableAnnotationComposer a) f) {
    final $$GroupDisciplinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupDisciplines,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupDisciplinesTableAnnotationComposer(
              $db: $db,
              $table: $db.groupDisciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function({bool studentsRefs, bool groupDisciplinesRefs})> {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              GroupsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              GroupsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GroupsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {studentsRefs = false, groupDisciplinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (studentsRefs) db.students,
                if (groupDisciplinesRefs) db.groupDisciplines
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studentsRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, Student>(
                        currentTable: table,
                        referencedTable:
                            $$GroupsTableReferences._studentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0).studentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items),
                  if (groupDisciplinesRefs)
                    await $_getPrefetchedData<Group, $GroupsTable,
                            GroupDiscipline>(
                        currentTable: table,
                        referencedTable: $$GroupsTableReferences
                            ._groupDisciplinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GroupsTableReferences(db, table, p0)
                                .groupDisciplinesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, $$GroupsTableReferences),
    Group,
    PrefetchHooks Function({bool studentsRefs, bool groupDisciplinesRefs})>;
typedef $$StudentsTableCreateCompanionBuilder = StudentsCompanion Function({
  Value<int> id,
  required String fullName,
  required int groupId,
});
typedef $$StudentsTableUpdateCompanionBuilder = StudentsCompanion Function({
  Value<int> id,
  Value<String> fullName,
  Value<int> groupId,
});

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups
      .createAlias($_aliasNameGenerator(db.students.groupId, db.groups.id));

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MissedClassesTable, List<MissedClassesData>>
      _missedClassesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.missedClasses,
              aliasName: $_aliasNameGenerator(
                  db.students.id, db.missedClasses.studentId));

  $$MissedClassesTableProcessedTableManager get missedClassesRefs {
    final manager = $$MissedClassesTableTableManager($_db, $_db.missedClasses)
        .filter((f) => f.studentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_missedClassesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> missedClassesRefs(
      Expression<bool> Function($$MissedClassesTableFilterComposer f) f) {
    final $$MissedClassesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missedClasses,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissedClassesTableFilterComposer(
              $db: $db,
              $table: $db.missedClasses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> missedClassesRefs<T extends Object>(
      Expression<T> Function($$MissedClassesTableAnnotationComposer a) f) {
    final $$MissedClassesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missedClasses,
        getReferencedColumn: (t) => t.studentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissedClassesTableAnnotationComposer(
              $db: $db,
              $table: $db.missedClasses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StudentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, $$StudentsTableReferences),
    Student,
    PrefetchHooks Function({bool groupId, bool missedClassesRefs})> {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<int> groupId = const Value.absent(),
          }) =>
              StudentsCompanion(
            id: id,
            fullName: fullName,
            groupId: groupId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fullName,
            required int groupId,
          }) =>
              StudentsCompanion.insert(
            id: id,
            fullName: fullName,
            groupId: groupId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$StudentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false, missedClassesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (missedClassesRefs) db.missedClasses
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$StudentsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$StudentsTableReferences._groupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missedClassesRefs)
                    await $_getPrefetchedData<Student, $StudentsTable,
                            MissedClassesData>(
                        currentTable: table,
                        referencedTable: $$StudentsTableReferences
                            ._missedClassesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StudentsTableReferences(db, table, p0)
                                .missedClassesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.studentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StudentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StudentsTable,
    Student,
    $$StudentsTableFilterComposer,
    $$StudentsTableOrderingComposer,
    $$StudentsTableAnnotationComposer,
    $$StudentsTableCreateCompanionBuilder,
    $$StudentsTableUpdateCompanionBuilder,
    (Student, $$StudentsTableReferences),
    Student,
    PrefetchHooks Function({bool groupId, bool missedClassesRefs})>;
typedef $$DisciplinesTableCreateCompanionBuilder = DisciplinesCompanion
    Function({
  Value<int> id,
  required String name,
});
typedef $$DisciplinesTableUpdateCompanionBuilder = DisciplinesCompanion
    Function({
  Value<int> id,
  Value<String> name,
});

final class $$DisciplinesTableReferences
    extends BaseReferences<_$AppDatabase, $DisciplinesTable, Discipline> {
  $$DisciplinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissedClassesTable, List<MissedClassesData>>
      _missedClassesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.missedClasses,
              aliasName: $_aliasNameGenerator(
                  db.disciplines.id, db.missedClasses.disciplineId));

  $$MissedClassesTableProcessedTableManager get missedClassesRefs {
    final manager = $$MissedClassesTableTableManager($_db, $_db.missedClasses)
        .filter((f) => f.disciplineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_missedClassesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$GroupDisciplinesTable, List<GroupDiscipline>>
      _groupDisciplinesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.groupDisciplines,
              aliasName: $_aliasNameGenerator(
                  db.disciplines.id, db.groupDisciplines.disciplineId));

  $$GroupDisciplinesTableProcessedTableManager get groupDisciplinesRefs {
    final manager = $$GroupDisciplinesTableTableManager(
            $_db, $_db.groupDisciplines)
        .filter((f) => f.disciplineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_groupDisciplinesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DisciplinesTableFilterComposer
    extends Composer<_$AppDatabase, $DisciplinesTable> {
  $$DisciplinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> missedClassesRefs(
      Expression<bool> Function($$MissedClassesTableFilterComposer f) f) {
    final $$MissedClassesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missedClasses,
        getReferencedColumn: (t) => t.disciplineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissedClassesTableFilterComposer(
              $db: $db,
              $table: $db.missedClasses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> groupDisciplinesRefs(
      Expression<bool> Function($$GroupDisciplinesTableFilterComposer f) f) {
    final $$GroupDisciplinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupDisciplines,
        getReferencedColumn: (t) => t.disciplineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupDisciplinesTableFilterComposer(
              $db: $db,
              $table: $db.groupDisciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DisciplinesTableOrderingComposer
    extends Composer<_$AppDatabase, $DisciplinesTable> {
  $$DisciplinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$DisciplinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DisciplinesTable> {
  $$DisciplinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> missedClassesRefs<T extends Object>(
      Expression<T> Function($$MissedClassesTableAnnotationComposer a) f) {
    final $$MissedClassesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missedClasses,
        getReferencedColumn: (t) => t.disciplineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissedClassesTableAnnotationComposer(
              $db: $db,
              $table: $db.missedClasses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> groupDisciplinesRefs<T extends Object>(
      Expression<T> Function($$GroupDisciplinesTableAnnotationComposer a) f) {
    final $$GroupDisciplinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.groupDisciplines,
        getReferencedColumn: (t) => t.disciplineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupDisciplinesTableAnnotationComposer(
              $db: $db,
              $table: $db.groupDisciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DisciplinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DisciplinesTable,
    Discipline,
    $$DisciplinesTableFilterComposer,
    $$DisciplinesTableOrderingComposer,
    $$DisciplinesTableAnnotationComposer,
    $$DisciplinesTableCreateCompanionBuilder,
    $$DisciplinesTableUpdateCompanionBuilder,
    (Discipline, $$DisciplinesTableReferences),
    Discipline,
    PrefetchHooks Function(
        {bool missedClassesRefs, bool groupDisciplinesRefs})> {
  $$DisciplinesTableTableManager(_$AppDatabase db, $DisciplinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DisciplinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DisciplinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DisciplinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              DisciplinesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              DisciplinesCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DisciplinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {missedClassesRefs = false, groupDisciplinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (missedClassesRefs) db.missedClasses,
                if (groupDisciplinesRefs) db.groupDisciplines
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missedClassesRefs)
                    await $_getPrefetchedData<Discipline, $DisciplinesTable,
                            MissedClassesData>(
                        currentTable: table,
                        referencedTable: $$DisciplinesTableReferences
                            ._missedClassesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DisciplinesTableReferences(db, table, p0)
                                .missedClassesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.disciplineId == item.id),
                        typedResults: items),
                  if (groupDisciplinesRefs)
                    await $_getPrefetchedData<Discipline, $DisciplinesTable,
                            GroupDiscipline>(
                        currentTable: table,
                        referencedTable: $$DisciplinesTableReferences
                            ._groupDisciplinesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DisciplinesTableReferences(db, table, p0)
                                .groupDisciplinesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.disciplineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DisciplinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DisciplinesTable,
    Discipline,
    $$DisciplinesTableFilterComposer,
    $$DisciplinesTableOrderingComposer,
    $$DisciplinesTableAnnotationComposer,
    $$DisciplinesTableCreateCompanionBuilder,
    $$DisciplinesTableUpdateCompanionBuilder,
    (Discipline, $$DisciplinesTableReferences),
    Discipline,
    PrefetchHooks Function(
        {bool missedClassesRefs, bool groupDisciplinesRefs})>;
typedef $$MissedClassesTableCreateCompanionBuilder = MissedClassesCompanion
    Function({
  Value<int> id,
  required int studentId,
  required int disciplineId,
  required DateTime day,
  required bool isMissed,
});
typedef $$MissedClassesTableUpdateCompanionBuilder = MissedClassesCompanion
    Function({
  Value<int> id,
  Value<int> studentId,
  Value<int> disciplineId,
  Value<DateTime> day,
  Value<bool> isMissed,
});

final class $$MissedClassesTableReferences extends BaseReferences<_$AppDatabase,
    $MissedClassesTable, MissedClassesData> {
  $$MissedClassesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias(
          $_aliasNameGenerator(db.missedClasses.studentId, db.students.id));

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<int>('student_id')!;

    final manager = $$StudentsTableTableManager($_db, $_db.students)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DisciplinesTable _disciplineIdTable(_$AppDatabase db) =>
      db.disciplines.createAlias($_aliasNameGenerator(
          db.missedClasses.disciplineId, db.disciplines.id));

  $$DisciplinesTableProcessedTableManager get disciplineId {
    final $_column = $_itemColumn<int>('discipline_id')!;

    final manager = $$DisciplinesTableTableManager($_db, $_db.disciplines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_disciplineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MissedClassesTableFilterComposer
    extends Composer<_$AppDatabase, $MissedClassesTable> {
  $$MissedClassesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMissed => $composableBuilder(
      column: $table.isMissed, builder: (column) => ColumnFilters(column));

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableFilterComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DisciplinesTableFilterComposer get disciplineId {
    final $$DisciplinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.disciplineId,
        referencedTable: $db.disciplines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DisciplinesTableFilterComposer(
              $db: $db,
              $table: $db.disciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissedClassesTableOrderingComposer
    extends Composer<_$AppDatabase, $MissedClassesTable> {
  $$MissedClassesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get day => $composableBuilder(
      column: $table.day, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMissed => $composableBuilder(
      column: $table.isMissed, builder: (column) => ColumnOrderings(column));

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableOrderingComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DisciplinesTableOrderingComposer get disciplineId {
    final $$DisciplinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.disciplineId,
        referencedTable: $db.disciplines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DisciplinesTableOrderingComposer(
              $db: $db,
              $table: $db.disciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissedClassesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissedClassesTable> {
  $$MissedClassesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<bool> get isMissed =>
      $composableBuilder(column: $table.isMissed, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.studentId,
        referencedTable: $db.students,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StudentsTableAnnotationComposer(
              $db: $db,
              $table: $db.students,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DisciplinesTableAnnotationComposer get disciplineId {
    final $$DisciplinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.disciplineId,
        referencedTable: $db.disciplines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DisciplinesTableAnnotationComposer(
              $db: $db,
              $table: $db.disciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissedClassesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MissedClassesTable,
    MissedClassesData,
    $$MissedClassesTableFilterComposer,
    $$MissedClassesTableOrderingComposer,
    $$MissedClassesTableAnnotationComposer,
    $$MissedClassesTableCreateCompanionBuilder,
    $$MissedClassesTableUpdateCompanionBuilder,
    (MissedClassesData, $$MissedClassesTableReferences),
    MissedClassesData,
    PrefetchHooks Function({bool studentId, bool disciplineId})> {
  $$MissedClassesTableTableManager(_$AppDatabase db, $MissedClassesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissedClassesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissedClassesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissedClassesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> studentId = const Value.absent(),
            Value<int> disciplineId = const Value.absent(),
            Value<DateTime> day = const Value.absent(),
            Value<bool> isMissed = const Value.absent(),
          }) =>
              MissedClassesCompanion(
            id: id,
            studentId: studentId,
            disciplineId: disciplineId,
            day: day,
            isMissed: isMissed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int studentId,
            required int disciplineId,
            required DateTime day,
            required bool isMissed,
          }) =>
              MissedClassesCompanion.insert(
            id: id,
            studentId: studentId,
            disciplineId: disciplineId,
            day: day,
            isMissed: isMissed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MissedClassesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({studentId = false, disciplineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (studentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.studentId,
                    referencedTable:
                        $$MissedClassesTableReferences._studentIdTable(db),
                    referencedColumn:
                        $$MissedClassesTableReferences._studentIdTable(db).id,
                  ) as T;
                }
                if (disciplineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.disciplineId,
                    referencedTable:
                        $$MissedClassesTableReferences._disciplineIdTable(db),
                    referencedColumn: $$MissedClassesTableReferences
                        ._disciplineIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MissedClassesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MissedClassesTable,
    MissedClassesData,
    $$MissedClassesTableFilterComposer,
    $$MissedClassesTableOrderingComposer,
    $$MissedClassesTableAnnotationComposer,
    $$MissedClassesTableCreateCompanionBuilder,
    $$MissedClassesTableUpdateCompanionBuilder,
    (MissedClassesData, $$MissedClassesTableReferences),
    MissedClassesData,
    PrefetchHooks Function({bool studentId, bool disciplineId})>;
typedef $$GroupDisciplinesTableCreateCompanionBuilder
    = GroupDisciplinesCompanion Function({
  required int groupId,
  required int disciplineId,
  Value<int> rowid,
});
typedef $$GroupDisciplinesTableUpdateCompanionBuilder
    = GroupDisciplinesCompanion Function({
  Value<int> groupId,
  Value<int> disciplineId,
  Value<int> rowid,
});

final class $$GroupDisciplinesTableReferences extends BaseReferences<
    _$AppDatabase, $GroupDisciplinesTable, GroupDiscipline> {
  $$GroupDisciplinesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
      $_aliasNameGenerator(db.groupDisciplines.groupId, db.groups.id));

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupsTableTableManager($_db, $_db.groups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DisciplinesTable _disciplineIdTable(_$AppDatabase db) =>
      db.disciplines.createAlias($_aliasNameGenerator(
          db.groupDisciplines.disciplineId, db.disciplines.id));

  $$DisciplinesTableProcessedTableManager get disciplineId {
    final $_column = $_itemColumn<int>('discipline_id')!;

    final manager = $$DisciplinesTableTableManager($_db, $_db.disciplines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_disciplineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$GroupDisciplinesTableFilterComposer
    extends Composer<_$AppDatabase, $GroupDisciplinesTable> {
  $$GroupDisciplinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableFilterComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DisciplinesTableFilterComposer get disciplineId {
    final $$DisciplinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.disciplineId,
        referencedTable: $db.disciplines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DisciplinesTableFilterComposer(
              $db: $db,
              $table: $db.disciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupDisciplinesTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupDisciplinesTable> {
  $$GroupDisciplinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableOrderingComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DisciplinesTableOrderingComposer get disciplineId {
    final $$DisciplinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.disciplineId,
        referencedTable: $db.disciplines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DisciplinesTableOrderingComposer(
              $db: $db,
              $table: $db.disciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupDisciplinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupDisciplinesTable> {
  $$GroupDisciplinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.groups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.groups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DisciplinesTableAnnotationComposer get disciplineId {
    final $$DisciplinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.disciplineId,
        referencedTable: $db.disciplines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DisciplinesTableAnnotationComposer(
              $db: $db,
              $table: $db.disciplines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$GroupDisciplinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupDisciplinesTable,
    GroupDiscipline,
    $$GroupDisciplinesTableFilterComposer,
    $$GroupDisciplinesTableOrderingComposer,
    $$GroupDisciplinesTableAnnotationComposer,
    $$GroupDisciplinesTableCreateCompanionBuilder,
    $$GroupDisciplinesTableUpdateCompanionBuilder,
    (GroupDiscipline, $$GroupDisciplinesTableReferences),
    GroupDiscipline,
    PrefetchHooks Function({bool groupId, bool disciplineId})> {
  $$GroupDisciplinesTableTableManager(
      _$AppDatabase db, $GroupDisciplinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupDisciplinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupDisciplinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupDisciplinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> groupId = const Value.absent(),
            Value<int> disciplineId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupDisciplinesCompanion(
            groupId: groupId,
            disciplineId: disciplineId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int groupId,
            required int disciplineId,
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupDisciplinesCompanion.insert(
            groupId: groupId,
            disciplineId: disciplineId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$GroupDisciplinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({groupId = false, disciplineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$GroupDisciplinesTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$GroupDisciplinesTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (disciplineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.disciplineId,
                    referencedTable: $$GroupDisciplinesTableReferences
                        ._disciplineIdTable(db),
                    referencedColumn: $$GroupDisciplinesTableReferences
                        ._disciplineIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$GroupDisciplinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupDisciplinesTable,
    GroupDiscipline,
    $$GroupDisciplinesTableFilterComposer,
    $$GroupDisciplinesTableOrderingComposer,
    $$GroupDisciplinesTableAnnotationComposer,
    $$GroupDisciplinesTableCreateCompanionBuilder,
    $$GroupDisciplinesTableUpdateCompanionBuilder,
    (GroupDiscipline, $$GroupDisciplinesTableReferences),
    GroupDiscipline,
    PrefetchHooks Function({bool groupId, bool disciplineId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$DisciplinesTableTableManager get disciplines =>
      $$DisciplinesTableTableManager(_db, _db.disciplines);
  $$MissedClassesTableTableManager get missedClasses =>
      $$MissedClassesTableTableManager(_db, _db.missedClasses);
  $$GroupDisciplinesTableTableManager get groupDisciplines =>
      $$GroupDisciplinesTableTableManager(_db, _db.groupDisciplines);
}
