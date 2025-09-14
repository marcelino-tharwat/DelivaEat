# Orders API (Draft Contracts)

Base URL: `http://localhost:5000`

Statuses
- `pending` -> `accepted` -> `picked_up` -> `delivered`
- `cancelled`

Entities
- `order`: { id, userId, merchantId, items[], total, address, location{lat,lng}, status, assignedRiderId?, createdAt }
- `item`: { productId, name, price, qty, notes? }

---

## POST /api/orders
Create an order (user role).

Body
```json
{
  "merchantId": "66e5...",
  "items": [
    { "productId": "p1", "name": "Burger", "price": 120, "qty": 2 }
  ],
  "address": "Nasr City, Cairo",
  "location": { "lat": 30.0596, "lng": 31.2234 },
  "notes": "No onions"
}
```

Response
```json
{ "success": true, "data": { "order": { "id": "...", "status": "pending" } } }
```

---

## GET /api/orders
List orders for current user (user/merchant/rider see filtered views).
- Query: `status`, `page`, `limit`

Response
```json
{ "success": true, "data": { "orders": [ ... ], "meta": { "page": 1, "limit": 20, "total": 120 } } }
```

---

## PATCH /api/orders/:id/status
- Merchant can set `accepted` / `cancelled`
- Rider can set `picked_up` / `delivered`

Body
```json
{ "status": "accepted" }
```

Response
```json
{ "success": true, "data": { "order": { "id": "...", "status": "accepted" } } }
```
