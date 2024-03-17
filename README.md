# Express is a Xojo API 2.0 compliant WebServer

Express is optimized for speed. It's based on AloeExpress *(API 1.0)* and will be cleaned up and improved continuously.
Note that we aim to keep all features, but they may break over time since the Xojo API changed to 2.0.
Improvements to code efficiency is in the works and will be the main target for this repository.


## Documentation

### Express Change Log

The change logs are available within the provided Express Demo project:
- `Modules -> Express -> Notes`

### Express Demo Projects

Learn by looking at the Demo Projects how to use Express in a Xojo built application.
They contain several demos showing various features of Express.
- `Express-Demo-Console.xojo_project`
- `Express-Demo-GUI.xojo_project`

### Deployment

Express runs as a Xojo Built Console or Desktop application.  
The following tutorials give you an idea how to:

- [Run Express in Docker](./docs/docker/Express2Docker.pdf)
- [Deploy Express with Lifeboat](./docs/lifeboat/Express2Lifeboat.pdf)
  - *[Lifeboat](https://strawberrysw.com/lifeboat/) is a product of Strawberry Software (by Tim Parnell).  
  Lifeboat makes it simple to deploy and manage your Xojo Web applications on a Linux server.*

## Express supports http Keep-Alive And WebSockets (server)

In combination with URLConnection (in for example desktop/ios etc) this improves connectivity 
and drastically speeds up the connections. This allows for the removal of SSE (server sent events) etc
and just keep the connection itself (single connection) alive allowing for much more clients to remain
connected. This directly competes against Xojo's WebApplication that does NOT allow http Keep-Alive 
*(at least not in the same App.HandleURL context)* and thus is not HTTP/1.1 compliant. 
Express aims to be as much as we can to be HTTP 1.1 compliant. If something is missing
please create an issue. 

## Important changes in Express that fixes some issues from AloeExpress 4.1 (last version of AE)

- Fixed a memory leak where AloeExpress.Response was being referenced forever.
- Fixed an issue in POST/PUT/PATCH (with a body) requests where the Content-Length was incorrectly compared.
- Fixed an issue where the server would become overloaded in CPU %. The process now has a algorithm in Express.Server.Start that speeds up processing depending on if it's threaded or not.
- Express is API 2.0 compliant and we removed all Text, Auto and Xojo.* datatypes.
- Improved speed ease of use for the (weakref) properties Server, Client (Request).


## Express is originally based on AloeExpress (deprecated)

AloeExpress originally developed by Tim Dietrich  
Website: https://aloe.zone  
Archive of base version: https://aloe.zone/archives.php  
The base code is provided by Tim via an MIT License held in the project file that I have duplicated for visibility in the repository.  
You can find Tim Dietrich's page here: https://timdietrich.me/


> If you find any errors please open an issue or fork the repo and create a pull request.
