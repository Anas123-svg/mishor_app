import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class InspectionsList extends StatelessWidget {
  final List<String> inspections;
  final Function(String) onSignOff;
  final Function onUploadDocument;
  final Function(String) onSearchChanged;

  const InspectionsList({
    Key? key,
    required this.inspections,
    required this.onSearchChanged,
    required this.onSignOff,
    required this.onUploadDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Inspections...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => onSearchChanged(value),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, 
            itemCount: inspections.length,
            separatorBuilder: (context, index) => Divider(color: Colors.black12),
            itemBuilder: (context, index) {
              final inspection = inspections[index];
              final isFlagged = inspection.contains('Assigned');

              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.h), 
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  title: Text(
                    inspection,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.assignment, 
                          color: isFlagged ? Colors.red : Colors.grey, 
                        ),
                        onPressed: () => onUploadDocument(),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.pending, 
                          color: !isFlagged ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => onSignOff(inspection),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
