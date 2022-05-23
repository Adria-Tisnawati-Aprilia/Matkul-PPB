<?php

namespace App\Http\Controllers;

use App\Models\Author;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Http\Request;

class AuthorController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function showAllAuthor()
    : JsonResponse {

        return response()->json(Author::all());
    }

    public function showOneAuthor($id)
    : JsonResponse {

        return response()->json(Author::find($id));
    }

    public function create(Request $request)
    : JsonResponse {

        $author = Author::create($request->all());
        return response()->json($author, Response::HTTP_CREATED);
    }

    public function update($id, Request $request)
    : JsonResponse {

        $author = Author::findOrFail($id);
        $author->update($request->all());

        return response()->json($author, Response::HTTP_OK);
    }

    public function delete($id)
    {

        Author::findOrFail($id)->delete;
        return response('Deleted Succesfully', Response::HTTP_OK);
    }
}
