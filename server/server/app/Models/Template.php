<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Template extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'description','Activity','Reference','Assessor','Date'];

    public function fields()
    {
        return $this->hasMany(Field::class);
    }

    public function tables() 
    {
        return $this->hasMany(CustomTable::class);
    }

    
}
