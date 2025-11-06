import { Todo} from "../models/Database.js";

export class TodoController {
  
  static async getTodosForCurrentUser(req){
    return Todo.findAll({
      where: {
        UserUserName: req.username
      }
    })
  }
  
  static async saveTodo(req){
    let todo = Todo.build(req.body);
    todo.UserUserName = req.username;
    return todo.save();
  }

  static async findById(req){
    return Todo.findByPk(req.params.id);
  }

  static async update(id, updated){
    let todo = await Todo.findByPk(id);
    todo.set(updated); //update using fields which were passed in request
    return todo.save();
  }

  static async delete(req){
    return new Promise( (resolve, reject) => {
      this.findById(req).then( item => {
        item.destroy().then( () => {resolve(item)})
      })
    })
  }
}