import * as express from 'express'
import * as basic_handler from './router_handler/basicHandler'
export const router = express.Router();

const METHOD_TYPE = {
    "POST": "POST",
    "GET": "GET",
    "PUT": "PUT",
    "DELETE": "DELETE"
}
interface IRouterList {
    uri: string;
    handler: (req: express.Request, res: express.Response) => any;
    method: typeof METHOD_TYPE[keyof typeof METHOD_TYPE];
}

const routerList: IRouterList[] = [
    {
        uri: '/',
        handler: basic_handler.main,
        method: METHOD_TYPE.GET
    },
    {
        uri: '/addUser',
        handler: basic_handler.addUser,
        method: METHOD_TYPE.POST
    }
]

routerList.map(eachRouter => {
    switch (eachRouter.method) {
        case METHOD_TYPE.GET:
            router.get(eachRouter.uri, eachRouter.handler);
            break;
        case METHOD_TYPE.POST:
            router.post(eachRouter.uri, eachRouter.handler);
            break;
        case METHOD_TYPE.PUT:
            router.put(eachRouter.uri, eachRouter.handler);
            break;
        case METHOD_TYPE.DELETE:
            router.delete(eachRouter.uri, eachRouter.handler);
            break;
    }
})
