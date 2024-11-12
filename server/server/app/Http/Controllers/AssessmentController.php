<?php

namespace App\Http\Controllers;

use App\Models\Assessment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use App\Models\Template;

class AssessmentController extends Controller
{
    /**
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $assessments = Assessment::with(['client', 'template', 'user'])->get();
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
                'user_id' => 'required|exists:users,id',
                'status' => 'required|in:approved,pending,completed',
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
    
            $assessmentData = [
                'name' => $template->name,
                'description' => $template->description,
                'activity' => $template->Activity,
                'reference' => $template->Reference,
                'assessor' => $template->Assessor,
                'date' => $template->Date,
                'fields' => $template->fields,
                'tables' => $template->tables,
            ];
    
            Log::info('Attempting to create the assessment', [
                'assessment_data' => $assessmentData,
            ]);
    
            $assessment = Assessment::create([
                'client_id' => $request->input('client_id'),
                'template_id' => $request->input('template_id'),
                'user_id' => $request->input('user_id'),
                'assessment' => $assessmentData,
                'status' => $request->input('status'),
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
        $assessment = Assessment::with(['client', 'template', 'user'])->findOrFail($id);
        return response()->json($assessment);
    }

    /**
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Assessment  $assessment
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $assessment = Assessment::findOrFail($id);

        $request->validate([
            'client_id' => 'sometimes|exists:clients,id',
            'template_id' => 'sometimes|exists:templates,id',
            'user_id' => 'sometimes|exists:users,id',
            'assessment' => 'sometimes',
            'status' => 'sometimes|in:approved,pending,completed',
        ]);

        $assessment->update($request->only(['client_id', 'template_id', 'user_id', 'assessment', 'status']));
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
        $assessments = Assessment::where('client_id', $clientId)->with(['client', 'template', 'user'])->get();
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



}
