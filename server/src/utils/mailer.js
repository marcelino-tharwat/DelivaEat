const nodemailer = require('nodemailer');

function createTransport() {
  const { GMAIL_USER, GMAIL_PASS, MAIL_FROM } = process.env;

  if (!GMAIL_USER || !GMAIL_PASS) {
    throw new Error('Email configuration missing. Set GMAIL_USER and GMAIL_PASS in environment');
  }

  // Gmail with App Password
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: { user: GMAIL_USER, pass: GMAIL_PASS },
  });
  return { transporter, from: MAIL_FROM || GMAIL_USER };
}

async function sendMail({ to, subject, html, text }) {
  const { transporter, from } = createTransport();
  const opts = {
    from,
    to,
    subject,
    text: text || undefined,
    html: html || undefined,
  };
  await transporter.sendMail(opts);
}

module.exports = { sendMail };
