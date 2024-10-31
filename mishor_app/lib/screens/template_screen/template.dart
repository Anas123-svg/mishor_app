import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mishor_app/routes/app_routes.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class TemplateScreen extends StatefulWidget {
  @override
  _TemplateScreenState createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final _formKey = GlobalKey<FormState>();

  String? activity;
  String? reference;
  String? taskDescription;
  String? assessor;
  DateTime? date;
  String? hazardLikelihood;
  String? hazardSeverity;
  String? riskLevel;
  List<String> peopleAtRisk = [];
  String? controlMeasures;
  String? selectedRiskLevel;
  String? acknowledgementName;
  DateTime? acknowledgementDate;

  List<Map<String, dynamic>> tableData = [
    {
      "Hazard": "Falling debris",
      "Likelihood": false,
      "Severity": false,
      "Risk Level": false
    },
    {
      "Hazard": "Electrical hazard",
      "Likelihood": false,
      "Severity": false,
      "Risk Level": false
    }
  ];

  final List<String> riskLevelOptions = [
    "Very Low - Safe to proceed with standard controls",
    "Low - Safe with additional controls",
    "Medium - Proceed with caution under additional controls",
    "High - Proceed with caution under further supervised controls",
    "Very High - Unsafe, DO NOT proceed; further action required",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      // backgroundColor: AppColors.Col_White,
      //  title: Text('Assessment', style: TextStyle(fontSize: 20.sp, color: AppColors.primary)),
      //),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Card(
                    color: Colors.white,
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Assessment - Strip Out',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '1. Read each step carefully.\n'
                            '2. Follow the instructions as provided.\n'
                            '3. Refer to troubleshooting section for issues.\n'
                            '4. Prepare all required materials.\n'
                            '5. Contact support if assistance is needed.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        label: 'Activity',
                        onChanged: (value) => activity = value,
                        required: true,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: buildTextField(
                        label: 'Reference',
                        onChanged: (value) => reference = value,
                        required: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                buildTextField(
                  label: 'Task Description',
                  onChanged: (value) => taskDescription = value,
                  required: true,
                  //   isMultiLine: true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        label: 'Assessor',
                        onChanged: (value) => assessor = value,
                        required: false,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: buildDateField(
                          label: 'Date', onChanged: (value) => date = value),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 20.h),
                buildSectionTitle('Data to Fill'),
                buildDataTable(),
                SizedBox(height: 20.h),
                buildRadioGroup(
                  label: 'Hazard Likelihood',
                  value: hazardLikelihood,
                  options: ["L", "M", "H"],
                  onChanged: (value) =>
                      setState(() => hazardLikelihood = value),
                ),
                buildRadioGroup(
                  label: 'Hazard Severity',
                  value: hazardSeverity,
                  options: ["L", "M", "H"],
                  onChanged: (value) => setState(() => hazardSeverity = value),
                ),
                buildRadioGroup(
                  label: 'Risk Level',
                  value: riskLevel,
                  options: ["L", "M", "H"],
                  onChanged: (value) => setState(() => riskLevel = value),
                ),
                buildCheckboxGroup(
                  label: 'People at Risk',
                  options: [
                    "Workers",
                    "Adjacent Workers",
                    "Site Wide Personnel",
                    "Occupants",
                    "Visitors",
                    "Members of Public",
                  ],
                  selectedValues: peopleAtRisk,
                  onChanged: (value, isSelected) {
                    setState(() {
                      isSelected
                          ? peopleAtRisk.add(value)
                          : peopleAtRisk.remove(value);
                    });
                  },
                ),
                buildTextField(
                  label: 'Control Measures',
                  onChanged: (value) => controlMeasures = value,
                  required: true,
                  isMultiLine: true,
                ),
                buildDropdownField(
                  label: 'Risk Level',
                  value: selectedRiskLevel,
                  options: riskLevelOptions,
                  onChanged: (value) =>
                      setState(() => selectedRiskLevel = value),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Form submitted successfully')),
                             // Get.toNamed(AppRoutes.bottomNavBar);
                        );
                            Get.toNamed(AppRoutes.bottomNavBar);

                      }
                    },
                    child:
                        Text('Submit', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87),
      ),
    );
  }

  Widget buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
            (states) => AppColors.primary.withOpacity(0.2)),
        columns: const [
          DataColumn(label: Text('Hazard')),
          DataColumn(label: Text('Likelihood')),
          DataColumn(label: Text('Severity')),
          DataColumn(label: Text('Risk Level')),
        ],
        rows: tableData.map((data) {
          return DataRow(cells: [
            DataCell(Text(data['Hazard'])),
            DataCell(
              Checkbox(
                value: data['Likelihood'],
                onChanged: (bool? value) {
                  setState(() {
                    data['Likelihood'] = value ?? false;
                  });
                },
              ),
            ),
            DataCell(
              Checkbox(
                value: data['Severity'],
                onChanged: (bool? value) {
                  setState(() {
                    data['Severity'] = value ?? false;
                  });
                },
              ),
            ),
            DataCell(
              Checkbox(
                value: data['Risk Level'],
                onChanged: (bool? value) {
                  setState(() {
                    data['Risk Level'] = value ?? false;
                  });
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required ValueChanged<String?> onChanged,
    bool required = false,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        validator: required
            ? (value) =>
                value == null || value.isEmpty ? 'This field is required' : null
            : null,
        maxLines: isMultiLine ? 4 : 1,
      ),
    );
  }

  Widget buildDateField({
    required String label,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label),
          SizedBox(width: 20.w),
          TextButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  date = pickedDate;
                });
                onChanged(pickedDate);
              }
            },
            child: Text(
              date != null
                  ? '${date!.day}/${date!.month}/${date!.year}'
                  : 'Pick Date',
              style: TextStyle(color: AppColors.primary, fontSize: 
              16.sp, fontWeight: FontWeight.w200),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildRadioGroup({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      // Use a Column to contain the Row and Divider
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use a fixed width for the label or adjust its sizing
            Container(
              width: 50.w,
              child: Text(label,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400)),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: options
                    .map((option) => Expanded(
                          child: RadioListTile<String>(
                            title: Text(option,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w200)),
                            value: option,
                            groupValue: value,
                            onChanged: onChanged,
                            dense: true,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        Divider(), // Add a Divider at the end
      ],
    );
  }

  Widget buildCheckboxGroup({
    required String label,
    required List<String> options,
    required List<String> selectedValues,
    required void Function(String, bool) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...options.map((option) => CheckboxListTile(
              title: Text(option),
              value: selectedValues.contains(option),
              onChanged: (isChecked) => onChanged(option, isChecked ?? false),
            )),
      ],
    );
  }

  // Helper method to build dropdown field
  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: MediaQuery.of(context).size.width * 0.005,
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: value,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true, // Ensures the dropdown takes full width
      ),
    );
  }
}
