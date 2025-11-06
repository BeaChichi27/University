import http from "http";
import pug from "pug";

/**
 * 
 * @param {http.IncomingMessage} request 
 * @param {http.ServerResponse} response 
 */
export function handleError(request, response, statusCode=500, message="An error occurred"){
  let renderedContent = pug.renderFile("./templates/errorPage.pug", {"code": statusCode, "description": message});
  response.writeHead(statusCode, {"Content-Type": "text/html"});
  response.end(renderedContent);
}

/**
 * 
 * @param {http.IncomingMessage} request 
 */
export function parseRequestBody(request){
  return new Promise((resolve, reject) => {
    let body = [];
    request
      .on('data', chunk => { body.push(chunk); })
      .on('end', () => {
        body = Buffer.concat(body).toString();
        // at this point, `body` has the entire request body stored in it as a string
        let data = parseRequestBodyString(body);
        resolve(data);
      });
  });


  function parseRequestBodyString(body) {
    let data = {};
    let slices = body.split("&");
    for (let slice of slices) {
      let paramName = slice.split("=")[0];
      paramName = decodeURIComponent(paramName.replace(/\+/g, " "));
      let paramValue = slice.split("=")[1];
      paramValue = decodeURIComponent(paramValue.replace(/\+/g, " "));
      data[paramName] = paramValue;
    }
    return data;
  }
}

/**
 * This function checks whether the current user is authenticated. If the user
 * is authenticated, it returns [true, username], otherwise [false, undefined].
 * @param {http.IncomingMessage} request 
 */
export function checkUserAuthentication(request){
  let cookies = parseCookies(request);
  if(cookies.auth){
    return [true, cookies.username]
  } else {
    return [false, undefined];
  }
}

/**
 * Returns a list of cookies by parsing the Cookie header in the request.
 * @param {http.IncomingMessage} request 
 */
export function parseCookies(request){
  const list = {};
  const cookieHeader = request.headers?.cookie;
  if (!cookieHeader) return list;

  cookieHeader.split(`;`).forEach(function(cookie) {
      let [ name, ...rest] = cookie.split(`=`);
      name = name?.trim();
      if (!name) return;
      const value = rest.join(`=`).trim();
      if (!value) return;
      list[name] = decodeURIComponent(value);
  });

  return list;
}
