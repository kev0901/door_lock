import * as express from 'express';
// import * as bodyParser from 'body-parser';
import * as router_main from './router/routerMain';
const app = express();

// app.use(bodyParser.json());
app.use(express.json());

const server = app.listen(3000, function () {
    console.log("Express server has started on port 3000");
})

// const router = express.Router();

// router.get('/', (request, response) => {
//     response.send('Hello world!');
// });

app.use('/', router_main.router);
// router.get('/hello', (request, response) => {
//     response.send('Hello world! version 2');
// });

// app.use('/api', router);
