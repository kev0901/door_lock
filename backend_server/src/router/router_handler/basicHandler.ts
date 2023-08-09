/* eslint-disable consistent-return */

import * as express from "express";
import * as logic_pi from "../../logic/logic_pi";
import * as logic_user from "../../logic/logic_user";

export function main(req: express.Request, res: express.Response) {
  return res.status(200).json({
    status: 200,
    message: "Hello World!",
  });
}

export function addUser(req: express.Request, res: express.Response) {
  const { body } = req;

  const { firstName, lastName, username, email, password } = body;

  let isValid = true;
  isValid = isValid && firstName;
  isValid = isValid && lastName;
  isValid = isValid && username;
  isValid = isValid && email;
  isValid = isValid && password;

  if (!isValid) {
    return res.status(500).json({
      message: "error happened",
    });
  }

  logic_user.addUser(firstName, lastName, username, password, email, (err) => {
    if (err) {
      /* eslint-disable-next-line no-console */
      console.log(err);
      return res.status(500).json({
        message: JSON.stringify(err),
      });
    }

    return res.status(200).json({
      status: 200,
      message: `Tryna add ${username}`,
    });
  });
}

export function unlock(req: express.Request, res: express.Response) {
  const { body } = req;
  const userId = body.user_id;

  let isValid = true;
  isValid = isValid && userId;

  if (!isValid) {
    return res.status(500).json({
      message: "error happened",
    });
  }
  logic_pi.unlock(userId, (err, isOpened) => {
    if (err) {
      return res.status(500).json({
        message: "error happened",
      });
    }

    if (!isOpened) {
      return res.status(200).json({
        message: "Still Locked.",
      });
    }

    return res.status(200).json({
      message: `Unlocked.`,
    });
  });
}
