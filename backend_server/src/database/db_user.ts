import { uuid } from "uuidv4";
import { IUser } from "../common/interface";
import * as knex from "./knex";

export function getUser(
  user_id: string,
  callBackFunc: (err: NodeJS.ErrnoException | null, user: IUser | null) => void,
) {
  knex
    .client("user")
    .select()
    .where({
      user_id,
    })
    .asCallback((err: Error, userList: IUser[]) => {
      if (err) throw err;

      if (userList.length > 0) {
        callBackFunc(null, userList[0]);
        return;
      }

      callBackFunc(null, null);
    });
}

export function addUser(
  name: string,
  email: string,
  password: string,
  callBackFunc: (err: NodeJS.ErrnoException | null) => void,
) {
  knex
    .client("user")
    .insert({
      user_id: uuid(),
      name,
      email,
      password,
    })
    .asCallback((err: Error) => {
      if (err) throw err; // todo: on conflict 등 에러 처리

      callBackFunc(null);
    });
}
