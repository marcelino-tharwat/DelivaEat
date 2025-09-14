require('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const { connectDB } = require('./config/db');
const { configureCloudinary } = require('./config/cloudinary');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const compression = require('compression');
const pinoHttp = require('pino-http');
const pino = require('pino');
const { notFound, errorHandler } = require('./middleware/errorHandler');

const authRoutes = require('./routes/authRoutes');
const uploadRoutes = require('./routes/uploadRoutes');
const merchantApi = require('./api/merchant');
const riderApi = require('./api/rider');

const app = express();

// Trust proxy when behind load balancers
if (process.env.NODE_ENV === 'production') {
  app.set('trust proxy', 1);
}

// Middleware
const allowedOrigins = (process.env.CORS_ORIGINS || '')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);

app.use(
  cors({
    origin: function (origin, cb) {
      if (!origin) return cb(null, true); // allow server-to-server and local tools
      if (allowedOrigins.length === 0 || allowedOrigins.includes(origin)) return cb(null, true);
      return cb(new Error('Not allowed by CORS'));
    },
    credentials: true,
  })
);
app.use(express.json());
app.use(morgan('dev'));
app.use(helmet());
app.use(compression());

// Structured logging
const logger = pino({ level: process.env.LOG_LEVEL || 'info' });
app.use(pinoHttp({ logger }));

// Rate limit for all API routes
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: { code: 'RATE_LIMITED', message: 'Too many requests' } },
});
app.use('/api', apiLimiter);

// Health check
app.get('/health', (req, res) => {
  res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/merchant', merchantApi);
app.use('/api/rider', riderApi);

// 404 and error handlers
app.use(notFound);
app.use(errorHandler);

// Start
const PORT = process.env.PORT || 5000;

connectDB()
  .then(() => {
    // Configure Cloudinary after env is loaded
    configureCloudinary();
    app.listen(PORT, () => {
      console.log(`Server listening on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Failed to start server due to DB error:', err.message);
    process.exit(1);
  });
