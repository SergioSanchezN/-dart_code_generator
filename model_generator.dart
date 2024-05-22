String generateModelCode(String input, String className) {
  final propertiesRegex = RegExp(r'this\.(\w+)', multiLine: true);
  final properties = propertiesRegex.allMatches(input).map((match) => match.group(1));

  final fromJson = StringBuffer('$className.fromJson(Map<String, dynamic> json) {\n');
  final toJson =
      StringBuffer('Map<String, dynamic> toJson() {\n  final Map<String, dynamic> data = <String, dynamic>{};\n');

  for (final propertyName in properties) {
    fromJson.writeln('    $propertyName = json["$propertyName"];');
    toJson.writeln('  data["$propertyName"] = $propertyName;');
  }

  fromJson.writeln('  }');
  toJson.writeln('  return data;\n}\n');

  return fromJson.toString() + toJson.toString();
}

void main() {
  /// Nombre del modelo
  final className = 'UpdateDeviceModel';

  /// Parametros del constructor
  final input = '''this.docType,
    this.docNumber,
    this.password,
    this.deviceId,
    this.location,
    this.typeDevice,''';
  final code = generateModelCode(input, className);
  print(code);
}
