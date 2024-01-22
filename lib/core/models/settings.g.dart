// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 0;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      useBiometricAuthentication: fields[0] as bool,
      skipIntroduction: fields[1] as bool,
      didBiometricAuthentication: fields[3] as bool,
      enableReminder: fields[4] as bool,
      reminderTime: fields[2] as TimeOfDay?,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.useBiometricAuthentication)
      ..writeByte(3)
      ..write(obj.didBiometricAuthentication)
      ..writeByte(1)
      ..write(obj.skipIntroduction)
      ..writeByte(4)
      ..write(obj.enableReminder)
      ..writeByte(2)
      ..write(obj.reminderTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
