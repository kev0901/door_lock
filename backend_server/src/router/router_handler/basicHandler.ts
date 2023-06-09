import * as express from 'express'
import * as logic_pi from '../../logic/logic_pi'
import * as logic_user from '../../logic/logic_user'

export function main(req: express.Request, res: express.Response) {
    return res.status(200).json({
        status: 200,
        message: 'Hello World!'
    });
}

export function addUser(req: express.Request, res: express.Response) {
    const body = req.body;

    const name = body.name;
    const email = body.email;
    const password = body.password;

    let isValid = true;
    isValid = isValid && name;
    isValid = isValid && email;
    isValid = isValid && password;

    if(!isValid) {
      return res.status(500).json({
        message: 'error happened'
      })
    }

    logic_user.addUser(name, email, password, (err) => {
      if(err) throw err;

      return res.status(200).json({
        status: 200,
        message: `Tryna add ${body.name}`
    });
    })
}

export function unlock(req: express.Request, res: express.Response) {
    const body = req.body;
    const userId = body.user_id;

    let isValid = true;
    isValid = isValid && userId;

    if(!isValid) {
      return res.status(500).json({
        message: 'error happened'
      })
    }
    logic_pi.unlock(userId, (err, isOpened) => {
      if(err) {
        return res.status(500).json({
          message: 'error happened'
        })
      }

      if(!isOpened) {
        return res.status(200).json({
          message: 'Still Locked.'
        })
      }

      return res.status(200).json({
        message: `Unlocked.`
    });
  })
}

export function adminLogin(req: express.Request, res: express.Response) {
    const body = req.body;
    return res.status(200).json({
        status: 200,
        message: `Admin Page`
    });
}
