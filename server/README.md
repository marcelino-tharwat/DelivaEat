# DelivaEat Backend (Node.js/Express + MongoDB)

Authentication API using Express, Mongoose, JWT. Stores users in MongoDB Atlas.

## Setup

1. Copy env example and fill values:

```
cp .env.example .env
```

Then set:
- `MONGODB_URI` to your Atlas connection string
- `JWT_SECRET` to a long random string
- Optional: `MONGODB_DB` to force a database name

2. Install dependencies:

```
npm install
```

3. Run in dev mode (auto-reload):

```
npm run dev
```

Server starts on `http://localhost:5000` by default.

## Environment variables

- `PORT` — default 5000
- `MONGODB_URI` — full MongoDB Atlas connection string
- `MONGODB_DB` — optional db name override
- `JWT_SECRET` — required
- `JWT_EXPIRES_IN` — defaults to `7d`

## API

Base URL: `/api/auth`

- POST `/register`
  - Body: `{ "name": string, "email": string, "password": string }`
  - 201: `{ user, token }`

- POST `/login`
  - Body: `{ "email": string, "password": string }`
  - 200: `{ user, token }`

- GET `/me`
  - Header: `Authorization: Bearer <token>`
  - 200: `{ user }`

### cURL examples

Register:
```
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Ahmed","email":"ahmed@example.com","password":"secret123"}'
```

Login:
```
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ahmed@example.com","password":"secret123"}'
```

Get profile:
```
curl http://localhost:5000/api/auth/me \
  -H "Authorization: Bearer <TOKEN>"
```

## Folder structure

```
server/
  src/
    config/db.js
    controllers/authController.js
    middleware/auth.js
    models/User.js
    routes/authRoutes.js
    utils/jwt.js
    validators/authValidators.js
    index.js
  .env.example
  package.json
  README.md
```

## Notes

- Passwords are hashed with bcrypt.
- JWT payload uses `sub` as the user id.
- Mongoose `strictQuery` is enabled.
