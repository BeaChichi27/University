import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { TodoItem } from './todo-item.type';
import { AuthRequest } from './auth-request.type';

@Injectable({
  providedIn: 'root'
})
export class RestBackendService {

  url = "http://localhost:3000" 
  constructor(private http: HttpClient) {}

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  login(loginRequest: AuthRequest){
    const url = `${this.url}/auth`; 
    return this.http.post<string>(url, loginRequest, this.httpOptions);
  }

  signup(signupRequest: AuthRequest){
    const url = `${this.url}/signup`; 
    console.log(signupRequest);
    return this.http.post(url, signupRequest, this.httpOptions);
  }

  getTodos() {
    const url = `${this.url}/todos`; 
    return this.http.get<TodoItem[]>(url, this.httpOptions);
  }

  getTodoById(id: number) {
    const url = `${this.url}/todos/${id}`; 
    return this.http.get<TodoItem>(url, this.httpOptions);
  }

  createTodo(todo: TodoItem){
    const url = `${this.url}/todos`;
    return this.http.post<TodoItem>(url, todo, this.httpOptions);
  }

  update(todoItem: TodoItem) {
    const url = `${this.url}/todos/${todoItem.id}`; 
    console.log(todoItem);
    return this.http.put<TodoItem>(url, todoItem, this.httpOptions);
  }

  delete(todoItem: TodoItem) {
    const url = `${this.url}/todos/${todoItem.id}`; 
    return this.http.delete(url, this.httpOptions);
  }

}
