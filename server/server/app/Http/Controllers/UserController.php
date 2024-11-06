<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'client_id' => 'required|exists:clients,id',
            'phone' => 'required|string',
            'name' => 'required|string',
            'email' => 'required|string|email|unique:users',
            'password' => 'required|string|confirmed',
        ]);

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
        $token = $user->createToken('user-token')->plainTextToken;


        return response()->json([
            'token' => $token,
            'message' => 'User registered successfully',
            'user' => $user,
        ], 201);
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

        return response()->json([
            'token' => $token,
            'user' => $user,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }

    public function index()
    {
        return response()->json(User::all());
    }

    public function show($id)
    {
        $user = User::findOrFail($id);

        return response()->json($user);
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $request->validate([
            'phone' => 'required|string',
            'name' => 'required|string',
            'email' => 'required|string|email|unique:users,email,' . $id,
        ]);

        $user->update($request->only(['phone', 'name', 'email', 'role', 'profile_image', 'is_verified']));

        return response()->json([
            'message' => 'User updated successfully',
            'user' => $user,
        ]);
    }


    public function showByToken(Request $request)
    {
        $user = $request->user();
        return response()->json($user);
    }
    


    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json([
            'message' => 'User deleted successfully',
        ]);
    }
}
