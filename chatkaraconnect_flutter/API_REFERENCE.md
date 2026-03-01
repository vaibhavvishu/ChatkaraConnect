# ChatkaraConnect API Reference

## Base URL
```
http://localhost:8000/api
```

## Authentication
Currently, the API doesn't require authentication tokens. User is identified by their ID stored locally.

---

## API Endpoints

### User Endpoints

#### Register User
```
POST /api/users/register/
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "9876543210",
  "password": "password123",
  "role": "customer"  // or "vendor"
}

Response: 201
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "9876543210",
  "role": "customer",
  "created_at": "2024-02-17T10:30:00Z"
}
```

#### Login User
```
POST /api/users/login/
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response: 200
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "9876543210",
  "role": "customer",
  "created_at": "2024-02-17T10:30:00Z"
}
```

---

### Vendor Endpoints

#### Get All Vendors
```
GET /api/vendors/
GET /api/vendors/?search=restaurant
GET /api/vendors/?search=wedding&ordering=-avg_rating

Response: 200
{
  "count": 25,
  "next": "http://localhost:8000/api/vendors/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "user": {...},
      "business_name": "Taj Caterers",
      "location": "Mumbai",
      "service_area": "Mumbai & Suburbs",
      "category": "Indian",
      "verified": true,
      "description": "Premium Indian catering service",
      "image": "http://localhost:8000/media/vendor_images/taj.jpg",
      "avg_rating": 4.5,
      "total_ratings": 25,
      "menu_items": [...]
    }
  ]
}
```

#### Get Vendor Details
```
GET /api/vendors/{id}/

Response: 200
{
  "id": 1,
  "user": {
    "id": 2,
    "name": "Raj Patel",
    "email": "raj@example.com",
    "phone": "9876543210",
    "role": "vendor",
    "created_at": "2024-02-17T10:30:00Z"
  },
  "business_name": "Taj Caterers",
  "location": "Mumbai",
  "service_area": "Mumbai & Suburbs",
  "category": "Indian",
  "verified": true,
  "description": "Premium Indian catering service",
  "image": "http://localhost:8000/media/vendor_images/taj.jpg",
  "avg_rating": 4.5,
  "total_ratings": 25,
  "menu_items": [
    {
      "id": 1,
      "vendor": 1,
      "dish_name": "Butter Chicken",
      "price": "450.00",
      "category": "Main Course"
    }
  ]
}
```

#### Register Vendor
```
POST /api/vendors/register_vendor/
Content-Type: application/json

{
  "user": {
    "name": "Raj Patel",
    "email": "raj@example.com",
    "phone": "9876543210",
    "password": "password123"
  },
  "vendor": {
    "business_name": "Taj Caterers",
    "location": "Mumbai",
    "service_area": "Mumbai & Suburbs",
    "category": "Indian",
    "description": "Premium Indian catering service"
  }
}

Response: 201
{...} (Vendor object)
```

#### Get Vendor Menu
```
GET /api/vendors/{id}/menu/

Response: 200
[
  {
    "id": 1,
    "vendor": 1,
    "dish_name": "Butter Chicken",
    "price": "450.00",
    "category": "Main Course"
  }
]
```

#### Get Vendor Orders
```
GET /api/vendors/{id}/orders/

Response: 200
[
  {
    "id": 1,
    "customer": 1,
    "customer_name": "John Doe",
    "vendor": 1,
    "vendor_name": "Taj Caterers",
    "event_type": "Wedding",
    "event_date": "2024-03-15",
    "guests": 100,
    "total_price": "50000.00",
    "status": "pending",
    "created_at": "2024-02-17T10:30:00Z"
  }
]
```

---

### Order Endpoints

#### Get All Orders
```
GET /api/orders/
GET /api/orders/?customer=1
GET /api/orders/?vendor=1
GET /api/orders/?status=pending

Response: 200
{
  "count": 10,
  "results": [...]
}
```

#### Create Order
```
POST /api/orders/
Content-Type: application/json

{
  "customer": 1,
  "vendor": 1,
  "event_type": "Wedding",
  "event_date": "2024-03-15",
  "guests": 100,
  "total_price": "50000.00",
  "status": "pending"
}

Response: 201
{
  "id": 1,
  "customer": 1,
  "customer_name": "John Doe",
  "vendor": 1,
  "vendor_name": "Taj Caterers",
  "event_type": "Wedding",
  "event_date": "2024-03-15",
  "guests": 100,
  "total_price": "50000.00",
  "status": "pending",
  "created_at": "2024-02-17T10:30:00Z"
}
```

#### Get Order Details
```
GET /api/orders/{id}/

Response: 200
{
  "id": 1,
  "customer": {...},
  "vendor": {...},
  "event_type": "Wedding",
  "event_date": "2024-03-15",
  "guests": 100,
  "total_price": "50000.00",
  "status": "pending",
  "created_at": "2024-02-17T10:30:00Z",
  "feedback": null,  // or feedback object
  "payment": null    // or payment object
}
```

#### Update Order Status
```
POST /api/orders/{id}/update_status/
Content-Type: application/json

{
  "status": "accepted"  // pending, accepted, rejected, completed
}

Response: 200
{...} (Updated Order object)
```

---

### Feedback Endpoints

#### Get Feedback
```
GET /api/feedback/
GET /api/feedback/?vendor=1

Response: 200
{
  "count": 5,
  "results": [
    {
      "id": 1,
      "order": 1,
      "rating": 5,
      "comment": "Excellent service and food quality!"
    }
  ]
}
```

#### Create Feedback
```
POST /api/feedback/
Content-Type: application/json

{
  "order": 1,
  "rating": 5,
  "comment": "Excellent service and food quality!"
}

Response: 201
{
  "id": 1,
  "order": 1,
  "rating": 5,
  "comment": "Excellent service and food quality!"
}
```

---

### Menu Endpoints

#### Get Menu Items
```
GET /api/menu/
GET /api/menu/?vendor=1
GET /api/menu/?search=butter

Response: 200
{
  "count": 20,
  "results": [
    {
      "id": 1,
      "vendor": 1,
      "dish_name": "Butter Chicken",
      "price": "450.00",
      "category": "Main Course"
    }
  ]
}
```

#### Create Menu Item
```
POST /api/menu/
Content-Type: application/json

{
  "vendor": 1,
  "dish_name": "Butter Chicken",
  "price": "450.00",
  "category": "Main Course"
}

Response: 201
{...} (Menu object)
```

---

### Payment Endpoints

#### Create Payment
```
POST /api/payments/
Content-Type: application/json

{
  "order": 1,
  "amount": "50000.00",
  "payment_method": "online",  // online, cash, check
  "payment_status": "pending"
}

Response: 201
{
  "id": 1,
  "order": 1,
  "amount": "50000.00",
  "payment_method": "online",
  "payment_status": "pending"
}
```

#### Confirm Payment
```
POST /api/payments/{id}/confirm_payment/

Response: 200
{
  "id": 1,
  "order": 1,
  "amount": "50000.00",
  "payment_method": "online",
  "payment_status": "paid"
}
```

---

## Response Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 201 | Created - Resource created |
| 400 | Bad Request - Invalid data |
| 401 | Unauthorized - Authentication required |
| 404 | Not Found - Resource doesn't exist |
| 500 | Server Error - Something went wrong |

---

## Error Response Format

```json
{
  "error": "Error message here"
}
```

---

## Search/Filter Parameters

### Vendors
- `search`: Search by business_name, category, location
- `ordering`: Order by avg_rating, business_name (use `-` for descending)

### Orders
- `customer`: Filter by customer ID
- `vendor`: Filter by vendor ID
- `status`: Filter by status (pending, accepted, rejected, completed)
- `ordering`: Order by created_at, status

### Feedback
- `vendor`: Filter feedback by vendor ID

### Menu
- `vendor`: Filter menu items by vendor ID
- `search`: Search by dish_name, category

---

## Pagination

By default, 10 results per page. Response includes:
```json
{
  "count": 100,
  "next": "http://localhost:8000/api/vendors/?page=2",
  "previous": null,
  "results": [...]
}
```

Navigate using `?page=2`, `?page=3`, etc.

---

## Testing with cURL

```bash
# Get all vendors
curl http://localhost:8000/api/vendors/

# Login
curl -X POST http://localhost:8000/api/users/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"pass123"}'

# Create order
curl -X POST http://localhost:8000/api/orders/ \
  -H "Content-Type: application/json" \
  -d '{
    "customer": 1,
    "vendor": 1,
    "event_type": "Wedding",
    "event_date": "2024-03-15",
    "guests": 100,
    "total_price": "50000.00"
  }'
```

---

## Rate Limiting

Currently not implemented. Each endpoint is rate-limited by Django's default settings.

---

## CORS

For frontend requests from localhost, CORS is handled by the development server.

For production, configure CORS in Django settings.

---

## API Versioning

Current version: v1 (not versioned yet - all endpoints are v1 by default)
