const defaultSettings: { [key: string]: any } = {
  MYSQL_HOST: "127.0.0.1",
  MYSQL_PORT: "3306",
  MYSQL_USER: "root",
  MYSQL_PASSWORD: "",
  MYSQL_SCHEMA: "database",
  MYSQL_SYNCHRONIZE: "true",

  PI_SERVER_URL: "",
  AUTH_SERVER_URL: "",

  token: {
    username: "admin",
    password: "admin",
    grant_type: "password",
    client_id: "test-cli",
    realmName: "quickstart",
  },
};

Object.keys(defaultSettings).forEach((key) => {
  defaultSettings[key] = process.env[key] != null ? process.env[key] : defaultSettings[key];
});

export default defaultSettings;
