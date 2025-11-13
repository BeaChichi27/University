import { Component, EventEmitter, Input, Output, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { RestBackendService } from '../../_services/rest-backend/rest-backend.service';
import { ToastrService } from 'ngx-toastr';
import { TodoItem } from '../../_services/rest-backend/todo-item.type';

@Component({
  selector: 'app-todo-item',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './todo-item.component.html',
  styleUrl: './todo-item.component.scss'
})
export class TodoItemComponent {
  @Input({ required: true}) todoItem: TodoItem; //set "strictPropertyInitialization": false in tsconfig
  @Output() delete: EventEmitter<number | undefined> = new EventEmitter();
  editLink = "";
  restBackend = inject(RestBackendService);
  toastr = inject(ToastrService);


  ngOnInit(){
    this.editLink = "/todos/"+this.todoItem?.id;
  }

  handleToggleDoneStatus(){
    if(this.todoItem !== null){
      this.todoItem.done = ! this.todoItem.done;
      this.restBackend.update(this.todoItem)
        .subscribe({
          next: (data) => {
            console.log(data);
          },
          error: (err) => {
            this.toastr.error("Error when updating the to-do");
          },
          complete: () => {
            this.toastr.success(`Status changed to "${this.todoItem?.done ? "done":"to-do"}"`, `To-do modified`);
          }
        })
    }
  }

  handleDelete(){
    if(this.todoItem !== null){
      this.restBackend.delete(this.todoItem)
        .subscribe({
          next: (data) => {
            console.log(data);
          },
          error: (err) => {
            this.toastr.error("Error when deleting the to-do");
          },
          complete: () => {
            this.toastr.success(`To-do item "${this.todoItem?.todo}" deleted`, `To-do deleted`);
            this.delete.emit(this.todoItem?.id);
          }
        })
    }
  }
}
