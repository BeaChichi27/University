import { Routes } from '@angular/router';
import { HomepageComponent } from './homepage/homepage.component';
import { LoginComponent } from './login/login.component';
import { SignupComponent } from './signup/signup.component';
import { TodoPageComponent } from './todo-page/todo-page.component';
import { ResetPageComponent } from './reset-page/reset-page.component';
import { TodoDetailComponent } from './todo-detail/todo-detail.component';
import { authGuard } from './_guards/auth/auth.guard';
import { LogoutComponent } from './logout/logout.component';

export const routes: Routes = [
  {
    path: "home",
    component: HomepageComponent,
    title: "To-do List Angular App"
  }, {
    path: "login",
    component: LoginComponent,
    title: "Login | To-do List Angular App"
  }, {
    path: "signup",
    component: SignupComponent,
    title: "Sign up | To-do List Angular App"
  }, {
    path: "logout",
    component: LogoutComponent,
    title: "Log out | To-do List Angular App"
  }, {
    path: "reset",
    component: ResetPageComponent,
    title: "Reset app | To-do List Angular App",
  }, {
    path: "todos",
    component: TodoPageComponent,
    title: "To-do List | To-do List Angular App",
    canActivate: [authGuard]
  }, {
    path: "todos/:id",
    component: TodoDetailComponent,
    title: "To-do Detail | To-do List Angular App",
    canActivate: [authGuard]
  }, {
    path: "",
    redirectTo: "/home",
    pathMatch: 'full'
  },
];
