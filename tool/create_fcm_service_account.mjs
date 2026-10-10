import fs from 'fs';
import https from 'https';
import { URL } from 'url';

const PROJECT = 'echo-65c23';
const SA_ID = 'echo-fcm';
const SA_EMAIL = `${SA_ID}@${PROJECT}.iam.gserviceaccount.com`;
const OUT = 'C:\\dev\\Echo-Server\\firebase-service-account.json';
const CONF = 'C:\\Users\\Usuario\\.config\\configstore\\firebase-tools.json';

function request(method, url, { headers = {}, body } = {}) {
  return new Promise((resolve, reject) => {
    const u = new URL(url);
    const req = https.request(
      {
        method,
        hostname: u.hostname,
        path: u.pathname + u.search,
        headers: {
          ...headers,
          ...(body
            ? {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(body),
              }
            : {}),
        },
      },
      (res) => {
        let data = '';
        res.on('data', (c) => (data += c));
        res.on('end', () => {
          let json = null;
          try {
            json = data ? JSON.parse(data) : null;
          } catch {
            json = { raw: data };
          }
          resolve({ status: res.statusCode, json });
        });
      },
    );
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

async function refreshAccessToken(refreshToken) {
  // Firebase CLI client id (public)
  const body = new URLSearchParams({
    client_id:
      '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com',
    client_secret: 'FAKESECRET_u2v3w4x5y6z7a8b9c0d1',
    refresh_token: refreshToken,
    grant_type: 'refresh_token',
  }).toString();

  return new Promise((resolve, reject) => {
    const req = https.request(
      {
        method: 'POST',
        hostname: 'oauth2.googleapis.com',
        path: '/token',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Content-Length': Buffer.byteLength(body),
        },
      },
      (res) => {
        let data = '';
        res.on('data', (c) => (data += c));
        res.on('end', () => {
          const json = JSON.parse(data);
          if (!json.access_token) {
            reject(new Error(`token refresh failed: ${data}`));
            return;
          }
          resolve(json.access_token);
        });
      },
    );
    req.on('error', reject);
    req.write(body);
    req.end();
  });
}

async function main() {
  const conf = JSON.parse(fs.readFileSync(CONF, 'utf8'));
  let accessToken = conf.tokens?.access_token;
  const expiresAt = conf.tokens?.expires_at || 0;
  if (!accessToken || Date.now() >= expiresAt - 60_000) {
    accessToken = await refreshAccessToken(conf.tokens.refresh_token);
  } else {
    console.log('Using cached Firebase CLI access token');
  }
  const auth = { Authorization: `Bearer ${accessToken}` };

  // Ensure service account exists
  let sa = await request(
    'GET',
    `https://iam.googleapis.com/v1/projects/${PROJECT}/serviceAccounts/${SA_EMAIL}`,
    { headers: auth },
  );
  if (sa.status === 404) {
    console.log('Creating service account...');
    sa = await request(
      'POST',
      `https://iam.googleapis.com/v1/projects/${PROJECT}/serviceAccounts`,
      {
        headers: auth,
        body: JSON.stringify({
          accountId: SA_ID,
          serviceAccount: {
            displayName: 'Echo FCM',
            description: 'Send FCM push from Echo-Server',
          },
        }),
      },
    );
    if (sa.status >= 300) {
      throw new Error(`create SA failed ${sa.status}: ${JSON.stringify(sa.json)}`);
    }
  } else if (sa.status >= 300) {
    throw new Error(`get SA failed ${sa.status}: ${JSON.stringify(sa.json)}`);
  } else {
    console.log('Service account already exists');
  }

  // Grant Firebase Admin / messaging roles (best-effort)
  const roles = [
    'roles/firebase.admin',
    'roles/firebasecloudmessaging.admin',
    'roles/iam.serviceAccountTokenCreator',
  ];
  for (const role of roles) {
    const policyRes = await request(
      'POST',
      `https://cloudresourcemanager.googleapis.com/v1/projects/${PROJECT}:getIamPolicy`,
      { headers: auth, body: '{}' },
    );
    if (policyRes.status >= 300) {
      console.log('skip IAM get', role, policyRes.status);
      continue;
    }
    const policy = policyRes.json;
    const binding = (policy.bindings || []).find((b) => b.role === role);
    const member = `serviceAccount:${SA_EMAIL}`;
    if (binding) {
      if (!binding.members.includes(member)) binding.members.push(member);
    } else {
      policy.bindings = policy.bindings || [];
      policy.bindings.push({ role, members: [member] });
    }
    const setRes = await request(
      'POST',
      `https://cloudresourcemanager.googleapis.com/v1/projects/${PROJECT}:setIamPolicy`,
      {
        headers: auth,
        body: JSON.stringify({ policy }),
      },
    );
    console.log('IAM', role, setRes.status);
  }

  // Create key
  console.log('Creating key...');
  const keyRes = await request(
    'POST',
    `https://iam.googleapis.com/v1/projects/${PROJECT}/serviceAccounts/${SA_EMAIL}/keys`,
    {
      headers: auth,
      body: JSON.stringify({ privateKeyType: 'TYPE_GOOGLE_CREDENTIALS_FILE' }),
    },
  );
  if (keyRes.status >= 300) {
    throw new Error(`create key failed ${keyRes.status}: ${JSON.stringify(keyRes.json)}`);
  }
  const privateKeyData = Buffer.from(keyRes.json.privateKeyData, 'base64').toString('utf8');
  fs.writeFileSync(OUT, privateKeyData, 'utf8');
  console.log('Wrote', OUT);
}

main().catch((e) => {
  console.error(e.message || e);
  process.exit(1);
});
