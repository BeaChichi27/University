import http from "http"
import pug from "pug"

/**
 * Handle requests to the homepage
 * @param {http.ClientRequest} request 
 * @param {http.ServerResponse} response 
 */
export function renderHomepage(request, response, context={}){
  let renderedContent = pug.renderFile("./templates/homepage.pug", context);
  response.writeHead(200, {"Content-Type": "text/html"});
  response.end(renderedContent);
}