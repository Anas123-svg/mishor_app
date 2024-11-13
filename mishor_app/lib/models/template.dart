class Template {
  final int id;
  final String name;
  final String description;
  final String? reference;
  final List<Field> fields;
  final List<TableData> tables;

  Template({
    required this.id,
    required this.name,
    required this.description,
    this.reference,
    required this.fields,
    required this.tables,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id']??0,
      name: json['name'],
      description: json['description'],
      reference: json['Reference'],
      fields: (json['fields'] as List).map((field) => Field.fromJson(field)).toList(),
      tables: (json['tables'] as List).map((table) => TableData.fromJson(table)).toList(),
    );
  }
}

class Field {
  final int id;
  final String label;
  final String type;
  final Map<String, dynamic> attributes;
  final List<String> options;

  Field({
    required this.id,
    required this.label,
    required this.type,
    required this.attributes,
    required this.options,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id']??0,
      label: json['label'],
      type: json['type'],
      attributes: json['attributes'],
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

class TableData {
  final String tableName;
  final List<String> columns;
  final Map<String, Map<String, dynamic>> rows; // Allow dynamic values in rows

  TableData({
    required this.tableName,
    required this.columns,
    required this.rows,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      tableName: json['table_name'] ?? '',
      columns: List<String>.from(json['table_data']['columns'] ?? []),
      rows: (json['table_data']['rows'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(key, Map<String, dynamic>.from(value))),
    );
  }
}
 

