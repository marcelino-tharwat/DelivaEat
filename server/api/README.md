# API Contracts (Draft)

This folder documents the API contracts to align with the Flutter front-end. These are specifications only (no wiring here).

- Auth: `auth.md` — Login, Register, Profile
- Uploads: `upload.md` — Image and Avatar uploads

Conventions:
- Base URL: `http://localhost:5000`
- All success responses:
  `{ "success": true, "data": { ... } }`
- All error responses:
  `{ "success": false, "error": { "code": "ERROR_CODE", "message": "..." }, "details"?: [...] }`
- Roles mapping:
  - Flutter UI values: `User`, `Rider`, `Merchant`
  - Backend values: `user`, `rider`, `merchant`
