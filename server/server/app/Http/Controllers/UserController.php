<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;
use App\Models\Assessment;
class UserController extends Controller
{
    private function getAssessmentCounts($user)
    {
        $userCounts = User::where('id', $user->id)
            ->withCount([
                'assessments as completed_assessments' => function ($query) {
                    $query->where('status', 'approved');
                },
                'assessments as rejected_assessments' => function ($query) {
                    $query->where('status', 'rejected');
                },
                'assessments as pending_assessments' => function ($query) {
                    $query->where('status', 'pending');
                },
                'assessments as total_assessments'
            ])->first();
       // $dailyApprovedCounts = $this->getDailyApprovedCounts($user->id);

        return [
            'user_counts' => $userCounts,
            //'daily_approved_counts' => $dailyApprovedCounts,
        ];
    }

    private function getDailyApprovedCounts($userId)
    {
        $counts = [];
        $today = Carbon::today();
        for ($i = 0; $i < 7; $i++) {
            $date = $today->copy()->subDays($i);
            $count = Assessment::where('user_id', $userId)
                ->where('status', 'approved')
                ->whereDate('created_at', $date)
                ->count();
            $counts[$date->format('l')] = $count;
        }

        return $counts;
    }

    public function register(Request $request)
    {
        Log::info('Registering user:', context: ['request_data' => $request->all()]);
    
        try {
            $request->validate([
                'client_id' => 'required|exists:clients,id',
                'phone' => 'required|string',
                'name' => 'required|string',
                'email' => 'required|string|email|unique:users',
                'password' => 'required|string|confirmed',
            ]);
            
            Log::info('Validation passed.');
    
            Log::info('Client ID:', ['client_id' => $request->client_id]);
            $user = User::create([
                'client_id' => $request->client_id,
                'phone' => $request->phone,
                'name' => $request->name,
                'email' => $request->email,
                'role' => $request->role,
                'profile_image' => $request->profile_image,
                'password' => Hash::make($request->password),
                'is_verified' => false,
            ]);
            Log::info('User created:', ['user' => $user]);
    
            $token = $user->createToken('user-token')->plainTextToken;
            Log::info('User token generated:', ['token' => $token]);
    
            return response()->json([
                'token' => $token,
                'message' => 'User registered successfully',
                'user' => $user,
                'assessment_counts' => $this->getAssessmentCounts($user),

            ], 201);
    
        } catch (\Exception $e) {
            Log::error('Registration failed:', ['error' => $e->getMessage(), 'stack' => $e->getTraceAsString()]);
    
            return response()->json([
                'message' => 'Registration failed. Please try again.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
    
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $token = $user->createToken('user-token')->plainTextToken;
        $assessmentCounts = $this->getAssessmentCounts($user);

        return response()->json([
            'token' => $token,
            'user' => $user, 
        ]);
    }

    public function assessmentCountsByUser(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
    
        $userWithAssessmentCounts = User::where('id', $user->id)
            ->withCount([
                'assessments as completed_assessments' => function ($query) {
                    $query->where('status', 'approved');
                },
                'assessments as rejected_assessments' => function ($query) {
                    $query->where('status', 'rejected');
                },
                'assessments as pending_assessments' => function ($query) {
                    $query->where('status', 'pending');
                },
                'assessments as total_assessments'
            ])->first();
    
        $dailyApprovedCounts = $this->getDailyApprovedCounts($user->id);
    
        // Fetch assessments with template name directly included as "name"
        $assignedAssessments = Assessment::where('user_id', $user->id)
            ->where('complete_by_user', false) 
            ->whereIn('status', ['assigned','pending'])  
            ->with('template:id,name') // Eager load only the template name
            ->get(['id', 'status', 'created_at', 'updated_at', 'location', 'template_id'])
            ->map(function ($assessment) {
                $assessment->name = $assessment->template->name ?? $assessment->name;
                unset($assessment->template); // Remove the nested template relationship
                return $assessment;
            });
    
        return response()->json([
            'user' => $userWithAssessmentCounts,
            'daily_approved_counts' => $dailyApprovedCounts,
            'assigned_assessments' => $assignedAssessments
        ]);
    }
        


    public function logout(Request $request)
    {
        // Log the user ID of the authenticated user attempting to log out
        Log::info('User attempting to log out', ['user_id' => $request->user()->id]);
    
        try {
            // Delete all tokens associated with the user
            $tokensDeleted = $request->user()->tokens()->delete();
    
            // Log the result of the token deletion
            Log::info('Tokens deleted for user', [
                'user_id' => $request->user()->id,
                'tokens_deleted' => $tokensDeleted
            ]);
    
            // Return a successful logout response
            return response()->json([
                'message' => 'Logged out successfully',
            ]);
        } catch (\Exception $e) {
            // Log any exceptions or errors that occur during the logout process
            Log::error('Error during logout', [
                'user_id' => $request->user()->id,
                'error_message' => $e->getMessage(),
                'stack_trace' => $e->getTraceAsString()
            ]);
    
            // Return a failure response in case of error
            return response()->json([
                'message' => 'Logout failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    

    public function index()
    {
        return response()->json(User::all());
    }

    public function show($id)
    {
        $user = User::findOrFail($id);
    
        $assessments = $user->assessments()->with(['client', 'template', 'siteImages'])->get();
    
        return response()->json([
            'user' => $user,
            'assessments' => $assessments
        ]);
    }
    

    public function update(Request $request)
    {
    
        $authUser = auth()->user();  
    
        $request->validate([
            'phone' => 'sometimes|string',
            'name' => 'sometimes|string',
            'email' => 'sometimes|string|email|unique:users,email,' . $authUser->id,
            'profile_image' => 'nullable|string',
            'role' => 'sometimes|string',
            'is_verified' => 'sometimes|boolean',
        ]);
    
        $authUser->update($request->only(['phone', 'name', 'email', 'role', 'profile_image', 'is_verified']));
    
        return response()->json([
            'message' => 'User updated successfully',
            'user' => $authUser,
            'assessment_counts' => $this->getAssessmentCounts($authUser)
        ]);
    }
        
    public function showByToken(Request $request)
    {
        $user = $request->user();
        return response()->json([$user,'assessment_counts' => $this->getAssessmentCounts($user),
    ]);
    }
    


    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json([
            'message' => 'User deleted successfully',
        ]);
    }


    public function completedAssessmentCountsByUser(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $userWithAssessmentCounts = User::where('id', $user->id)
            ->withCount([
                'assessments as completed_assessments' => function ($query) {
                    $query->where('status', 'approved');
                },
                'assessments as rejected_assessments' => function ($query) {
                    $query->where('status', 'rejected');
                },
                'assessments as pending_assessments' => function ($query) {
                    $query->where('status', 'pending');
                },
                'assessments as total_assessments'
            ])->first();

        $dailyApprovedCounts = $this->getDailyApprovedCounts($user->id);
        $assignedAssessments = Assessment::where('user_id', $user->id)
        ->whereIn('status', ['approved']) 
        ->get(['id', 'status', 'created_at', 'updated_at', 'location', 'name']);    
        return response()->json([
            'user' => $userWithAssessmentCounts,
            'daily_approved_counts' => $dailyApprovedCounts,
            'assigned_assessments' => $assignedAssessments
        ]);
    }

    public function verify($id)
    {
        $User = User::find($id);
    
        if (!$User) {
            return response()->json(['error' => 'User not found'], 404);
        }
    
        $User->is_verified = true;
        $User->save();
    
        return response()->json(['message' => 'User verified successfully', 'User' => $User]);
    }
}
