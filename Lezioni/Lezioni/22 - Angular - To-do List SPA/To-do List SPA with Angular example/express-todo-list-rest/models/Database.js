import { Sequelize } from "sequelize";
import { createModel as createUserModel } from "./User.js";
import { createModel as createTodoModel } from "./Todo.js";

import 'dotenv/config.js'; //read .env file and make it available in process.env

export const database = new Sequelize(process.env.DB_CONNECTION_URI, {
  dialect: process.env.DIALECT
});

createUserModel(database);
createTodoModel(database);

export const {User, Todo} = database.models;

//associations configuration
User.Todos = User.hasMany(Todo);
Todo.User = Todo.belongsTo(User);

//synchronize schema (creates missing tables)
database.sync().then( () => {
  console.log("Database synced correctly");
}).catch( err => {
  console.err("Error with database synchronization: " + err.message);
});