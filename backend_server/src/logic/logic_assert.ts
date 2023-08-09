export function logError(err: any, callBackFunc: any) {
  if (err != null) {
    /* eslint-disable-next-line no-console */
    console.log(err);
    callBackFunc(err);
    return true;
  }
  return false;
}

export function logWithNewErrorMsg(msg: string, callBackFunc: any) {
  const error = new Error(msg);
  /* eslint-disable-next-line no-console */
  console.log(error);
  callBackFunc(error);
}
