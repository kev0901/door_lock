import axios from "axios";
import * as qs from "qs";
import { IKeycloakUser, TAllowedKeycloakOperation, TCb, TCb1 } from "../common/interface";
import { REQUEST_RETRY_COUNT, REQUEST_RETRY_DELAY_MS } from "../common/value";
import config from "../config";
import * as logic_assert from "./logic_assert";

// const qs = require('qs');
//
// todo: get access token by entering admin id/pw from secret to config.
// todo: change quickstart to realmName
// todo: move get|post to interface file

const userUrl = "/admin/realms/quickstart/users";
const getTokenUrl = "/realms/quickstart/protocol/openid-connect/token";
function changePasswordUrl(userId: string) {
  return `/admin/realms/quickstart/users/${userId}/reset-password`;
}

function getTokenFromAuthServer(callBackFunc: TCb1<string>) {
  const headers = {
    "content-type": "application/x-www-form-urlencoded",
    Accept: "application/json",
  };

  axios({
    url: config.AUTH_SERVER_URL + getTokenUrl,
    method: "post",
    headers,
    data: qs.stringify(config.token),
    timeout: 5000,
  })
    .then((response) => {
      callBackFunc(null, response.data.access_token);
    })
    .catch((err: any) => {
      logic_assert.logError(err, callBackFunc);
    });
}

function requestToAuthServer<T>(
  url: string,
  data: any,
  params: any,
  method: TAllowedKeycloakOperation,
  callBackFunc: TCb1<T>,
) {
  getTokenFromAuthServer((err, token) => {
    if (logic_assert.logError(err, callBackFunc)) return;

    const headers = {
      "content-type": "application/json",
      authorization: `Bearer ${token}`,
    };

    axios({
      headers,
      url: config.AUTH_SERVER_URL + url,
      data: JSON.stringify(data),
      params,
      method,
      timeout: 5000,
    })
      .then((response) => {
        if (response?.status < 200 && response?.status >= 300) {
          const newErr = new Error(response.data);
          callBackFunc(newErr, response.data);
        }

        callBackFunc(null, response.data);
      })
      .catch((err2) => {
        logic_assert.logError(err2, callBackFunc);
      });
  });
}

function requestToAuthServerWithRetry<T>(
  url: string,
  reqBody: any,
  reqParams: any,
  method: TAllowedKeycloakOperation,
  retryCount: number,
  callBackFunc: TCb1<T>,
) {
  requestToAuthServer<T>(url, reqBody, reqParams, method, (err, resBody) => {
    if (!err) {
      callBackFunc(null, resBody);
      return;
    }
    /// error cases
    if (retryCount <= 0) {
      callBackFunc(err, null as T);
    } else {
      setTimeout(() => {
        requestToAuthServerWithRetry<T>(url, reqBody, reqParams, method, retryCount - 1, callBackFunc);
      }, REQUEST_RETRY_DELAY_MS);
    }
  });
}

export function getUserInfo(username: string, callBackFunc: TCb1<IKeycloakUser>) {
  const data = {
    username,
  };
  requestToAuthServerWithRetry<IKeycloakUser[]>(
    userUrl,
    null,
    data,
    "get",
    REQUEST_RETRY_COUNT,
    (err, res) => {
      if (logic_assert.logError(err, callBackFunc)) return;

      if (res.length < 1) {
        logic_assert.logWithNewErrorMsg("getUserInfo response is wrong", callBackFunc);
        return;
      }

      callBackFunc(null, res[0]);
    },
  );
}

export function changePassword(username: string, password: string, callBackFunc: TCb) {
  getUserInfo(username, (err, userInfo) => {
    if (logic_assert.logError(err, callBackFunc)) return;

    const userId = userInfo.id;
    if (!userId) {
      logic_assert.logWithNewErrorMsg("changePassword, userInfo is worng", callBackFunc);
      return;
    }

    const passwordChangeData = {
      type: "password",
      temporary: false,
      value: password,
    };

    requestToAuthServerWithRetry(
      changePasswordUrl(userId),
      passwordChangeData,
      null,
      "put",
      REQUEST_RETRY_COUNT,
      callBackFunc,
    );
  });
}

export function addUser(
  firstName: string,
  lastName: string,
  username: string,
  password: string,
  email: string,
  callBackFunc: TCb,
) {
  const registerData = {
    firstName,
    lastName,
    username,
    email,
    enabled: false,
  };

  requestToAuthServerWithRetry(userUrl, registerData, null, "post", REQUEST_RETRY_COUNT, (err) => {
    if (logic_assert.logError(err, callBackFunc)) return;

    changePassword(username, password, callBackFunc);
  });
}
