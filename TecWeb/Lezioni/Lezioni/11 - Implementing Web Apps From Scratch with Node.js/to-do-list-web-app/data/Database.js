import sqlite3 from "sqlite3";

const DBFILE = "./database.db";

export class Database {

  resetDatabase(){
    const db = new sqlite3.Database(DBFILE);
    db.serialize( () => {
      //drop tables if exist
      db.run("DROP TABLE IF EXISTS todos");
      //create todos table
      db.run(`
        CREATE TABLE todos ( 
          todo TEXT, 
          creation_date TEXT
        )
      `);
    });
    db.close();
  }

  /**
   *
   */
  getTodos(username){
    const db = new sqlite3.Database(DBFILE);
    return new Promise(function(resolve, reject){
      db.all(
        `SELECT * FROM todos`, 
        (err, row) => {
          db.close();
          if(err){
            console.error(err); reject(err);
          }
          return resolve(row);
        }
      );
    });
  }

  saveTodo(todo){
    const db = new sqlite3.Database(DBFILE);
    return new Promise(function(resolve, reject){
      db.run(
        "INSERT INTO todos(todo, creation_date) VALUES (?,?)", 
        [todo.todo, todo.creation_date], 
        (result, error) => {
          db.close();
          if(error){
            reject("An error occurred");
          } else {
            resolve(true);
          }
        }
      );
    });
  }
}