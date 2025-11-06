import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from "@angular/router/testing";

import { TodoPageComponent } from './todo-page.component';
import { RestBackendService } from '../_services/rest-backend/rest-backend.service';
import { ToastrService } from 'ngx-toastr';
import { of } from 'rxjs';
import { DebugElement } from '@angular/core';
import { By } from '@angular/platform-browser';

describe('TodoPageComponent', () => {
  let component: TodoPageComponent;
  let fixture: ComponentFixture<TodoPageComponent>;
  let restBackendSpy: jasmine.SpyObj<RestBackendService>;
  let toastrSpy: jasmine.SpyObj<ToastrService>;

  beforeEach(async () => {

    restBackendSpy = jasmine.createSpyObj('RestBackendService', ['login', 'getTodos']);
    toastrSpy = jasmine.createSpyObj('ToastrService', ['success', 'error', 'warning']);
    restBackendSpy.getTodos.and.returnValue(of([{id: 1, todo: "foo"}]));


    await TestBed.configureTestingModule({
      imports: [TodoPageComponent, RouterTestingModule],
      providers: [{ 
        provide: RestBackendService, useValue: restBackendSpy
      }, {
        provide: ToastrService, useValue: toastrSpy
      },]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(TodoPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should properly fetch to-do items', () => {
    let todos = [{id: 1, todo: "foo"}, {id: 2, todo: "bar"}];
    restBackendSpy = jasmine.createSpyObj('RestBackendService', ['getTodos']);
    restBackendSpy.getTodos.and.returnValue(of(todos));
    component.restService = restBackendSpy;

    component.fetchTodos();
    expect(component.todos.length).toEqual(2);

    fixture.detectChanges();

    const element: DebugElement = fixture.debugElement; //get <app-todo-page> elem
    const list = element.query(By.css('ul'));
    const content = list.nativeElement.textContent;
    expect(content).toContain('foo');
    expect(content).toContain('bar');

  })
});
