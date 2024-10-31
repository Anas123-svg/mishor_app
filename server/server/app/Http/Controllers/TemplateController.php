<?php

namespace App\Http\Controllers;

use App\Models\Template;
use App\Models\Field;
use App\Models\CustomTable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TemplateController extends Controller
{
    public function index()
    {
        return Template::with(['fields', 'tables'])->get();
    }
    public function show($id)
    {
        $Template = Template::find($id);
        $Template->fields;
        $Template->tables;
        if (!$Template) {
            return response()->json(['error' => 'Template not found'], 404);
        }

        return response()->json($Template);
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
                    $template->tables()->create([
                        'table_name' => $table['table_name'],
                        'table_data' => json_encode($table)
                    ]);
                }
            }
    
            return $template;
        });
    
        $template->load(['fields', 'tables']);
    
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
                $template->tables()->delete();
                foreach ($request->tables as $table) {
                    $template->tables()->create([
                        'table_name' => $table['table_name'],
                        'table_data' => json_encode($table)
                    ]);
                }
            }
        });
    
        $template->load(['fields', 'tables']);
    
        return response()->json([
            'template' => $template,
            'message' => 'Template updated successfully'
        ], 200);
    }
    
    public function destroy(Template $template)
    {
        DB::transaction(function () use ($template) {
            $template->fields()->delete();
            $template->tables()->delete();
            $template->delete();
        });

        return response()->noContent();
    }
}
