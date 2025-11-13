import { User, Todo } from "../models/Database.js";
import Jwt from "jsonwebtoken";


export class AuthController {
  /**
   * Handles post requests on /auth. Checks that the given credentials are valid
   * @param {http.IncomingMessage} request 
   * @param {http.ServerResponse} response 
   */
  static async checkCredentials(req, res){
    let user = new User({ //user data specified in the request
      userName: req.body.usr, 
      password: req.body.pwd
    });

    let found = await User.findOne({
      where: {
        userName: user.userName,
        password: user.password //password was hashed when creating user
      }
    });

    return found !== null;
  }

  /**
   * Attempts to create a new User
   */
  static async saveUser(req, res){
    //save new user
    let user = new User({
      userName: req.body.usr, 
      password: req.body.pwd
    });
    return user.save(); //returns a Promise
  }

  static issueToken(username){
    return Jwt.sign({user:username}, process.env.TOKEN_SECRET, {expiresIn: `${24*60*60}s`});
  }

  static isTokenValid(token, callback){
    Jwt.verify(token, process.env.TOKEN_SECRET, callback);
  }

  static async canUserModifyTodo(user, todoId){
    const todo = await Todo.findByPk(todoId);
    //todo must exist and be associated with user
    return todo && todo.UserUserName === user;
  }
}