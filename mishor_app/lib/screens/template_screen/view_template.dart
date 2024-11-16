import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mishor_app/models/assessment_model.dart';
import 'package:mishor_app/models/template.dart';
import 'package:mishor_app/services/template_service.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class ViewTemplate extends StatefulWidget {
  final int templateID;
  const ViewTemplate(this.templateID);

  @override
  _ViewTemplateScreenState createState() => _ViewTemplateScreenState();
}

class _ViewTemplateScreenState extends State<ViewTemplate> {
  late Future<Assessment2> _assessmentFuture;
  final Map<int, dynamic> _fieldValues = {};
  final Map<String, Map<String, dynamic>> _tableRowValues = {};
  final List<String> _uploadedImageUrls = [];
  TextEditingController _assessorController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  bool isAllFilled = true;

  final String cloudName = 'dchubllrz';
  final String uploadPreset = 'nmafnbii';

  @override
  void initState() {
    super.initState();
    // Fetch template data on initialization
    _assessmentFuture = TemplateService().fetchTemplateData(widget.templateID);
  }

  @override
  void dispose() {
    _assessorController.dispose();
    _dateController.dispose();
    super.dispose();
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
  String? value = field.value;  
  print('Field Value: $value');
  
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
    controller: TextEditingController(
      text: value ?? '',
    ),
    readOnly: true,
  );
}

Widget _buildNumberField(Field field) {

  String? value = field.value;  
  print('Field Value: $value');


  return TextField(
    decoration: InputDecoration(
      labelText: field.label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
        controller: TextEditingController(
      text: value ?? '',
    ),
    readOnly: true,
  );
}


Widget _buildTextArea(Field field) {
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] = field.attributes['default'] ?? '';
  }

  String? value = field.value;

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
    controller: TextEditingController(text: value ?? ''),
    readOnly: true,  // Make the field read-only
    maxLines: 5,  // Allows the text area to expand
  );
}


Widget _buildCheckboxField(Field field) {
  // Ensure the value is populated correctly from the field's attributes or default value
  if (!_fieldValues.containsKey(field.id)) {
    // Check if field.value is a string or a list, and handle accordingly
    dynamic value = field.value;
    if (value is String) {
      // If it's a string, check if it's a valid JSON array
      try {
        value = jsonDecode(value) as List<dynamic>;
      } catch (e) {
        // If it's not a valid JSON array, default to an empty list
        value = [];
      }
    }
    // Ensure value is always a List<String>
    _fieldValues[field.id] = List<String>.from(value ?? []);
  }

  // Retrieve the list of selected options for the checkbox field (ensure it's a List<String>)
  List<String> selectedOptions = List<String>.from(_fieldValues[field.id] ?? []);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Display the label and required icon (if applicable)
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
      // Map each option to a checkbox list item
      ...field.options.map((option) {
        // Check if the option is selected (i.e., present in the selected options list)
        bool isSelected = selectedOptions.contains(option);

        return CheckboxListTile(
          title: Text(option),
          value: isSelected,
          onChanged: null,  // Disable interaction (read-only)
          activeColor: Colors.blueAccent,
        );
      }).toList(),
      // Display a required field validation message if applicable
      if (field.attributes['required'] == true)
        Builder(
          builder: (context) {
            bool isValid = selectedOptions.isNotEmpty;
            if (!isValid) {
              return Text(
                'This field is required.',
                style: TextStyle(color: Colors.red),
              );
            }
            return SizedBox.shrink();  // No error message when valid
          },
        ),
    ],
  );
}


Widget _buildSelectField(Field field) {
  // Ensure the value is populated correctly from the field's attributes or default value
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] = field.attributes['required'] == true ? null : field.options.isNotEmpty ? field.options[0] : null;
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
        value:field.value, 
        items: field.options
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: null,

      ),
    ],
  );
}



Widget _buildRadioField(Field field) {
  if (!_fieldValues.containsKey(field.id)) {
    _fieldValues[field.id] =
        field.attributes['required'] == true ? null : field.options.isNotEmpty ? field.options[0] : null;
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
          groupValue: field.value, 
          onChanged: null,  
          activeColor: Colors.blueAccent,
        );
      }).toList(),
    ],
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
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 12,
            headingRowHeight: 56,
            dataRowHeight: 56,
            showCheckboxColumn: false,
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
                    Text(entry.key),
                  ),
                  ...entry.value.entries.map((cell) {
                    return DataCell(
                      TextFormField(
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
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
            border: TableBorder(
              horizontalInside: BorderSide(
                  color: Colors.grey, width: 0.5), // Line between rows
              verticalInside: BorderSide(
                  color: Colors.grey, width: 0.5), // Line between columns
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
        ),
      ],
    );
  }


// Function to handle site_images
Widget _buildSiteImages(List<SiteImage> siteImages) {
  if (siteImages.isEmpty) {
    return Text("No site images available.");
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Site Images",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: siteImages.map((siteImage) {
          return GestureDetector(
            onTap: () {
              // You can handle the tap if you want to show the image in full screen or navigate elsewhere
              print('Image tapped: ${siteImage.siteImage}');
            },
            child: Image.network(
              siteImage.siteImage, 
              width: 100, 
              height: 100,
              fit: BoxFit.cover,
            ),
          );
        }).toList(),
      ),
    ],
  );
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Template Details',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
          final assessment = snapshot.data!; // Use the Assessment2 object here
          final template = assessment.template; // Template is still part of the Assessment2 model

          // Set controller text fields with data
          _assessorController.text = template.assessor!;
          _dateController.text = template.assessmentDate!;

          // Populate images URLs (from assessment, not template)
          if (assessment.siteImages != null) {
            _uploadedImageUrls.clear();
            for (var image in assessment.siteImages!) {
              _uploadedImageUrls.add(image.siteImage);
            }
          }

          // Handle site_images (if any)
          final siteImages = assessment.siteImages; // List of SiteImage objects

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  template.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  template.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                // Read-only TextFields for Reference, Assessor, and Date
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
                  decoration: InputDecoration(
                    labelText: 'Assessor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: _assessorController,
                  readOnly: true,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: _dateController,
                  readOnly: true,
                ),
                SizedBox(height: 16),
                Text(
                  "Assessment Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Dynamically create inputs for fields
                ...template.fields.map((field) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buildFieldInput(field),
                    )),
                ...template.tables.map((table) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _buildTableEditor(table),
                    )),
                SizedBox(height: 16),
                // Display Site Images
                _buildSiteImages(siteImages), // Add this function to display site images
                SizedBox(height: 16),
                // Display uploaded images
                Wrap(
                  spacing: 8,
                  children: _uploadedImageUrls
                      .map((url) => Image.network(url, width: 100, height: 100))
                      .toList(),
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