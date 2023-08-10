import * as express from "express";
import * as router_main from "./router/routerMain";
import * as router_user_auth from "./router/routerUserAuth";

const app = express();
app.use(express.json());

const server = app.listen(3000, () => {
  /* eslint-disable-next-line no-console */
  console.log("Express server has started on port 3000");
});

app.use("/user_auth", router_user_auth.router);
app.use("/", router_main.router);

export default server;
