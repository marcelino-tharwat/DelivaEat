const { OAuth2Client } = require('google-auth-library');

let oauthClient;

function getClient() {
  const { GOOGLE_CLIENT_ID } = process.env;
  if (!GOOGLE_CLIENT_ID) {
    throw new Error('GOOGLE_CLIENT_ID is not set in environment');
  }
  if (!oauthClient) {
    oauthClient = new OAuth2Client(GOOGLE_CLIENT_ID);
  }
  return oauthClient;
}

async function verifyGoogleIdToken(idToken) {
  const client = getClient();
  const ticket = await client.verifyIdToken({ idToken, audience: process.env.GOOGLE_CLIENT_ID });
  const payload = ticket.getPayload();
  if (!payload) return null;
  return {
    email: payload.email,
    name: payload.name,
    picture: payload.picture,
    sub: payload.sub,
    email_verified: payload.email_verified,
  };
}

module.exports = { verifyGoogleIdToken };
