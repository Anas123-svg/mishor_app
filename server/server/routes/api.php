<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ClientController;
use App\Http\Controllers\TemplateController;
//admin routes
Route::prefix('admin')->group(function () {
    Route::post('/register', [AdminController::class, 'register']);
    Route::post('/login', [AdminController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AdminController::class, 'logout']);
        Route::get('/', [AdminController::class, 'index']);
        Route::get('/show', [AdminController::class, 'showByToken']); //get by token
        Route::get('/{id}', [AdminController::class, 'show']);
        Route::put('/{id}', [AdminController::class, 'update']);
        Route::delete('/{id}', [AdminController::class, 'destroy']);
    });
});

//client routes
Route::prefix('client')->group(function () {
    Route::post('/register', [ClientController::class, 'register']);
    Route::post('/login', [ClientController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [ClientController::class, 'logout']);
        Route::get('/', [ClientController::class, 'index']);
        Route::get('/show', [ClientController::class, 'showByToken']);
        Route::get('/{id}', [ClientController::class, 'show']);
        Route::put('/{id}', [ClientController::class, 'update']);
        Route::delete('/{id}', [ClientController::class, 'destroy']);
    });
});


//user routes
Route::prefix('user')->group(function () {
    Route::post('/register', [UserController::class, 'register']);
    Route::post('/login', [UserController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [UserController::class, 'logout']);
        Route::get('/', [UserController::class, 'index']);
        Route::get('/show', [UserController::class, 'showByToken']); 
        Route::get('/{id}', [UserController::class, 'show']);
        Route::put('/{id}', [UserController::class, 'update']);
        Route::delete('/{id}', [UserController::class, 'destroy']);
    });
});


Route::prefix('templates')->group(function () {
    Route::get('/', action:[TemplateController::class, 'index']);
    Route::post('/', [TemplateController::class, 'store']); 
    Route::get('/{template}', [TemplateController::class, 'show']); 
    Route::put('/{template}', [TemplateController::class, 'update']); 
    Route::delete('/{template}', [TemplateController::class, 'destroy']);
    //Route::middleware('auth:sanctum')->group(function () {
    //});
});
