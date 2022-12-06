"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const bodyParser = require("body-parser");
const app = express();
app.use(bodyParser.json());
const server = app.listen(3000, function () {
    console.log("Express server has started on port 3000");
});
const router = express.Router();
app.get('/', (request, response) => {
    // response.send('Hello world!');
    response.send(request.body);
});
