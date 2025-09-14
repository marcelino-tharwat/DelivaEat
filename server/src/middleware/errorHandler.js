function notFound(req, res, next) {
  return res.status(404).json({
    success: false,
    error: { code: 'NOT_FOUND', message: 'Route not found' },
  });
}

function errorHandler(err, req, res, next) {
  const status = err.status || 500;
  const code = err.code || 'INTERNAL_ERROR';
  const message = err.message || 'Internal server error';

  const payload = {
    success: false,
    error: { code, message },
  };

  if (process.env.NODE_ENV !== 'production' && err.stack) {
    payload.debug = { stack: err.stack };
  }

  return res.status(status).json(payload);
}

module.exports = { notFound, errorHandler };
