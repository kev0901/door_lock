import * as express from "express";
import * as Keycloak from "keycloak-connect";
import * as basic_handler from "./router_handler/basicHandler";

export const router = express.Router();

// todo: think about how to add keycloak.json info from docker start
const keycloak = new Keycloak(
  {},
  {
    realm: "quickstart",
    "bearer-only": true,
    "auth-server-url": "http://host.docker.internal:5050",
    "ssl-required": "external",
    resource: "door_lock",
    "confidential-port": "null",
  },
);

router.use(keycloak.middleware());

const METHOD_TYPE = {
  POST: "POST",
  GET: "GET",
  PUT: "PUT",
  DELETE: "DELETE",
};
interface IRouter {
  uri: string;
  handler: (req: express.Request, res: express.Response) => any;
  method: (typeof METHOD_TYPE)[keyof typeof METHOD_TYPE];
}

const routerList: IRouter[] = [
  {
    uri: "/unlock",
    handler: basic_handler.unlock,
    method: METHOD_TYPE.POST,
  },
];

routerList.forEach((eachRouter) => {
  switch (eachRouter.method) {
    case METHOD_TYPE.GET:
      router.get(eachRouter.uri, keycloak.protect("realm:user"), eachRouter.handler);
      break;
    case METHOD_TYPE.POST:
      router.post(eachRouter.uri, keycloak.protect("realm:user"), eachRouter.handler);
      break;
    case METHOD_TYPE.PUT:
      router.put(eachRouter.uri, keycloak.protect("realm:user"), eachRouter.handler);
      break;
    case METHOD_TYPE.DELETE:
      router.delete(eachRouter.uri, keycloak.protect("realm:user"), eachRouter.handler);
      break;
    default:
      router.get(eachRouter.uri, eachRouter.handler);
  }
});

export default router;
