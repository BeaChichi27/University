import express from "express";
import { TodoController } from "../controllers/TodoController.js";
import { ensureUsersModifyOnlyOwnTodos } from "../middleware/authorization.js";

export const todoRouter = new express.Router();

todoRouter.get("/todos", (req, res, next) => {
  TodoController.getTodosForCurrentUser(req).then(todoItems => {
    res.json(todoItems)
  }).catch(err => {
    next(err);
  });
});

todoRouter.post("/todos", (req, res, next) => {
  TodoController.saveTodo(req).then( result => {
    res.json(result);
  }).catch(err => {
    next(err);
  });
});

todoRouter.get("/todos/:id", ensureUsersModifyOnlyOwnTodos, (req, res, next) => {
  TodoController.findById(req).then( (item) => {
    if(item)
      res.json(item);
    else 
      next({status: 404, message: "Todo not found"});
  }).catch( err => {
    next(err);
  })
});

todoRouter.delete("/todos/:id", ensureUsersModifyOnlyOwnTodos, (req, res, next) => {
  TodoController.delete(req).then( (item) => {
    if(item)
      res.json(item);
    else 
      next({status: 404, message: "Todo not found"});
  }).catch( err => {
    next(err);
  })
});


todoRouter.put("/todos/:id", ensureUsersModifyOnlyOwnTodos, (req, res, next) => {
  TodoController.update(req.params.id, req.body).then( (item) => {
    if(item)
      res.json(item);
    else 
      next({status: 404, message: "Todo not found"});
  }).catch( err => {
    next(err);
  })
});