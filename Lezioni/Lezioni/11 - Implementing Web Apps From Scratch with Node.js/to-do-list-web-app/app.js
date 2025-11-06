"use strict"

import http from 'http';
import fs from "fs";
import { renderHomepage } from './controllers/homepage.js';
import { handleResetRequest } from './controllers/reset.js';
import { handleError } from './utils.js';
import { handleTodoListRequest } from './controllers/todo.js';

const PORT = 3000;

let server = http.createServer();
server.listen(PORT);

server.on('request', handleRequest);

/**
 * Callback function to handle HTTP requests
 * @param {http.ClientRequest} request 
 * @param {http.ServerResponse} response 
 */
function handleRequest(request, response){
  switch(request.url){
    case "/":
      renderHomepage(request, response); 
      break;
    case "/reset":
      handleResetRequest(request, response);  
      break;
    case "/todo":
      handleTodoListRequest(request, response);  
      break;
    /* serve static files */
    case "/css/bootstrap.css":
      fs.readFile('./static/css/bootstrap.css', function(err, data){
        response.writeHead(200, {'Content-Type': 'text/css'});
        response.end(data, 'utf-8');
      });
      break;
    case "/js/bootstrap.bundle.js":
      fs.readFile('./static/js/bootstrap.bundle.js', function(err, data){
        response.writeHead(200, {'Content-Type': 'text/javascript'});
        response.end(data, 'utf-8');
      });
      break;
    case "/img/node.png":
      fs.readFile('./static/img/node.png', function(err, data){
        response.writeHead(200, {'Content-Type': 'image/png'});
        response.end(data, "binary");
      });
      break;
    /* 404 error for any other request */
    default:
      handleError(request, response, 404, "Web page not found");
  }
}

console.log(`Web app listening on port ${PORT}`)