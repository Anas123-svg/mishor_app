import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mishor_app/models/assessment_model.dart';
import 'package:mishor_app/models/template.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/services/template_service.dart';
import 'package:mishor_app/utilities/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  final List<String> _uploadedImageUrls = [];
  final ImagePicker _picker = ImagePicker();

  final String cloudName = 'dchubllrz';
  final String uploadPreset = 'nmafnbii';

  @override
  void initState() {
    super.initState();
    _assessmentFuture = TemplateService().fetchTemplateData(widget.templateID);
  }

  Future<void> _pickImageAndUpload() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await _uploadImageToCloudinary(File(pickedImage.path));
    }
  }

  Future<void> _uploadImageToCloudinary(File imageFile) async {
    try {
      // Cloudinary upload URL
      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        setState(() {
          final imageUrl = jsonMap['secure_url'];
          _uploadedImageUrls.add(imageUrl);
        });
      } else {
        print(
            'Failed to upload image: ${response.statusCode} and ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
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
      Text(
        field.label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      ...field.options.map((option) {
        bool isSelected = _fieldValues[field.id]?.contains(option) ?? false;
        
        return CheckboxListTile(
          title: Text(option),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              _fieldValues[field.id] = _fieldValues[field.id] ?? [];

              if (value == true) {
                _fieldValues[field.id]!.add(option);
              } else {
                _fieldValues[field.id]!.remove(option);
              }

              if (_fieldValues[field.id]!.isEmpty) {
                _fieldValues.remove(field.id);
              }
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
        Text(field.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          scrollDirection:
              Axis.horizontal, // Makes the table horizontally scrollable
          child: DataTable(
            columnSpacing: 12, // Adds spacing between columns
            headingRowHeight: 56,
            dataRowHeight: 56,
            showCheckboxColumn: false, // Hides the default checkbox column
            columns: [
              DataColumn(
                label: Text(
                  'Row',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              ...table.columns.map((col) => DataColumn(
                    label: Text(
                      col,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ))
            ],
            rows: table.rows.entries.map((entry) {
              return DataRow(
                cells: [
                  DataCell(
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width: 1), // Adds a border around each cell
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(entry.key),
                    ),
                  ),
                  ...entry.value.entries.map((cell) {
                    return DataCell(
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1), // Adds a border around each cell
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            border: InputBorder
                                .none, // Removes the default TextFormField border
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
    final assessmentData = {
      "complete_by_user": 1,
      "assessment": {
        "name": "Title",
        "description": "This is the description of template",
        "fields": _fieldValues.entries.map((entry) {
          return {
            "id": entry.key,
            "value": entry.value,
          };
        }).toList(),
        "tables": [
          {
            "table_name": "Updated Feedback Details",
            "table_data": {
              "columns": ["Feedback ID", "Submitted By", "Date"],
              "rows": _tableRowValues
            }
          }
        ],
        "site_images": _uploadedImageUrls.map((imageUrl) {
          return {
            "site_image": imageUrl,
            "is_flagged": false,
          };
        }).toList(),
      }
    };

    try {
      await TemplateService()
          .updateTemplateData(widget.templateID, assessmentData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submitted successfully')));
      Get.offNamed(AppRoutes.bottomNavBar);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error submitting data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Template Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Text(template.name,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  SizedBox(height: 8),
                  Text(template.description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
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

                  // Image upload section
                  Text("Upload Images",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _uploadedImageUrls
                        .map((url) =>
                            Image.network(url, width: 100, height: 100))
                        .toList(),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _pickImageAndUpload,
                    child: Text("Pick and Upload Image"),
                  ),

                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Submit',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.Col_White)),
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
