const RiderProfile = require('../models/RiderProfile');
const MerchantProfile = require('../models/MerchantProfile');
const User = require('../models/User');
const { sendMail } = require('../utils/mailer');

// List pending riders
async function listPendingRiders(req, res, next) {
  try {
    const riders = await RiderProfile.find({ active: false }).populate('userId', 'name email phone');
    return res.json({ success: true, data: { riders } });
  } catch (err) {
    return next(err);
  }
}

// List pending merchants
async function listPendingMerchants(req, res, next) {
  try {
    const merchants = await MerchantProfile.find({ active: false }).populate('userId', 'name email phone');
    return res.json({ success: true, data: { merchants } });
  } catch (err) {
    return next(err);
  }
}

// Approve rider by profile id
async function approveRider(req, res, next) {
  try {
    const { id } = req.params; // rider profile id
    const rider = await RiderProfile.findById(id);
    if (!rider) {
      return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Rider profile not found' } });
    }
    if (rider.active) {
      return res.json({ success: true, data: { rider } });
    }
    rider.active = true;
    await rider.save();

    const user = await User.findById(rider.userId);
    // Send activation email
    if (user?.email) {
      await safeSendMail({
        to: user.email,
        subject: 'تم تفعيل حساب المندوب - DelivaEat',
        html: `<p>مرحباً ${user.name || ''}،</p><p>تمت الموافقة على حسابك كمندوب. يمكنك الآن تسجيل الدخول والمباشرة.</p>`
      });
    }

    return res.json({ success: true, data: { rider } });
  } catch (err) {
    return next(err);
  }
}

// Approve merchant by profile id
async function approveMerchant(req, res, next) {
  try {
    const { id } = req.params; // merchant profile id
    const merchant = await MerchantProfile.findById(id);
    if (!merchant) {
      return res.status(404).json({ success: false, error: { code: 'NOT_FOUND', message: 'Merchant profile not found' } });
    }
    if (merchant.active) {
      return res.json({ success: true, data: { merchant } });
    }
    merchant.active = true;
    await merchant.save();

    const user = await User.findById(merchant.userId);
    // Send activation email
    if (user?.email) {
      await safeSendMail({
        to: user.email,
        subject: 'تم تفعيل حساب التاجر - DelivaEat',
        html: `<p>مرحباً ${user.name || ''}،</p><p>تمت الموافقة على حسابك كتاجر. يمكنك الآن تسجيل الدخول والمباشرة.</p>`
      });
    }

    return res.json({ success: true, data: { merchant } });
  } catch (err) {
    return next(err);
  }
}

async function safeSendMail(opts) {
  try {
    await sendMail(opts);
  } catch (e) {
    // log and continue, do not fail request
    // eslint-disable-next-line no-console
    console.warn('Email send failed:', e?.message || e);
  }
}

module.exports = {
  listPendingRiders,
  listPendingMerchants,
  approveRider,
  approveMerchant,
};
