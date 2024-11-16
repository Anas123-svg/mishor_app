import 'dart:convert';

class Template {
  final int id;
  final String name;
  final String description;
  final String? reference;
  final String? assessor;
  final String? assessmentDate;
  final List<Field> fields;
  final List<TableData> tables;
  

  Template({
    required this.id,
    required this.name,
    required this.description,
    this.reference,
    this.assessor,
    this.assessmentDate,
    required this.fields,
    required this.tables,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id']??0,
      name: json['name'],
      assessor: json['assessor'],
      assessmentDate: json['date'],
      description: json['description'],
      reference: json['reference'],
      fields: (json['fields'] as List).map((field) => Field.fromJson(field)).toList(),
      tables: (json['tables'] as List).map((table) => TableData.fromJson(table)).toList(),
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'reference': reference,
      'assessor': assessor,
      'date': assessmentDate,
      'Reference': reference,
      'fields': fields.map((field) => field.toJson()).toList(),
      'tables': tables.map((table) => table.toJson()).toList(),
    };
  }

}


class Field {
  final int id;
  final String label;
  final String type;
  dynamic value; // Can be a String or List<String>
  final Map<String, dynamic> attributes;
  final List<String> options;

  Field({
    required this.id,
    required this.label,
    required this.type,
    this.value,
    required this.attributes,
    required this.options,
  });

  // Factory constructor to create Field from JSON
  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] ?? 0,  // Ensure id is an integer, default to 0 if missing
      label: json['label'],
      type: json['type'],
      value: _parseValue(json['value']),
      attributes: json['attributes'],
      options: List<String>.from(json['options'] ?? []),
    );
  }

  // Helper function to handle both String and List<String> types for value
  static dynamic _parseValue(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is int) {
      return value.toString();  // Convert int to String
    } else if (value is String) {
      return value;  // Return as is if it's already a String
    } else if (value is List) {
      if (value is List<String>) {
        return value;
      } else {
        return List<String>.from(value.map((e) => e.toString())); // Convert to a list of Strings
      }
    }
    return null;  // Return null if the value is neither String, int, nor List
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': _serializeValue(value),
      'type': type,
      'attributes': attributes,
      'options': options,
    };
  }

  // Serialize the value to a proper JSON format (String or List<String>)
  static dynamic _serializeValue(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is String) {
      return value;  // If it's a String, return it as is
    } else if (value is int) {
      return value.toString();  // Convert int to String for JSON serialization
    } else if (value is List) {
      return List<String>.from(value.map((e) => e.toString()));  // Convert list to List<String> if necessary
    }
    return null;
  }
}


class TableData {
  final String tableName;
  final List<String> columns;
  final Map<String, Map<String, dynamic>> rows; 

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

    Map<String, dynamic> toJson() {
    return {
      'table_name': tableName,
      'table_data': {
        'columns': columns,
        'rows': rows,
      },
    };
  }

}

