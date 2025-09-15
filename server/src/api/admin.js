const express = require('express');
const router = express.Router();

const { auth } = require('../middleware/auth');
const { requireRole } = require('../middleware/roles');
const { listPendingRiders, listPendingMerchants, approveRider, approveMerchant } = require('../controllers/adminController');

// All admin routes require admin role
router.use(auth, requireRole('admin'));

// Pending lists
router.get('/riders/pending', listPendingRiders);
router.get('/merchants/pending', listPendingMerchants);

// Approvals
router.post('/riders/:id/approve', approveRider);
router.post('/merchants/:id/approve', approveMerchant);

module.exports = router;
