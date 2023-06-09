import { knex, Knex } from 'knex';
import mysql = require('mysql2');
import config from '../config';

const knexConfig: Knex.Config = {
  client: 'mysql2',
  connection: {
    host: config.MYSQL_HOST,
    port: config.MYSQL_PORT,
    user: config.MYSQL_USER,
    password: config.MYSQL_PASSWORD,
    database: config.MYSQL_SCHEMA,
    decimalNumbers: true,
    // typeCast: typeCastFunction,
  },
  // debug: true, // if you want to expose raw queries of knex, set it true
};
export const client = knex(knexConfig);
