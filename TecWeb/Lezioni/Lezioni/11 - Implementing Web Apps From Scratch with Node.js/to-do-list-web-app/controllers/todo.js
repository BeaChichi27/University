import http from "http";
import pug from "pug";
import { Database } from "../data/Database.js";
import { parseRequestBody } from "../utils.js";
import { Todo } from "../data/Todo.js";


/**
 * Handle requests to the todo page
 * @param {http.ClientRequest} request 
 * @param {http.ServerResponse} response 
 */
export function handleTodoListRequest(request, response, context={}){
  switch(request.method){
    case "GET":
      handleTodoListRequestGet(request, response,context); break;
    case "POST":
      handleTodoListRequestPost(request, response, context); break;
    default:
      handleError(request, response, 405, "Unsupported method"); 
  }
}


/**
 * Handle GET requests to the todo page, displays the todo list
 * @param {http.ClientRequest} request 
 * @param {http.ServerResponse} response 
 */
export function handleTodoListRequestGet(request, response, context={}){
  new Database().getTodos().then(todoItems => {
    context.todoItems = todoItems;
    let renderedContent = pug.renderFile("./templates/todo.pug", context);
    response.writeHead(200, {"Content-Type": "text/html"});
    response.end(renderedContent);
  });
}

/**
 * Handle POST requests to the todo page. Saves a new todo.
 * @param {http.ClientRequest} request 
 * @param {http.ServerResponse} response 
 */
export function handleTodoListRequestPost(request, response, context={}){
  parseRequestBody(request).then(data => {
    let todoText = data?.todo;
    let todo = new Todo(todoText, new Date().toString());
    return new Database().saveTodo(todo);
  }).then(result => {
    return new Database().getTodos();
  }).then(todoItems => {
    context.todoItems = todoItems;
    let renderedContent = pug.renderFile("./templates/todo.pug", context);
    response.writeHead(200, {"Content-Type": "text/html"});
    response.end(renderedContent);
  });
}