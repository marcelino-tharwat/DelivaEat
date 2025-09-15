const User = require('../models/User');
const MerchantProfile = require('../models/MerchantProfile');
const { sendMail } = require('../utils/mailer');

async function createMerchantDraft(req, res, next) {
  try {
    const payload = req.body || {};

    // Check existing user by email
    const existing = await User.findOne({ email: payload.email });
    if (existing) {
      return res.status(409).json({
        success: false,
        error: { code: 'EMAIL_TAKEN', message: 'Email already in use' },
      });
    }

    // Create user with role merchant
    const user = await User.create({
      name: payload.name,
      email: payload.email,
      password: payload.password,
      phone: payload.phone ?? null,
      role: 'merchant',
      avatarUrl: payload.avatarUrl ?? null,
    });

    // Create merchant profile
    const merchant = await MerchantProfile.create({
      userId: user._id,
      businessType: payload.businessType,
      restaurantName: payload.restaurantName,
      ownerName: payload.ownerName,
      ownerPhone: payload.ownerPhone,
      description: payload.description ?? null,
      deliveryRadius: payload.deliveryRadius,
      address: payload.address ?? null,
      location: payload.location ?? null,
      avatarUrl: payload.avatarUrl ?? null,
    });

    // Send pending approval emails (best-effort)
    (async () => {
      try {
        if (user?.email) {
          await sendMail({
            to: user.email,
            subject: 'طلب التسجيل كتاجر قيد المراجعة - DelivaEat',
            html: `<p>مرحباً ${user.name || ''}،</p><p>تم استلام طلبك كتاجر وهو قيد مراجعة الإدارة. سنقوم بإشعارك عبر البريد عند التفعيل.</p>`,
          });
        }
        const adminEmail = process.env.ADMIN_EMAIL;
        if (adminEmail) {
          await sendMail({
            to: adminEmail,
            subject: 'طلب جديد لتاجر - موافقة مطلوبة',
            html: `<p>طلب جديد لتاجر:</p>
                   <ul>
                     <li>الاسم: ${user.name || ''}</li>
                     <li>البريد: ${user.email}</li>
                     <li>الهاتف: ${user.phone || ''}</li>
                     <li>اسم المطعم/النشاط: ${merchant.restaurantName}</li>
                     <li>النوع: ${merchant.businessType}</li>
                     <li>رابط البروفايل (ID): ${merchant._id}</li>
                   </ul>`
          });
        }
      } catch (e) {
        // ignore email failures
      }
    })();

    return res.status(201).json({
      success: true,
      data: {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone ?? null,
          avatarUrl: user.avatarUrl ?? null,
          role: user.role,
          createdAt: user.createdAt,
        },
        merchant,
      },
    });
  } catch (err) {
    return next(err);
  }
}

async function getMyMerchantProfile(req, res, next) {
  try {
    // If needed later: fetch from DB by req.user.id
    return res.json({ success: true, data: { merchant: { id: 'stub', name: req.user?.name ?? 'Merchant', role: 'merchant' } } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { createMerchantDraft, getMyMerchantProfile };
