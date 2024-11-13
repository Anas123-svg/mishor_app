import 'package:flutter/material.dart';
import 'package:mishor_app/models/assessment_model.dart';
import 'package:mishor_app/models/template.dart';
import 'package:mishor_app/services/template_service.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class TemplateScreen extends StatefulWidget {
  final int templateID;
  const TemplateScreen(this.templateID);

  @override
  _TemplateScreenState createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  late Future<Assessment2> _assessmentFuture;
  final Map<int, dynamic> _fieldValues = {};
  final Map<String, Map<String, dynamic>> _tableRowValues = {};

  @override
  void initState() {
    super.initState();
    _assessmentFuture = TemplateService().fetchTemplateData(widget.templateID);
  }

  Widget _buildFieldInput(Field field) {
    switch (field.type) {
      case 'text':
        return _buildTextField(field);
      case 'number':
        return _buildNumberField(field);
      case 'textarea':
        return _buildTextArea(field);
      case 'checkbox':
        return _buildCheckboxField(field);
      case 'select':
        return _buildSelectField(field);
      case 'radio':
        return _buildRadioField(field); 
      default:
        return SizedBox();
    }
  }

  Widget _buildTextField(Field field) {
    return TextField(
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.attributes['placeholder'] ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) => _fieldValues[field.id] = value,
    );
  }

  Widget _buildNumberField(Field field) {
    return TextField(
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.attributes['placeholder'] ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) => _fieldValues[field.id] = int.tryParse(value),
    );
  }

  Widget _buildTextArea(Field field) {
    return TextField(
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.attributes['placeholder'] ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLines: null,
      onChanged: (value) => _fieldValues[field.id] = value,
    );
  }

  Widget _buildCheckboxField(Field field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...field.options.map((option) {
          return CheckboxListTile(
            title: Text(option),
            value: _fieldValues[field.id]?[option] ?? false,
            onChanged: (value) {
              setState(() {
                _fieldValues[field.id] = _fieldValues[field.id] ?? {};
                _fieldValues[field.id][option] = value;
              });
            },
            activeColor: Colors.blueAccent,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRadioField(Field field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...field.options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _fieldValues[field.id],
            onChanged: (value) {
              setState(() {
                _fieldValues[field.id] = value;
              });
            },
            activeColor: Colors.blueAccent,
          );
        }).toList(),
      ],
    );
  }
  Widget _buildSelectField(Field field) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: field.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: _fieldValues[field.id],
      items: field.options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: (value) => setState(() => _fieldValues[field.id] = value),
    );
  }


Widget _buildTableEditor(TableData table) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        table.tableName,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 12),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Makes the table horizontally scrollable
        child: DataTable(
          columnSpacing: 12, // Adds spacing between columns
          headingRowHeight: 56,
          dataRowHeight: 56,
          showCheckboxColumn: false, // Hides the default checkbox column
          columns: [
            DataColumn(
              label: Text(
                'Row',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            ...table.columns.map((col) => DataColumn(
                  label: Text(
                    col,
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ))
          ],
          rows: table.rows.entries.map((entry) {
            return DataRow(
              cells: [
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1), // Adds a border around each cell
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(entry.key),
                  ),
                ),
                ...entry.value.entries.map((cell) {
                  return DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1), // Adds a border around each cell
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        initialValue: cell.value.toString(),
                        onChanged: (value) {
                          setState(() {
                            _tableRowValues[entry.key] ??= {};
                            _tableRowValues[entry.key]![cell.key] = value;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          border: InputBorder.none, // Removes the default TextFormField border
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ),
      ),
    ],
  );
}

  void _submitData() async {
    // Prepare the data to submit
    final Map<String, dynamic> submissionData = {
      'fields': _fieldValues,
      'tables': _tableRowValues,
    };

    try {
      await TemplateService().updateTemplateData(widget.templateID, submissionData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data submitted successfully')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Template Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<Assessment2>(
        future: _assessmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final template = snapshot.data!.template;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(template.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  SizedBox(height: 8),
                  Text(template.description, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  SizedBox(height: 16),
                  ...template.fields.map((field) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildFieldInput(field),
                      )),
                  ...template.tables.map((table) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: _buildTableEditor(table),
                      )),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.Col_White)),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
