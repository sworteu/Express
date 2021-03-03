# Express is a Xojo API 2.0 compilant webserver
Express is Optimized for speed, it's based on AloeExpress (API 1.0) and will be cleaned up and improved continuesly.
Note that we aim to keep all features, but they may break over time since the Xojo API changed to 2.0.
Improvements to code efficiency is in the works and will be the main target for this repository.

## Important changes in Express that fixes some issues from AloeExpress 4.2.4 (last version of AE)
- Fixed a memory leak where AloeExpress.Response was being refrenced forever.
- Fixed an issue in POST/PUT/PATCH (with a body) requests where the Content-Length was incorrectly compared.
- Fixed an issue where the server would become overloaded in CPU %. The process now has a algorithm in Express.Server.Start that speeds up processing depending on if it's threaded or not.
- Express is API 2.0 compilant and we removed all Text, Auto and Xojo.* datatypes.


### Express is originally based on AloeExpress (deprecated)
Aloe Express originally developed by Tim Dietrich
Website: https://aloe.zone
Archive of base version: https://aloe.zone/archives.php
The base code is provided by Tim via an MIT License held in the project file that I have duplicated for visibility in the repository.

> If you find any errors please open an issue or fork the repo and create a pull request.

