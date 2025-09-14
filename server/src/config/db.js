const mongoose = require('mongoose');

async function connectDB() {
  const uri = process.env.MONGODB_URI;
  if (!uri) {
    throw new Error('MONGODB_URI is not set in environment variables');
  }

  mongoose.set('strictQuery', true);

  await mongoose.connect(uri, {
    dbName: process.env.MONGODB_DB || undefined,
    autoIndex: true,
  });

  console.log('Connected to MongoDB');
}

module.exports = { connectDB };
