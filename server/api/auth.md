# Auth API (Draft Contracts)

Base URL: `http://localhost:5000`

All responses follow the unified schema:
- Success: `{ "success": true, "data": { ... } }`
- Error: `{ "success": false, "error": { "code": "ERROR_CODE", "message": "..." }, "details"?: [...] }`

Role mapping between Flutter UI and backend:
- Flutter: `User`, `Rider`, `Merchant`
- Backend: `user`, `rider`, `merchant`

Notes:
- Images should be uploaded to Cloudinary via the Upload API to get URLs, then included in the JSON below when applicable.
- Phone and role-specific fields will be stored in the database in later implementation steps (model updates pending).
- Social login supported: Google and Facebook.

## Environment variables
Set these in `server/.env`:

- `GOOGLE_CLIENT_ID`
- `FACEBOOK_APP_ID`
- `FACEBOOK_APP_SECRET`

---

## POST /api/auth/google
Content-Type: `application/json`

Body
- `idToken` string, required (Google ID token from Google Sign-In)

Responses
- 200 OK
```json
{
  "success": true,
  "data": {
    "user": { "id": "66e5...", "name": "Ahmed", "email": "ahmed@example.com", "avatarUrl": null, "role": "user", "createdAt": "..." },
    "token": "<jwt>"
  }
}
```
- 401 Invalid token
```json
{ "success": false, "error": { "code": "INVALID_GOOGLE_TOKEN", "message": "Invalid Google token" } }
```

---

## POST /api/auth/facebook
Content-Type: `application/json`

Body
- `accessToken` string, required (Facebook user access token from Facebook Login)

Notes
- The app verifies the token with `debug_token` and then fetches profile `id,name,email,picture`.
- Email may be missing if the user didn't grant the email permission; in that case the API returns an error `FACEBOOK_NO_EMAIL`.

Responses
- 200 OK
```json
{
  "success": true,
  "data": {
    "user": { "id": "66e5...", "name": "Ahmed", "email": "ahmed@example.com", "avatarUrl": "https://...", "role": "user", "createdAt": "..." },
    "token": "<jwt>"
  }
}
```
- 401 Invalid token
```json
{ "success": false, "error": { "code": "INVALID_FACEBOOK_TOKEN", "message": "Invalid Facebook token" } }
```
- 400 No email
```json
{ "success": false, "error": { "code": "FACEBOOK_NO_EMAIL", "message": "Facebook account has no email or permission not granted" } }
```

## POST /api/auth/register
Create a new user. Payload varies by selected role.

Content-Type: `application/json`

Common body fields (all roles):
- `name` string, required
- `email` string, required
- `password` string, required, min 6
- `phone` string, required
- `role` enum, one of: `user`, `rider`, `merchant` (map from UI value)
- `avatarUrl` string, optional (Cloudinary URL)

Optional location fields (if front provides):
- `address` string, optional
- `location` object, optional
  - `lat` number
  - `lng` number

### Role-specific

User (`role = user`)
- No extra required fields

Rider (`role = rider`)
- `vehicleType` enum, required: `motorcycle` | `bicycle` | `scooter`
- Document/image URLs (from Upload API), all optional initially:
  - `idCardUrl` string
  - `licenseUrl` string
  - `vehicleUrlFront` string
  - `vehicleUrlSide` string
  - `licensePlateUrl` string (may be required for motorcycle)

Merchant (`role = merchant`)
- `businessType` enum, required: `restaurant` | `grocery` | `pharmacy` | `bakery`
- `restaurantName` string, required
- `ownerName` string, required
- `ownerPhone` string, required
- `description` string, optional
- `deliveryRadius` number (km), required
- Optional location fields as above

### Request examples

Register User
```json
{
  "name": "Ahmed Ali",
  "email": "ahmed@example.com",
  "password": "secret123",
  "phone": "+201001234567",
  "role": "user",
  "avatarUrl": "https://res.cloudinary.com/demo/.../avatar.webp"
}
```

Register Rider
```json
{
  "name": "Omar",
  "email": "omar@example.com",
  "password": "secret123",
  "phone": "+201009998888",
  "role": "rider",
  "vehicleType": "motorcycle",
  "avatarUrl": "https://res.cloudinary.com/demo/.../avatar.webp",
  "idCardUrl": "https://res.cloudinary.com/demo/.../id.webp",
  "licenseUrl": "https://res.cloudinary.com/demo/.../license.webp",
  "vehicleUrlFront": "https://res.cloudinary.com/demo/.../bike1.webp",
  "vehicleUrlSide": "https://res.cloudinary.com/demo/.../bike2.webp",
  "licensePlateUrl": "https://res.cloudinary.com/demo/.../plate.webp"
}
```

Register Merchant
```json
{
  "name": "Khaled",
  "email": "khaled@shop.com",
  "password": "secret123",
  "phone": "+201114445555",
  "role": "merchant",
  "businessType": "restaurant",
  "restaurantName": "Tasty Bites",
  "ownerName": "Khaled",
  "ownerPhone": "+201114445555",
  "description": "Grilled and sandwiches",
  "deliveryRadius": 5,
  "address": "Nasr City, Cairo",
  "location": { "lat": 30.0596, "lng": 31.2234 },
  "avatarUrl": "https://res.cloudinary.com/demo/.../logo.webp"
}
```

### Responses
- 201 Created
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "66e5...",
      "name": "Ahmed Ali",
      "email": "ahmed@example.com",
      "avatarUrl": "https://...",
      "role": "user",
      "createdAt": "2025-09-14T12:00:00.000Z"
    },
    "token": "<jwt>"
  }
}
```

- 400 Validation error
```json
{
  "success": false,
  "error": { "code": "VALIDATION_ERROR", "message": "Validation failed. Please check the provided fields." },
  "details": [ { "path": "email", "msg": "Invalid email" } ]
}
```

- 409 Email in use
```json
{ "success": false, "error": { "code": "EMAIL_TAKEN", "message": "Email already in use" } }
```

---

## POST /api/auth/login
Content-Type: `application/json`

Body
- `email` string, required
- `password` string, required

Responses
- 200 OK
```json
{
  "success": true,
  "data": {
    "user": { "id": "66e5...", "name": "Ahmed", "email": "ahmed@example.com", "avatarUrl": null, "role": "user", "createdAt": "..." },
    "token": "<jwt>"
  }
}
```

- 404 User not found
```json
{ "success": false, "error": { "code": "USER_NOT_FOUND", "message": "User not found (المستخدم غير موجود)." } }
```

- 401 Invalid password
```json
{ "success": false, "error": { "code": "INVALID_PASSWORD", "message": "Incorrect password (كلمة المرور غير صحيحة)." } }
```

- 403 Not approved (rider/merchant)
```json
{ "success": false, "error": { "code": "NOT_APPROVED", "message": "Rider account pending approval by admin (حساب السائق في انتظار موافقة الإدارة)." } }
```
or
```json
{ "success": false, "error": { "code": "NOT_APPROVED", "message": "Merchant account pending approval by admin (حساب التاجر في انتظار موافقة الإدارة)." } }
```

---

## GET /api/auth/me
Headers
- `Authorization: Bearer <token>`

Response
- 200 OK
```json
{ "success": true, "data": { "user": { "id": "...", "name": "...", "email": "...", "avatarUrl": "...", "role": "user" } } }
```
- 401 Unauthorized
```json
{ "success": false, "error": { "code": "UNAUTHORIZED", "message": "Unauthorized (غير مصرح)." } }
```
