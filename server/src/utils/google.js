const { OAuth2Client } = require('google-auth-library');

let oauthClient;

function getAllowedAudiences() {
  // Prefer GOOGLE_AUDIENCES (comma-separated). Fallback to single GOOGLE_CLIENT_ID for backward compat.
  const { GOOGLE_AUDIENCES, GOOGLE_CLIENT_ID } = process.env;
  const list = (GOOGLE_AUDIENCES || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  if (list.length > 0) return list;
  if (GOOGLE_CLIENT_ID) return [GOOGLE_CLIENT_ID];
  throw new Error('Missing Google audience configuration. Set GOOGLE_AUDIENCES (comma-separated) or GOOGLE_CLIENT_ID in the environment.');
}

function getClient() {
  if (!oauthClient) {
    // OAuth2Client does not enforce audience here; verification will.
    oauthClient = new OAuth2Client();
  }
  return oauthClient;
}

async function verifyGoogleIdToken(idToken) {
  const client = getClient();
  const audiences = getAllowedAudiences();
  const ticket = await client.verifyIdToken({ idToken, audience: audiences });
  const payload = ticket.getPayload();
  if (!payload) return null;
  return {
    email: payload.email,
    name: payload.name,
    picture: payload.picture,
    sub: payload.sub,
    email_verified: payload.email_verified,
    aud: payload.aud,
  };
}

module.exports = { verifyGoogleIdToken };
