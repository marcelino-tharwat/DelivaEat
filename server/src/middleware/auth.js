const User = require('../models/User');
const { verifyToken } = require('../utils/jwt');

async function auth(req, res, next) {
  try {
    const authHeader = req.headers.authorization || '';
    const [scheme, token] = authHeader.split(' ');
    if (scheme !== 'Bearer' || !token) {
      return res.status(401).json({
        success: false,
        error: { code: 'UNAUTHORIZED', message: 'Unauthorized (غير مصرح).' },
      });
    }
    const decoded = verifyToken(token);
    const user = await User.findById(decoded.sub).select('-password');
    if (!user) {
      return res.status(401).json({
        success: false,
        error: { code: 'UNAUTHORIZED', message: 'Unauthorized (غير مصرح).' },
      });
    }
    req.user = user;
    next();
  } catch (err) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Unauthorized (غير مصرح).' },
    });
  }
}

module.exports = { auth };
