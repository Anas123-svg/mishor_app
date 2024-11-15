import React from "react";
import {
  Document,
  Page,
  Text,
  View,
  StyleSheet,
  Image,
} from "@react-pdf/renderer";
import logo from "@/assets/logo.jpg";
import { Assessment } from "@/types";

const styles = StyleSheet.create({
  page: {
    padding: 40,
    fontFamily: "Helvetica",
  },
  logoContainer: {
    display: "flex",
    alignItems: "center",
    marginBottom: 16,
  },
  logo: {
    width: 120,
    marginBottom: 16,
  },
  header: {
    fontSize: 24,
    fontWeight: "bold",
    marginBottom: 10,
    color: "#2a3d66",
    borderBottom: "2px solid #d9d9d9",
    paddingBottom: 4,
  },
  subHeader: {
    fontSize: 14,
    color: "#555",
    marginBottom: 16,
  },
  section: {
    marginBottom: 24,
    padding: 12,
    backgroundColor: "#fff",
    borderRadius: 6,
  },
  sectionHeader: {
    fontSize: 18,
    fontWeight: "bold",
    marginBottom: 8,
    color: "#2a3d66",
    paddingBottom: 4,
    borderBottom: "2px solid #d9d9d9",
  },
  flaggedSectionHeader: {
    color: "#d9534f", // Deep red for flagged items
  },
  fieldContainer: {
    fontSize: 12,
    color: "#444",
    lineHeight: 1.5,
    marginBottom: 8,
  },
  flaggedFieldContainer: {
    color: "#d9534f", // Deep red text for flagged fields
  },
  fieldLabel: {
    fontWeight: "bold",
    color: "#333",
  },
  tableContainer: {
    borderTop: "1px solid #e3e3e3",
    marginTop: 16,
  },
  tableHeader: {
    flexDirection: "row",
    backgroundColor: "#2a3d66",
    paddingVertical: 8,
    paddingHorizontal: 4,
  },
  tableHeaderText: {
    fontSize: 12,
    fontWeight: "bold",
    color: "#fff",
    width: "25%",
  },
  tableRow: {
    flexDirection: "row",
    borderBottom: "1px solid #ddd",
    paddingVertical: 8,
    paddingHorizontal: 4,
    backgroundColor: "#f7f9fc",
  },
  tableRowAlternate: {
    backgroundColor: "#e8f0f9",
  },
  tableCell: {
    fontSize: 10,
    color: "#333",
  },
  rowTitle: {
    fontSize: 10,
    fontWeight: "bold",
    color: "#2a3d66",
    width: "25%",
    paddingRight: 6,
  },
  imageGrid: {
    flexDirection: "row",
    flexWrap: "wrap",
    gap: 10,
    marginTop: 12,
  },
  image: {
    width: "48%",
    height: 120,
    borderRadius: 8,
    marginVertical: 4,
  },
  feedbackSection: {
    marginTop: 20,
    paddingTop: 16,
    borderTop: "1px solid #d9d9d9",
  },
  feedbackText: {
    fontSize: 12,
    color: "#333",
    lineHeight: 1.5,
  },
});

const AssessmentPDF = ({ assessment }: { assessment: Assessment }) => (
  <Document>
    <Page style={styles.page}>
      {/* Logo and Assessment Title */}
      <View style={styles.logoContainer}>
        <Image src={logo.src} style={styles.logo} />
      </View>
      <Text style={styles.header}>{assessment.assessment.name}</Text>
      <Text style={styles.subHeader}>{assessment.assessment.description}</Text>

      {/* Overview Section */}
      <View style={styles.section}>
        <Text style={styles.sectionHeader}>Overview</Text>
        <Text style={styles.fieldContainer}>
          <Text style={styles.fieldLabel}>Client Name: </Text>
          {assessment.client.name}
        </Text>
        <Text style={styles.fieldContainer}>
          <Text style={styles.fieldLabel}>Inspector: </Text>
          {assessment.user.name}
        </Text>
        <Text style={styles.fieldContainer}>
          <Text style={styles.fieldLabel}>Created On: </Text>
          {new Date(assessment.created_at).toLocaleDateString()}
        </Text>
      </View>

      {/* Flagged Items Section */}
      {assessment.assessment.fields.filter((field) => field.isFlagged).length >
        0 && (
        <View style={[styles.section, styles.flaggedFieldContainer]}>
          <Text style={[styles.sectionHeader, styles.flaggedSectionHeader]}>
            Flagged Items
          </Text>
          {assessment.assessment.fields
            .filter((field) => field.isFlagged)
            .map((field, idx) => (
              <Text
                key={idx}
                style={[styles.fieldContainer, styles.flaggedFieldContainer]}
              >
                <Text style={styles.fieldLabel}>{field.label}: </Text>
                {field.value || "N/A"}
              </Text>
            ))}
        </View>
      )}

      {/* Assessment Details Section */}
      <View style={styles.section}>
        <Text style={styles.sectionHeader}>Inspection Details</Text>
        {assessment.assessment.fields.map((field, idx) => (
          <Text key={idx} style={styles.fieldContainer}>
            <Text style={styles.fieldLabel}>{field.label}: </Text>
            {field.value || "N/A"}
          </Text>
        ))}
      </View>

      {/* Tables Section */}
      {assessment.assessment.tables.map((table, idx) => (
        <View key={idx} style={styles.section}>
          <Text style={styles.sectionHeader}>{table.table_name}</Text>
          <View style={styles.tableContainer}>
            {/* Table Header */}
            <View style={styles.tableHeader}>
              <Text style={styles.rowTitle}>Row Title</Text>
              {table.table_data.columns.map((col, index) => (
                <Text key={index} style={styles.tableHeaderText}>
                  {col}
                </Text>
              ))}
            </View>
            {/* Table Rows */}
            {Object.entries(table.table_data.rows).map(
              ([rowKey, rowVal], rowIndex) => (
                <View
                  key={rowIndex}
                  style={[
                    styles.tableRow,
                    rowIndex % 2 !== 0 ? styles.tableRowAlternate : {},
                  ]}
                >
                  <Text style={styles.rowTitle}>{rowKey}</Text>
                  {Object.values(rowVal).map((cell, cellIndex) => (
                    <Text key={cellIndex} style={styles.tableCell}>
                      {cell}
                    </Text>
                  ))}
                </View>
              )
            )}
          </View>
        </View>
      ))}

      {/* Site Images Section */}
      {assessment.site_images && assessment.site_images.length > 0 && (
        <View style={styles.section}>
          <Text style={styles.sectionHeader}>Site Images</Text>
          <View style={styles.imageGrid}>
            {assessment.site_images.map((image, idx) => (
              <Image key={idx} src={image} style={styles.image} />
            ))}
          </View>
        </View>
      )}

      {/* Feedback by Admin Section */}
      <View style={styles.feedbackSection}>
        <Text style={styles.sectionHeader}>Feedback by Admin</Text>
        <Text style={styles.feedbackText}>
          {assessment.feedback_by_admin || "No feedback provided."}
        </Text>
      </View>
    </Page>
  </Document>
);

export default AssessmentPDF;
