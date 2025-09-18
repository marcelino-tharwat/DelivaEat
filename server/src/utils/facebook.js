const https = require('https');

function httpsGetJson(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, (res) => {
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => {
          try {
            const json = JSON.parse(data);
            if (res.statusCode && res.statusCode >= 200 && res.statusCode < 300) {
              resolve(json);
            } else {
              const err = new Error('HTTP ' + res.statusCode);
              err.response = json;
              reject(err);
            }
          } catch (e) {
            reject(e);
          }
        });
      })
      .on('error', reject);
  });
}

async function verifyFacebookAccessToken(userAccessToken) {
  const { FACEBOOK_APP_ID, FACEBOOK_APP_SECRET } = process.env;
  if (!FACEBOOK_APP_ID || !FACEBOOK_APP_SECRET) {
    throw new Error('FACEBOOK_APP_ID or FACEBOOK_APP_SECRET is not set in environment');
  }
  const appAccessToken = `${FACEBOOK_APP_ID}|${FACEBOOK_APP_SECRET}`;
  const url = `https://graph.facebook.com/debug_token?input_token=${encodeURIComponent(
    userAccessToken
  )}&access_token=${encodeURIComponent(appAccessToken)}`;
  const json = await httpsGetJson(url);
  return json && json.data ? json.data : null;
}

async function getFacebookProfile(userAccessToken) {
  const fields = ['id', 'name', 'email', 'picture.type(large)'].join(',');
  const url = `https://graph.facebook.com/v18.0/me?fields=${encodeURIComponent(fields)}&access_token=${encodeURIComponent(
    userAccessToken
  )}`;
  const json = await httpsGetJson(url);
  return json;
}

module.exports = { verifyFacebookAccessToken, getFacebookProfile };
