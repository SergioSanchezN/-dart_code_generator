String generateTestModelCode(String input, String className) {
  final propertiesRegex = RegExp(r'this\.(\w+)', multiLine: true);
  final properties = propertiesRegex.allMatches(input).map((match) => match.group(1));

  final mapFromJson = StringBuffer('final Map<String, dynamic> json = {\n');
  final validationFromJson = StringBuffer('final response = $className.fromJson(json);\n\n');

  final objToJson = StringBuffer('final model = $className(\n');
  final validationToJson = StringBuffer('final json = model.toJson();\n');

  for (final propertyName in properties) {
    mapFromJson.writeln('    "$propertyName": "$propertyName",');
    validationFromJson.writeln('expect(response.$propertyName, "$propertyName");');
    objToJson.writeln('$propertyName: "$propertyName",');
    validationToJson.writeln('expect(json["$propertyName"], "$propertyName");');
  }

  mapFromJson.writeln('  };');
  objToJson.writeln('  );');

  return '''
    void main() {
      group('$className', () {
        test('fromJson() should create a $className from a map', () {
          ${mapFromJson.toString()}

          ${validationFromJson.toString()}
        });

        test('toJson() should convert a $className to a map', () {
          ${objToJson.toString()}

          ${validationToJson.toString()}
        });

      });
    }
''';
}

void main() {
  /// Nombre del modelo
  const className = 'ValidateYourIdentityStepTemplate';

  /// Parametros del constructor
  const input = '''
    this.step,
    this.title,
    this.instruction,
    this.description,
    this.continueBtnTitle,
    this.animation
     ''';
  final code = generateTestModelCode(input, className);
  print(code);
}
