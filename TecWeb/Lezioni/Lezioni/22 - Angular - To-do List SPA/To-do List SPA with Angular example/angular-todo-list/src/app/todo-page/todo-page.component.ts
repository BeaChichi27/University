import { Component, inject } from '@angular/core';
import { RestBackendService } from '../_services/rest-backend/rest-backend.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';
import { TodoItemComponent } from './todo-item/todo-item.component';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { TodoItem } from '../_services/rest-backend/todo-item.type';

@Component({
  selector: 'app-todo-page',
  standalone: true,
  imports: [TodoItemComponent, ReactiveFormsModule],
  templateUrl: './todo-page.component.html',
  styleUrl: './todo-page.component.scss'
})
export class TodoPageComponent {
  createTodoSubmitted = false;
  restService = inject(RestBackendService);
  toastr = inject(ToastrService);
  router = inject(Router);
  todos: TodoItem[] = []; //array of TodoItem

  newTodoForm = new FormGroup({
    todo: new FormControl('', [Validators.required])
  })
  
  ngOnInit() {
    this.fetchTodos();  
  }

  fetchTodos(){
    this.restService.getTodos().subscribe({
      next: (data) => {
        console.log(data);
        this.todos = data;
      },
      error: (err) => {
        if(err.status === 401){
          this.toastr.error("Your access token appears to be invalid. Login again", "Token expired");
          this.router.navigateByUrl("/login");
        } else {
          this.toastr.error(err.message, err.statusText)
        }
      }
    });
  }

  handleTodoSubmit(){
    this.createTodoSubmitted = true;
    if(this.newTodoForm.invalid){
      this.toastr.error("The data you provided is invalid!", "Oops! Invalid data!");
    } else {
      this.restService.createTodo({
        todo: this.newTodoForm.value.todo as string
      }).subscribe({
        next: (todo) => {
          this.toastr.success(`To-do item: ${todo.todo}`, "To-do saved correctly!");
          this.createTodoSubmitted = false;
          this.newTodoForm.setValue({todo: ""});
        },
        error: (err) => {
          this.toastr.error("Could not save the to-do item.", "Oops! Something went wrong.");
        },
        complete: () => {
          this.fetchTodos();
          this.newTodoForm.value.todo = ''; //reset input field
        }
      })
    }
  }

  handleDelete(id: number | undefined){
    console.log("DELETE HERE");
    console.log(id);
    this.todos = this.todos.filter((x) => x.id !== id)
  }
}
