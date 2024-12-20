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
  String tableName = '';
  List<String> Columns = [];
  final List<String> _uploadedImageUrls = [];
  TextEditingController _assessorController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  bool isAllFilled = true;

  final String cloudName = 'dchubllrz';
  final String uploadPreset = 'nmafnbii';

  @override
  void initState() {
    super.initState();
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
  tableName = table.tableName;
  Columns = table.columns;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Table Title
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          table.tableName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      const SizedBox(height: 12),
      
      // Table Container with rounded corners
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columnSpacing: 16,
              headingRowHeight: 60,
              dataRowHeight: 60,
              showCheckboxColumn: false,
              columns: [
                const DataColumn(
                  label: Text(
                    'Row',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                ...table.columns.map(
                  (col) => DataColumn(
                    label: Text(
                      col,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              rows: table.rows.entries.map((entry) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        entry.key,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    ...entry.value.entries.map((cell) {
                      return DataCell(
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            initialValue: cell.value,
                            onChanged: (newValue) {
                              setState(() {
                                if (table.rows[entry.key] == null) {
                                  table.rows[entry.key] = {};
                                }
                                table.rows[entry.key]![cell.key] = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 0.8,
                                ),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            readOnly: true,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.grey.shade300, width: 0.8),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


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
      // Wrap the Row in a SingleChildScrollView to make it scrollable horizontally
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: siteImages.map((siteImage) {
            return GestureDetector(
              onTap: () {
                // Show the tapped image in a popup
                _showImagePopup(context, siteImage.siteImage);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      siteImage.siteImage,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

void _showImagePopup(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners for the dialog
        ),
        backgroundColor: Colors.white, 
// White background
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85, // Adjusted width for compact view
                maxHeight: MediaQuery.of(context).size.height * 0.4, // Reduced height for a smaller background
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity, // Ensures the image fits within the container
                height: double.infinity, // Ensures the image fits within the container
              ),
            ),
          ),
        ),
      );
    },
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title:
            Center(child: Text('Assessment Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24))),
            centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
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
            for (var image in assessment.siteImages) {
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
                //Row(
                  //children: [
                    //Wrap(
                      //spacing: 8,
                      //children: _uploadedImageUrls
                        //  .map((url) => Image.network(url, width: 100, height: 100))
                          //.toList(),
                   // )//,
                  //],
                //),
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