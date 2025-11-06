import { Component, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { RestBackendService } from '../_services/rest-backend/rest-backend.service';
import { ToastrService } from 'ngx-toastr';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';


@Component({
  selector: 'app-todo-detail',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './todo-detail.component.html',
  styleUrl: './todo-detail.component.scss'
})
export class TodoDetailComponent {
  constructor(private route:ActivatedRoute){}
  id: number = 0;
  todoItem: any;

  updateTodoSubmitted = false;
  restService = inject(RestBackendService);
  toastr = inject(ToastrService);
  router = inject(Router);

  updateTodoForm = new FormGroup({
    todo: new FormControl('', [Validators.required]),
    done: new FormControl(false)
  })

  ngOnInit(){
    this.id = this.route.snapshot.params["id"];
    this.restService.getTodoById(this.id)
      .subscribe({
        next: (data: any) => {
          console.log(data);
          this.todoItem = data;
          this.updateTodoForm.controls.todo.setValue(data.todo);
          this.updateTodoForm.controls.done.setValue(data.done);
          console.log(this.updateTodoForm.value.done);
        },
        error: (err) => {
          console.log(err);
        },
        complete: () => {
          
        }
      });
  }

  handleUpdateTodoSubmit(){
    this.updateTodoSubmitted = true;
    if(this.updateTodoForm.invalid){
      this.toastr.error("The data you provided is invalid!", "Oops! Invalid data!");
    } else {
      this.todoItem.todo = this.updateTodoForm.value.todo as string;
      this.todoItem.done = this.updateTodoForm.value.done as boolean;
      console.log(this.todoItem);
      this.restService.update(this.todoItem).subscribe({
        next: (todo) => {
          this.toastr.success(`To-do item: ${todo.todo}`, "To-do updated correctly!")
        },
        error: (err) => {
          this.toastr.error("Could not save the to-do item.", "Oops! Something went wrong.");
        },
        complete: () => {
          this.router.navigateByUrl("/todos"); //back to todos page
        }
      })
    }
  }
}
