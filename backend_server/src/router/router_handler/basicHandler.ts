import * as express from 'express'

export function main(req: express.Request, res: express.Response) {
    return res.status(200).json({
        status: 200,
        message: 'Hello World!'
    });
}

export function addUser(req: express.Request, res: express.Response) {
    const body = req.body;
    return res.status(200).json({
        status: 200,
        message: `Tryna add ${body.username}`
    });
}

export function unlock(req: express.Request, res: express.Response) {
    const body = req.body;
    return res.status(200).json({
        status: 200,
        message: `Unlocked.`
    });
}

export default main;
