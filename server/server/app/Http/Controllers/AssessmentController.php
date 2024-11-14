<?php

namespace App\Http\Controllers;

use App\Models\Assessment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use App\Models\Template;
use App\Models\SiteImage;

class AssessmentController extends Controller
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $assessments = Assessment::with(['client', 'template', 'user','siteImages'])->get();
        return response()->json($assessments);
    }

    /**
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        Log::info('Creating new assessment', [
            'client_id' => $request->input('client_id'),
            'template_id' => $request->input('template_id'),
            'user_id' => $request->input('user_id'),
            'status' => $request->input('status'),
        ]);
    
        try {
            $request->validate([
                'client_id' => 'required|exists:clients,id',
                'template_id' => 'required|exists:templates,id',
                'user_id' => 'nullable|exists:users,id',
                'status' => 'nullable|in:approved,pending,completed',
                'submited_to_admin'=>'nullable|bool',
                'status_by_admin' => 'nullable|in:approved,rejected,pending',
                'feedback_by_admin' => 'nullable|string',
            ]);
        } catch (\Exception $e) {
            Log::error('Validation failed for creating assessment', [
                'error' => $e->getMessage(),
                'client_id' => $request->input('client_id'),
                'template_id' => $request->input('template_id'),
                'user_id' => $request->input('user_id'),

            ]);
    
            return response()->json([
                'message' => 'Failed to create assessment',
                'error' => $e->getMessage()
            ], 400);
        }
    
        Log::info('Validation successful for creating assessment');
    
        try {
            $template = Template::with(['fields', 'tables'])->findOrFail($request->input('template_id'));
            $status = $request->input('status', 'pending'); 
            $statusByAdmin = $request->input('status_by_admin', 'pending');     
            $tables = $template->tables->map(function ($table) {
                return [
                    'id' => $table->id,
                    'template_id' => $table->template_id,
                    'table_name' => $table->table_name,
                    'table_data' => json_decode($table->table_data, true), // Decode JSON to an associative array
                    'created_at' => $table->created_at,
                    'updated_at' => $table->updated_at
                ];
            });
    
            $assessmentData = [
                'name' => $template->name,
                'description' => $template->description,
                'activity' => $template->Activity,
                'reference' => $template->Reference,
                'assessor' => $template->Assessor,
                'date' => $template->Date,
                'fields' => $template->fields,
                'tables' => $tables,
            ];
    
            Log::info('Attempting to create the assessment', [
                'assessment_data' => $assessmentData,
            ]);
    
            $assessment = Assessment::create([
                'client_id' => $request->input('client_id'),
                'template_id' => $request->input('template_id'),
                'user_id' => $request->input('user_id'),
                'assessment' => $assessmentData,
                'status' => $status,//$request->input('status'),
                'submited_to_admin' => $request->input('submited_to_admin'),
                'status_by_admin' =>  $statusByAdmin,//$request->input('status_by_admin'),
                'feedback_by_admin' => $request->input('feedback_by_admin')
            ]);
    
            Log::info('Assessment created successfully', [
                'assessment_id' => $assessment->id,
                'client_id' => $assessment->client_id,
                'template_id' => $assessment->template_id,
                'status' => $assessment->status,
            ]);
    
            return $assessment;
        } catch (\Exception $e) {
            Log::error('Error creating assessment', [
                'error' => $e->getMessage(),
                'client_id' => $request->input('client_id'),
                'template_id' => $request->input('template_id'),
                'user_id' => $request->input('user_id'),
            ]);
    
            return response()->json([
                'message' => 'Failed to create assessment',
                'error' => $e->getMessage()
            ], 500);
        }
    }
                

    /**
     * @param  \App\Models\Assessment  $assessment
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $assessment = Assessment::with(['client', 'template', 'user','siteImages'])->findOrFail($id);
        return response()->json($assessment);
    }

    /**
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Assessment  $assessment
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
{
    Log::info('Site Images:', [
        'site_images' => $request->input('assessment.site_images'),
    ]);
    



    $assessment = Assessment::findOrFail($id);

    $request->validate([
        'client_id' => 'sometimes|exists:clients,id',
        'template_id' => 'sometimes|exists:templates,id',
        'user_id' => 'sometimes|exists:users,id',
        'assessment' => 'sometimes',
        'status' => 'sometimes|in:approved,pending,completed',
        'submited_to_admin' => 'sometimes|boolean',
        'feedback_by_admin' => 'sometimes|string',
        'status_by_admin' => 'sometimes|in:approved,rejected,pending',
        'complete_by_user' => 'sometimes|boolean',
        'site_images.*.site_image' => 'sometimes|string',
        'site_images.*.is_flagged' => 'sometimes|boolean',

    ]);

    if ($request->has('assessment')) {
        $updatedAssessmentData = $request->input('assessment');
        $existingAssessmentData = $assessment->assessment ?? [];

        // Merge `fields` if present in updated data
        if (isset($updatedAssessmentData['fields'])) {
            foreach ($updatedAssessmentData['fields'] as $updatedField) {
                foreach ($existingAssessmentData['fields'] as &$existingField) {
                    if (isset($existingField['id']) && isset($updatedField['id']) && $existingField['id'] === $updatedField['id']) {
                        $existingField = array_merge($existingField, $updatedField);
                    }
                }
            }
        }

        if (isset($updatedAssessmentData['tables'])) {
            foreach ($updatedAssessmentData['tables'] as $updatedTable) {
                foreach ($existingAssessmentData['tables'] as &$existingTable) {
                    if (
                        isset($existingTable['table_name']) && isset($updatedTable['table_name']) &&
                        $existingTable['table_name'] === $updatedTable['table_name']
                    ) {
                        if (isset($updatedTable['table_data']['rows'])) {
                            foreach ($updatedTable['table_data']['rows'] as $rowKey => $updatedRowData) {
                                if (isset($existingTable['table_data']['rows'][$rowKey])) {
                                    foreach ($updatedRowData as $columnKey => $columnValue) {
                                        if ($columnValue !== null) {
                                            $existingTable['table_data']['rows'][$rowKey][$columnKey] = $columnValue;
                                        }
                                    }
                                } else {
                                    $existingTable['table_data']['rows'][$rowKey] = $updatedRowData;
                                }
                            }
                        }
                    }
                }
            }
        }

        $assessment->assessment = $existingAssessmentData;
    }

    $assessment->update($request->only(['client_id', 'template_id', 'user_id', 'status', 'submited_to_admin', 'status_by_admin','complete_by_user','feedback_by_admin']));
    if ($request->has('assessment.site_images')) {
        foreach ($request->input('assessment.site_images') as $siteImageData) {
            if (isset($siteImageData['site_image'])) {
                SiteImage::updateOrCreate(
                    [
                        'assessment_id' => $assessment->id,
                        'site_image' => $siteImageData['site_image'],
                    ],
                    [
                        'is_flagged' => $siteImageData['is_flagged'] ?? false,
                    ]
                );
            }
        }
    }
    
    $assessment->save(); // Ensure the updated data is saved

    return response()->json($assessment);
}

        

    /**
     * @param  \App\Models\Assessment  $assessment
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $assessment = Assessment::findOrFail($id);
        $assessment->delete();

        return response()->json(['message' => 'Assessment deleted successfully']);
    }

    public function getAssessmentsByClientId($clientId)
    {
        $assessments = Assessment::where('client_id', $clientId)->with(['client', 'template', 'user','siteImages'])->get();
        return response()->json($assessments);
    }

    public function getAssessmentsByUserId($userId)
    {
        $assessments = Assessment::where('user_id', $userId)->with(['client', 'template', 'user'])->get();
        return response()->json($assessments);
    }

    public function getAssessmentsForAuthenticatedClient()
    {
        $client = Auth::user();
        if ($client && $client->hasRole('client')) {
            $assessments = Assessment::where('client_id', $client->id)->with(['client', 'template', 'user'])->get();
            return response()->json($assessments);
        }

        return response()->json(['message' => 'Unauthorized or client role not found'], 403);
    }

    public function getAssessmentsForAuthenticatedUser()
    {
        $user = Auth::user();
        if ($user && $user->hasRole('user')) {
            $assessments = Assessment::where('user_id', $user->id)->with(['client', 'template', 'user'])->get();
            return response()->json($assessments);
        }

        return response()->json(['message' => 'Unauthorized or user role not found'], 403);
    }

    public function getCompletedAssessmentsByUser()
    {
        $assessments = Assessment::where('complete_by_user', true)
            ->with(['client', 'template', 'user', 'siteImages'])
            ->get();
    
        return response()->json($assessments);
    }
    
}
