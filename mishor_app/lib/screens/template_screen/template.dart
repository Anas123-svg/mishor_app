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
  List<String> Columns = [];
  final List<String> _uploadedImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  TextEditingController _assessorController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  bool isAllFilled = true;
  String? tableName; 
  final String cloudName = 'dchubllrz';
  final String uploadPreset = 'nmafnbii';

  @override
  void initState() {
    super.initState();
    _assessmentFuture = TemplateService().fetchTemplateData(widget.templateID);
    _assessorController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _assessorController.dispose();
    _dateController.dispose();
    super.dispose();
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
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] = field.attributes['required'] == true ? null : '';
  }

  return TextField(
    decoration: InputDecoration(
      labelText: field.label,
      hintText: field.attributes['placeholder'] ?? '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: field.attributes['required'] == true
          ? Icon(Icons.star, color: Colors.red)
          : null,
    ),
    onChanged: (value) {
      setState(() {
        _fieldValues[field.id] = value.isNotEmpty ? value : null;
        isAllFilled = _fieldValues.values.every((val) => val != null);
      });
    },
  );
}

Widget _buildNumberField(Field field) {
  if (!_fieldValues.containsKey(field.id)) {
    print(field.id);
    _fieldValues[field.id] =
        field.attributes['required'] == true ? null : false;
  }

  return TextField(
    decoration: InputDecoration(
      labelText: field.label,
      hintText: field.attributes['placeholder'] ?? '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: field.attributes['required'] == true
          ? Icon(Icons.star, color: Colors.red)
          : null,
    ),
    keyboardType: TextInputType.number,
    onChanged: (value) {
      int? parsedValue = int.tryParse(value);
      print (value);  
      setState(() {
        _fieldValues[field.id] = parsedValue ??
            (field.attributes['required'] == true ? null : false);
      });

      print('Updated _fieldValues: $_fieldValues');
    },
  );
}

// Helper method to validate all fields
bool _validateAllFields() {
  bool isValid = true;

  _fieldValues.forEach((key, value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      isValid = false;
    }
  });

  return isValid;
}


Widget _buildTextArea(Field field) {
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] = field.attributes['required'] == true ? null : '';
  }

  return TextField(
    decoration: InputDecoration(
      labelText: field.label,
      hintText: field.attributes['placeholder'] ?? '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: field.attributes['required'] == true
          ? Icon(Icons.star, color: Colors.red)
          : null,
    ),
    maxLines: null,
    onChanged: (value) {
      setState(() {
        if (field.attributes['required'] == true && value.isEmpty) {
          _fieldValues[field.id] = null;
        } else {
          _fieldValues[field.id] = int.tryParse(value) ?? value;
        }
      });
    },
  );
}


Widget _buildCheckboxField(Field field) {
  // Ensure _fieldValues for the current field is initialized as a list of strings
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] = field.attributes['required'] == true ? [] : [];
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            field.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (field.attributes['required'] == true)
            Icon(Icons.star, color: Colors.red),
        ],
      ),
      ...field.options.map((option) {
        bool isSelected = _fieldValues[field.id]?.contains(option) ?? false;

        return CheckboxListTile(
          title: Text(option),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              // Initialize the list if it's null
              _fieldValues[field.id] = _fieldValues[field.id] ?? [];

              if (value == true) {
                // Add option to the list when selected
                _fieldValues[field.id]!.add(option);
              } else {
                // Remove option from the list when deselected
                _fieldValues[field.id]!.remove(option);
              }

              // Remove the field entry if it's empty (optional behavior)
              if (_fieldValues[field.id]!.isEmpty) {
                _fieldValues.remove(field.id);
              }
            });
          },
          activeColor: Colors.blueAccent,
        );
      }).toList(),
      if (field.attributes['required'] == true)
        Builder(
          builder: (context) {
            bool isValid = _fieldValues[field.id]?.isNotEmpty ?? false;
            if (!isValid) {
              return Text(
                'This field is required.',
                style: TextStyle(color: Colors.red),
              );
            }
            return SizedBox.shrink();
          },
        ),
    ],
  );
}

  Widget _buildRadioField(Field field) {
                  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] =
        field.attributes['required'] == true ? null : '';
  }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              field.label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (field.attributes['required'] == true)
              Icon(Icons.star, color: Colors.red), 
          ],
        ),
        ...field.options.map((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _fieldValues[field.id],
            onChanged: (value) {
              setState(() {
                _fieldValues[field.id] = value;
            _fieldValues[field.id] = value ??(field.attributes['required'] == true ? null : '');

              });
            },
            activeColor: Colors.blueAccent,
          );
        }).toList(),
        if (field.attributes['required'] == true)
          Builder(
            builder: (context) {
            bool isValid = _fieldValues[field.id] != null && _fieldValues[field.id] != '';
              if (!isValid) {
                return Text(
                  'This field is required.',
                  style: TextStyle(color: Colors.red),
                );
              }
              return SizedBox.shrink(); 
            },
          ),
      ],
    );
  }

Widget _buildSelectField(Field field) {
  // Initialize _fieldValues[field.id] as null or an empty string for non-required fields
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] = field.attributes['required'] == true ? null : '';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            field.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (field.attributes['required'] == true)
            Icon(Icons.star, color: Colors.red),
        ],
      ),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: field.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        value: _fieldValues[field.id],
        items: field.options
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) => setState(() {
          // Set the selected value or null if required
          _fieldValues[field.id] = value ?? (field.attributes['required'] == true ? null : '');
        }),
      ),
      // Optional: Add validation message if required
      if (field.attributes['required'] == true)
        Builder(
          builder: (context) {
            bool isValid = _fieldValues[field.id] != null && _fieldValues[field.id] != '';
            if (!isValid) {
              return Text(
                'This field is required.',
                style: TextStyle(color: Colors.red),
              );
            }
            return SizedBox.shrink(); // Empty widget when valid
          },
        ),
    ],
  );
}
List <TableData> tables=[];

Widget _buildTableEditor(TableData table) {
  // Find the table in the list, or add it if it's a new table
  final tableIndex = tables.indexWhere((t) => t.tableId == table.tableId);
  if (tableIndex == -1) {
    tables.add(table);  // If table doesn't exist, add it
  } else {
    tables[tableIndex] = table;  // If table exists, update it
  }

  tableName = table.tableName;
  Columns = table.columns;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        table.tableName,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 12),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 45,
          headingRowHeight: 56,
          dataRowHeight: 56,
          showCheckboxColumn: false,
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
                DataCell(Text(entry.key)),
                ...entry.value.entries.map((cell) {
                  return DataCell(
                    TextFormField(
                      initialValue: cell.value.toString(),
                      onChanged: (value) {
                        setState(() {
                          table.rows[entry.key]?[cell.key] = value; // Update table row
                          tables[tableIndex] = table;  // Update table in tables list
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
            verticalInside: BorderSide(color: Colors.grey, width: 0.5),
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
      ),
    ],
  );
}


  void _submitData() async {

      if (!_validateAllFields()) {
    setState(() {
      isAllFilled = false;
    });
    Get.snackbar(
      "Incomplete Form",
      "Please fill all required fields.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }
  print("tables data   ${tables}");

    
    final assessmentData = {
      "complete_by_user": 1,
      "status": "pending",
      "assessment": {
        //"name": "Title",
        if (_assessorController.text.isNotEmpty)
          "assessor": _assessorController.text,
        if (_dateController.text.isNotEmpty) "date": _dateController.text,
        "description": "This is the description of template",
        "fields": _fieldValues.entries.map((entry) {
          print(entry.value);
          print(entry.key);
          return {
            "id": entry.key,
            "value": entry.value,
          };
        }).toList(),
      "tables": tables.map((table) => table.toJson()).toList(), // Send tables as JSON
        //[
          //{
           // "table_name": tableName,
         //   "table_data": {
              //"columns": Columns,
              //"rows": _tableRowValues
            //}
          //}
        //],
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
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Reference',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    controller: TextEditingController(
                      text: template.reference,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _assessorController,
                    decoration: InputDecoration(
                      labelText: "Assessor",
                      hintText: "Enter Assessor Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Date",
                      hintText: "Enter Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Assessment Details",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
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
