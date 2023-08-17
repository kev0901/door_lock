const baseUrl = 'http://host.docker.internal:5050';

export default {
  baseUrl: baseUrl,
  token: {
    username: 'alice',
    password: 'alice',
    grant_type: 'password',
    client_id: 'test-cli',
    realmName: 'quickstart'
  },
  adminClient: {
    baseUrl: baseUrl,
    realmName: 'master',
    username: 'admin',
    password: 'password',
    grantType: 'password',
    clientId: 'admin-cli'
  }
};
