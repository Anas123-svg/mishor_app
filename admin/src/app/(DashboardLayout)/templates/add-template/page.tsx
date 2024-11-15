"use client";
import React, { useState } from "react";
import {
  Modal,
  Button,
  TextInput,
  Select,
  Checkbox,
  Label,
} from "flowbite-react";
import toast from "react-hot-toast";
import { FaEdit, FaTrashAlt } from "react-icons/fa";
import axios from "axios";

interface Field {
  label: string;
  type: "text" | "number" | "textarea" | "select" | "checkbox" | "radio";
  options?: string;
  attributes: {
    placeholder?: string;
    required: boolean;
  };
}

interface Table {
  tableName: string;
  columns: string;
  rows: string;
}

const AddTemplate: React.FC = () => {
  const [title, setTitle] = useState<string>("");
  const [description, setDescription] = useState<string>("");
  const [reference, setReference] = useState<string>("");
  const [fields, setFields] = useState<Field[]>([]);
  const [tables, setTables] = useState<Table[]>([]);
  const [isFieldModalOpen, setFieldModalOpen] = useState<boolean>(false);
  const [isTableModalOpen, setTableModalOpen] = useState<boolean>(false);
  const [isEditFieldModalOpen, setEditFieldModalOpen] =
    useState<boolean>(false);
  const [isEditTableModalOpen, setEditTableModalOpen] =
    useState<boolean>(false);

  const [newField, setNewField] = useState<Field>({
    label: "",
    type: "text",
    options: "",
    attributes: {
      placeholder: "",
      required: false,
    },
  });

  const [newTable, setNewTable] = useState<Table>({
    tableName: "",
    columns: "",
    rows: "",
  });

  const [editFieldIndex, setEditFieldIndex] = useState<number | null>(null);
  const [editTableIndex, setEditTableIndex] = useState<number | null>(null);
  const [loading, setLoading] = useState<boolean>(false);

  const handleSubmit = async () => {
    if (!title || !description || !reference) {
      toast.error("Title, Description and Reference are required");
      return;
    }
    if (fields.length === 0) {
      toast.error("At least one field is required");
      return;
    }
    const data = {
      name: title,
      description,
      Reference: reference,
      fields: fields.map((f, i) => ({
        id: i,
        label: f.label,
        type: f.type,
        options:
          f.type === "select" || f.type === "checkbox" || f.type === "radio"
            ? f.options?.split(",").map((opt) => opt.trim())
            : [],
        attributes: {
          placeholder: f.attributes.placeholder,
          required: f.attributes.required,
        },
        value: null,
      })),
      tables: tables.map((t) => ({
        tableName: t.tableName,
        columns: t.columns.split(",").map((col) => col.trim()),
        rows: t.rows.split(",").map((row) => row.trim()),
      })),
    };

    setLoading(true);
    try {
      const response = await axios.post(
        `${process.env.NEXT_PUBLIC_API_URL}/templates`,
        data
      );
      toast.success(response.data.message || "Template created successfully!");
      setTitle("");
      setDescription("");
      setFields([]);
      setTables([]);
      setNewField({
        label: "",
        type: "text",
        options: "",
        attributes: { placeholder: "", required: false },
      });
      setNewTable({ tableName: "", columns: "", rows: "" });
    } catch (error) {
      toast.error("Failed to create template");
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const addField = () => {
    if (!newField.label) {
      toast.error("Label is required");
      return;
    }
    if (
      newField.type === "select" ||
      newField.type === "checkbox" ||
      newField.type === "radio"
    ) {
      if (!newField.options) {
        toast.error("Options are required");
        return;
      }
    }
    setFields([...fields, newField]);
    setNewField({
      label: "",
      type: "text",
      options: "",
      attributes: { placeholder: "", required: false },
    });
    setFieldModalOpen(false);
  };

  const addTable = () => {
    if (!newTable.tableName || !newTable.columns || !newTable.rows) {
      toast.error("All fields are required");
      return;
    }
    setTables([...tables, newTable]);
    setNewTable({ tableName: "", columns: "", rows: "" });
    setTableModalOpen(false);
  };

  const deleteField = (index: number) => {
    setFields(fields.filter((_, i) => i !== index));
  };

  const deleteTable = (index: number) => {
    setTables(tables.filter((_, i) => i !== index));
  };

  const editField = (index: number) => {
    setEditFieldIndex(index);
    setNewField(fields[index]);
    setEditFieldModalOpen(true);
  };

  const editTable = (index: number) => {
    setEditTableIndex(index);
    setNewTable(tables[index]);
    setEditTableModalOpen(true);
  };

  const updateField = () => {
    if (editFieldIndex !== null) {
      if (!newField.label) {
        toast.error("Label is required");
        return;
      }
      if (
        newField.type === "select" ||
        newField.type === "checkbox" ||
        newField.type === "radio"
      ) {
        if (!newField.options) {
          toast.error("Options are required");
          return;
        }
      }
      const updatedFields = [...fields];
      updatedFields[editFieldIndex] = newField;
      setFields(updatedFields);
      setNewField({
        label: "",
        type: "text",
        options: "",
        attributes: { placeholder: "", required: false },
      });
      setEditFieldModalOpen(false);
    }
  };

  const updateTable = () => {
    if (editTableIndex !== null) {
      if (!newTable.tableName || !newTable.columns || !newTable.rows) {
        toast.error("All fields are required");
        return;
      }
      const updatedTables = [...tables];
      updatedTables[editTableIndex] = newTable;
      setTables(updatedTables);
      setNewTable({ tableName: "", columns: "", rows: "" });
      setEditTableModalOpen(false);
    }
  };

  return (
    <div className="rounded-lg dark:shadow-dark-md shadow-md bg-white dark:bg-darkgray p-6 relative w-full break-words">
      <h5 className="card-title mb-4">Add New Template</h5>
      <TextInput
        placeholder="Template Title"
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        required
        className="mb-4"
      />
      <TextInput
        placeholder="Template Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        required
        className="mb-4"
      />
      <TextInput
        placeholder="Template Reference"
        value={reference}
        onChange={(e) => setReference(e.target.value)}
        required
        className="mb-4"
      />
      <div>
        <h3 className="font-semibold mb-2">Fields</h3>

        <ul>
          {fields.map((field, index) => (
            <li
              key={index}
              className="flex justify-between items-center leading-relaxed bg-gray-100 p-2 my-1 rounded"
            >
              <ul>
                <li>
                  <strong> Name:</strong> {field.label}
                </li>
                <li>
                  <strong>Placeholder:</strong>{" "}
                  {field.attributes.placeholder
                    ? field.attributes.placeholder
                    : "N/A"}
                </li>
                <li>
                  <strong>Type:</strong> {field.type}
                </li>
                <li>
                  <strong>Options:</strong>{" "}
                  {field.options ? field.options : "N/A"}
                </li>
                <li>
                  <strong>Required:</strong>{" "}
                  {field.attributes.required ? "Yes" : "No"}
                </li>
              </ul>
              <div className="flex gap-2">
                <Button color="gray" onClick={() => editField(index)}>
                  <FaEdit />
                </Button>
                <Button color="gray" onClick={() => deleteField(index)}>
                  <FaTrashAlt />
                </Button>
              </div>
            </li>
          ))}
        </ul>
        <Button
          color="secondary"
          onClick={() => setFieldModalOpen(true)}
          className="mt-4"
        >
          Add Field
        </Button>
      </div>
      <div className="mt-4">
        <h3 className="font-semibold mb-2">Tables</h3>
        <ul>
          {tables.map((table, index) => (
            <li
              key={index}
              className="flex justify-between items-center leading-relaxed bg-gray-100 p-2 my-1 rounded"
            >
              <ul>
                <li>
                  <strong> Name:</strong> {table.tableName}
                </li>
                <li>
                  <strong>Columns:</strong> {table.columns}
                </li>
                <li>
                  <strong>Rows:</strong> {table.rows}
                </li>
              </ul>
              <div className="flex gap-2">
                <Button color="gray" onClick={() => editTable(index)}>
                  <FaEdit />
                </Button>
                <Button color="gray" onClick={() => deleteTable(index)}>
                  <FaTrashAlt />
                </Button>
              </div>
            </li>
          ))}
        </ul>
        <Button
          color="secondary"
          onClick={() => setTableModalOpen(true)}
          className="mt-4"
        >
          Add Table
        </Button>
      </div>
      <Button
        disabled={loading}
        color="primary"
        onClick={handleSubmit}
        className="w-full mt-4"
      >
        {loading ? "Loading..." : "Create Template"}
      </Button>

      {/* Field Modal */}
      <Modal
        show={isFieldModalOpen}
        onClose={() => {
          setNewField({
            label: "",
            type: "text",
            options: "",
            attributes: { placeholder: "", required: false },
          });
          setFieldModalOpen(false);
        }}
      >
        <Modal.Header>Add Field</Modal.Header>
        <Modal.Body>
          <TextInput
            placeholder="Label"
            value={newField.label}
            onChange={(e) =>
              setNewField({ ...newField, label: e.target.value })
            }
            className="mb-4"
          />
          <Select
            value={newField.type}
            onChange={(e) =>
              setNewField({
                ...newField,
                type: e.target.value as Field["type"],
              })
            }
            className="mb-4"
          >
            <option value="text">Text</option>
            <option value="number">Number</option>
            <option value="textarea">Text Area</option>
            <option value="select">Select</option>
            <option value="checkbox">Checkbox</option>
            <option value="radio">Radio</option>
          </Select>
          {(newField.type === "text" ||
            newField.type === "number" ||
            newField.type === "textarea") && (
            <TextInput
              placeholder="Placeholder"
              value={newField.attributes.placeholder}
              onChange={(e) =>
                setNewField({
                  ...newField,
                  attributes: {
                    ...newField.attributes,
                    placeholder: e.target.value,
                  },
                })
              }
              className="mb-4"
            />
          )}
          {(newField.type === "select" ||
            newField.type === "checkbox" ||
            newField.type === "radio") && (
            <TextInput
              placeholder="Options (comma separated)"
              value={newField.options}
              onChange={(e) =>
                setNewField({ ...newField, options: e.target.value })
              }
              className="mb-4"
            />
          )}
          <Label className="flex items-center gap-3">
            <Checkbox
              checked={newField.attributes.required}
              onChange={(e) =>
                setNewField({
                  ...newField,
                  attributes: {
                    ...newField.attributes,
                    required: e.target.checked,
                  },
                })
              }
            />{" "}
            <span>Is this field required?</span>
          </Label>
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={addField}>
            Add Field
          </Button>
          <Button
            color="secondary"
            onClick={() => {
              setNewField({
                label: "",
                type: "text",
                options: "",
                attributes: { placeholder: "", required: false },
              });
              setFieldModalOpen(false);
            }}
          >
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>

      {/* Edit Field Modal */}
      <Modal
        show={isEditFieldModalOpen}
        onClose={() => {
          setEditFieldIndex(null);
          setNewField({
            label: "",
            type: "text",
            options: "",
            attributes: { placeholder: "", required: false },
          });
          setEditFieldModalOpen(false);
        }}
      >
        <Modal.Header>Edit Field</Modal.Header>
        <Modal.Body>
          <TextInput
            placeholder="Label"
            value={newField.label}
            onChange={(e) =>
              setNewField({ ...newField, label: e.target.value })
            }
            className="mb-4"
          />
          <Select
            value={newField.type}
            onChange={(e) =>
              setNewField({
                ...newField,
                type: e.target.value as Field["type"],
              })
            }
            className="mb-4"
          >
            <option value="text">Text</option>
            <option value="number">Number</option>
            <option value="textarea">Text Area</option>
            <option value="select">Select</option>
            <option value="checkbox">Checkbox</option>
            <option value="radio">Radio</option>
          </Select>
          {(newField.type === "text" ||
            newField.type === "number" ||
            newField.type === "textarea") && (
            <TextInput
              placeholder="Placeholder"
              value={newField.attributes.placeholder}
              onChange={(e) =>
                setNewField({
                  ...newField,
                  attributes: {
                    ...newField.attributes,
                    placeholder: e.target.value,
                  },
                })
              }
              className="mb-4"
            />
          )}
          {(newField.type === "select" ||
            newField.type === "checkbox" ||
            newField.type === "radio") && (
            <TextInput
              placeholder="Options (comma separated)"
              value={newField.options}
              onChange={(e) =>
                setNewField({ ...newField, options: e.target.value })
              }
              className="mb-4"
            />
          )}
          <Label className="flex items-center gap-3">
            <Checkbox
              checked={newField.attributes.required}
              onChange={(e) =>
                setNewField({
                  ...newField,
                  attributes: {
                    ...newField.attributes,
                    required: e.target.checked,
                  },
                })
              }
            />
            <span>Is this field required?</span>
          </Label>
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={updateField}>
            Update Field
          </Button>
          <Button
            color="secondary"
            onClick={() => {
              setEditFieldIndex(null);
              setNewField({
                label: "",
                type: "text",
                options: "",
                attributes: { placeholder: "", required: false },
              });
              setEditFieldModalOpen(false);
            }}
          >
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>

      {/* Table Modal */}
      <Modal
        show={isTableModalOpen}
        onClose={() => {
          setNewTable({
            tableName: "",
            columns: "",
            rows: "",
          });
          setTableModalOpen(false);
        }}
      >
        <Modal.Header>Add Table</Modal.Header>
        <Modal.Body>
          <TextInput
            placeholder="Table Name"
            value={newTable.tableName}
            onChange={(e) =>
              setNewTable({ ...newTable, tableName: e.target.value })
            }
            className="mb-4"
          />
          <TextInput
            placeholder="Columns (comma separated)"
            value={newTable.columns}
            onChange={(e) =>
              setNewTable({ ...newTable, columns: e.target.value })
            }
            className="mb-4"
          />
          <TextInput
            placeholder="Rows (comma separated)"
            value={newTable.rows}
            onChange={(e) => setNewTable({ ...newTable, rows: e.target.value })}
            className="mb-4"
          />
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={addTable}>
            Add Table
          </Button>
          <Button
            color="secondary"
            onClick={() => {
              setNewTable({
                tableName: "",
                columns: "",
                rows: "",
              });
              setTableModalOpen(false);
            }}
          >
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>

      {/* Edit Table Modal */}
      <Modal
        show={isEditTableModalOpen}
        onClose={() => {
          setEditTableIndex(null);
          setNewTable({
            tableName: "",
            columns: "",
            rows: "",
          });
          setEditTableModalOpen(false);
        }}
      >
        <Modal.Header>Edit Table</Modal.Header>
        <Modal.Body>
          <TextInput
            placeholder="Table Name"
            value={newTable.tableName}
            onChange={(e) =>
              setNewTable({ ...newTable, tableName: e.target.value })
            }
            className="mb-4"
          />
          <TextInput
            placeholder="Columns (comma separated)"
            value={newTable.columns}
            onChange={(e) =>
              setNewTable({ ...newTable, columns: e.target.value })
            }
            className="mb-4"
          />
          <TextInput
            placeholder="Rows (comma separated)"
            value={newTable.rows}
            onChange={(e) => setNewTable({ ...newTable, rows: e.target.value })}
            className="mb-4"
          />
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={updateTable}>
            Update Table
          </Button>
          <Button
            color="secondary"
            onClick={() => {
              setEditTableIndex(null);
              setNewTable({
                tableName: "",
                columns: "",
                rows: "",
              });
              setEditTableModalOpen(false);
            }}
          >
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default AddTemplate;
