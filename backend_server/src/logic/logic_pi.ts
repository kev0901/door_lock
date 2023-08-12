import axios from "axios";
import { TCb1 } from "../common/interface";
import { REQUEST_RETRY_COUNT, REQUEST_RETRY_DELAY_MS } from "../common/value";
import config from "../config";
import * as logic_assert from "./logic_assert";
// import * as db_user from "../database/db_user";

function requestToPiServer<T>(url: string, data: any, callBackFunc: TCb1<T | null>) {
  axios
    .post(config.PI_SERVER_URL + url, data, { timeout: 5000 })
    .then((response) => {
      if (response?.status < 200 && response?.status >= 300) {
        const newErr = new Error(response.data);
        callBackFunc(newErr, response.data);
      }

      callBackFunc(null, response.data);
    })
    .catch((err) => {
      logic_assert.logError(err, callBackFunc);
    });
}

function requestToPiServerWithRetry<T>(
  url: string,
  reqBody: any,
  retryCount: number,
  callBackFunc: TCb1<T | null>,
) {
  requestToPiServer<T>(url, reqBody, (err, resBody) => {
    if (!err) {
      callBackFunc(null, resBody);
      return;
    }
    /// error cases
    if (retryCount <= 0) {
      callBackFunc(err, null);
    } else {
      setTimeout(() => {
        requestToPiServerWithRetry<T>(url, reqBody, retryCount - 1, callBackFunc);
      }, REQUEST_RETRY_DELAY_MS);
    }
  });
}

export function unlock(callBackFunc: (err: NodeJS.ErrnoException | null, isOpened: boolean) => void) {
  requestToPiServerWithRetry("/unlock", null, REQUEST_RETRY_COUNT, (err) => {
    if (logic_assert.logError(err, callBackFunc)) return;

    callBackFunc(null, true);
  });
}

// export function unlock(
//   userId: string,
//   callBackFunc: (err: NodeJS.ErrnoException | null, isOpened: boolean) => void,
// ) {
//   db_user.getUser(userId, (err, user) => {
//     if (err) throw err;

//     if (!user) {
//       callBackFunc(null, false);
//       return;
//     }

//     requestToPiServerWithRetry("/unlock", null, REQUEST_RETRY_COUNT, (err2, body) => {
//       if (err2) {
//         throw err2;
//       }

//       if (body) {
//         // todo: body check a lil more strictly suchas : body.isOpened
//         callBackFunc(null, true);
//         return;
//       }

//       callBackFunc(null, false);
//     });
//   });
//   // db check
//   // unlock api request
// }

export default unlock;
