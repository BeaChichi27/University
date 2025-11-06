import { DataTypes } from "sequelize";

export function createModel(database){
  database.define('Todo', {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    todo: {
      type: DataTypes.TEXT
    },
    done: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
      allowNull: false
    }
    //by default, Sequelize adds the createdAt and updatedAt fields to all models
  }, {

  })
}

