// Normalizes Flutter UI capitalized values to backend enums
// Example mappings:
// - role: User/Rider/Merchant -> user/rider/merchant
// - vehicleType: Motorcycle/Bicycle/Scooter -> motorcycle/bicycle/scooter
// - businessType: Restaurant/Grocery/Pharmacy/Bakery -> restaurant/grocery/pharmacy/bakery

function normalizeFlutterEnums(req, res, next) {
  if (req.body && typeof req.body === 'object') {
    const b = req.body;

    // Normalize role
    if (typeof b.role === 'string') {
      const roleMap = {
        user: 'user', User: 'user',
        rider: 'rider', Rider: 'rider',
        merchant: 'merchant', Merchant: 'merchant',
        admin: 'admin', Admin: 'admin',
      };
      if (roleMap[b.role] !== undefined) b.role = roleMap[b.role];
    }

    // Normalize vehicleType
    if (typeof b.vehicleType === 'string') {
      const vMap = {
        motorcycle: 'motorcycle', Motorcycle: 'motorcycle',
        bicycle: 'bicycle', Bicycle: 'bicycle',
        scooter: 'scooter', Scooter: 'scooter',
      };
      if (vMap[b.vehicleType] !== undefined) b.vehicleType = vMap[b.vehicleType];
    }

    // Normalize businessType
    if (typeof b.businessType === 'string') {
      const btMap = {
        restaurant: 'restaurant', Restaurant: 'restaurant',
        grocery: 'grocery', Grocery: 'grocery',
        pharmacy: 'pharmacy', Pharmacy: 'pharmacy',
        bakery: 'bakery', Bakery: 'bakery',
      };
      if (btMap[b.businessType] !== undefined) b.businessType = btMap[b.businessType];
    }
  }

  return next();
}

module.exports = { normalizeFlutterEnums };
