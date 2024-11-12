<?php

namespace App\Http\Controllers;

use App\Models\Template;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TemplateController extends Controller
{
    public function index()
    {
        $templates = Template::with(['fields', 'tables'])->get();

        $templates->each(function ($template) {
            $template->tables->each(function ($table) {
                $table->table_data = json_decode($table->table_data, true);
            });
        });

        return response()->json($templates);
    }

    public function show($id)
    {
        $template = Template::with(['fields', 'tables'])->find($id);

        if (!$template) {
            return response()->json(['error' => 'Template not found'], 404);
        }

        $template->tables->each(function ($table) {
            $table->table_data = json_decode($table->table_data, true);
        });

        return response()->json($template);
    }

    public function store(Request $request)
    {
        $template = DB::transaction(function () use ($request) {
            $template = Template::create($request->only(['name', 'description']));

            if ($request->has('fields')) {
                foreach ($request->fields as $field) {
                    $template->fields()->create($field);
                    
                }
            }

            if ($request->has('tables')) {
                foreach ($request->tables as $table) {
                    $processedRows = $this->processTableRows($table['columns'], $table['rows']);
                    $template->tables()->create([
                        'table_name' => $table['tableName'],
                        'table_data' => json_encode(['columns' => $table['columns'], 'rows' => $processedRows])
                    ]);
                }
            }

            return $template;
        });

        $template->load(['fields', 'tables']);
        $template->tables->each(function ($table) {
            $table->table_data = json_decode($table->table_data, true);
        });

        return response()->json([
            'template' => $template,
            'message' => 'Template created successfully'
        ], 201);
    }
    public function update(Request $request, Template $template)
{
    DB::transaction(function () use ($request, $template) {
        $template->update($request->only(['name', 'description']));

        if ($request->has('fields')) {
            $template->fields()->delete();
            foreach ($request->fields as $field) {
                $template->fields()->create($field);
            }
        }

        if ($request->has('tables')) {
            foreach ($request->tables as $table) {
                $existingTable = $template->tables()->find($table['id']);
                if ($existingTable) {
                    $existingTable->update([
                        'table_name' => $table['table_name'],
                        'table_data' => json_encode($table['table_data'])
                    ]);
                } else {
                    $template->tables()->create([
                        'table_name' => $table['table_name'],
                        'table_data' => json_encode($table['table_data'])
                    ]);
                }
            }
        }
    });

    $template->load(['fields', 'tables']);
    $template->tables->each(function ($table) {
        $table->table_data = json_decode($table->table_data, true);
    });

    return response()->json([
        'template' => $template,
        'message' => 'Template updated successfully'
    ], 200);
}


    private function processTableRows($columns, $rows)
    {
        $processedRows = [];

        foreach ($rows as $rowName) {
            $rowData = array_fill_keys($columns, "");
            $processedRows[$rowName] = $rowData;
        }

        return $processedRows;
    }
    public function destroy($id)
{
    DB::transaction(function () use ($id) {
        $template = Template::find($id);

        if (!$template) {
            return response()->json(['error' => 'Template not found'], 404);
        }

        $template->fields()->delete();

        $template->tables()->delete();

        $template->delete();
    });

    return response()->json(['message' => 'Template deleted successfully'], 200);
}

}
