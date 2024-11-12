<?php

namespace App\Http\Controllers;

use App\Models\Client;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Hash;
class ClientController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:clients',
            'password' => 'required|string|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $client = Client::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            'profile_image' => $request->profile_image
        ]);
        $token = $client->createToken('ClientToken')->plainTextToken;
        return response()->json( ['token'=>$token, 'message' => 'Client registered successfully', 'client' => $client], 201);
    }
    public function showByToken(Request $request)
    {
        Log::info('function called');
        $client = $request->user();
    
        Log::info('Client retrieved by token', [
            'client_id' => $client ? $client->id : null, 
            'timestamp' => now(), 
        ]);
    
        if ($client) {
            return response()->json($client);
        }
    
        Log::warning('Client not found when attempting to retrieve by token', [
            'timestamp' => now(),
        ]);
    
        return response()->json(['error' => 'Client not found'], 404);
    }
    
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (!Auth::guard('web')->attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $client = Auth::user();
        $token = $client->createToken('ClientToken')->plainTextToken;

        return response()->json(['token' => $token, 'client' => $client], 200);
    }

    public function logout()
    {
        Auth::user()->tokens()->delete();

        return response()->json(['message' => 'Logged out successfully'], 200);
    }

    public function index()
    {
        $clients = Client::all();
        return response()->json($clients);
    }

    public function show($id)
    {
        $client = Client::find($id);

        if (!$client) {
            return response()->json(['error' => 'Client not found'], 404);
        }

        return response()->json($client);
    }

    public function update(Request $request, $id)
    {
        $client = Client::find($id);

        if (!$client) {
            return response()->json(['error' => 'Client not found'], 404);
        }

        $client->update($request->all());

        return response()->json(['message' => 'Client updated successfully', 'client' => $client]);
    }


    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'old_password' => 'required|string|min:8',
            'new_password' => 'required|string|min:8|confirmed',
        ]);
    
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
    
        $client = Auth::user();
    
        if (!$client) {
            return response()->json(['error' => 'Admin not found'], 404);
        }
    
        if (!Hash::check($request->old_password, $client->password)) {
            return response()->json(['error' => 'Old password is incorrect'], 400);
        }
    
        if ($request->old_password === $request->new_password) {
            return response()->json(['error' => 'New password cannot be the same as the old password'], 400);
        }
        try{
            $client->password = $request->new_password;
            $client->save();
        }
        catch(\Exception $e){
            return response()->json(['error' => 'An error occurred while updating the password'], 400);
        }    
        return response()->json(['message' => 'Password updated successfully'], 200);
    }

    public function verify($id)
{
    $client = Client::find($id);

    if (!$client) {
        return response()->json(['error' => 'Client not found'], 404);
    }

    $client->is_verified = true;
    $client->save();

    return response()->json(['message' => 'Client verified successfully', 'client' => $client]);
}

public function destroy($id)
{
    Log::info('Attempting to delete client with ID: ' . $id);

    $client = Client::find($id);

    if (!$client) {
        Log::warning('Client not found with ID: ' . $id);
        return response()->json(['error' => 'Client not found'], 404);
    }

    \DB::beginTransaction();

    try {
        Log::info('Deleting related users for client ID: ' . $id);
        $client->users()->delete();

        Log::info('Deleting related assessments for client ID: ' . $id);
        $client->assessments()->delete();

        Log::info('Deleting client ID: ' . $id);
        $client->delete();

        \DB::commit();

        Log::info('Client and related records deleted successfully for client ID: ' . $id);
        return response()->json(['message' => 'Client and all related records deleted successfully'], 200);
    } catch (\Exception $e) {
        \DB::rollback();
        Log::error('Error occurred while deleting client with ID: ' . $id, [
            'error_message' => $e->getMessage(),
            'stack_trace' => $e->getTraceAsString(),
        ]);

        return response()->json(['error' => 'An error occurred while deleting the client'], 500);
    }
}


}
