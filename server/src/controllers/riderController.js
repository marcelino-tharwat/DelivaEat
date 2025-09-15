const User = require('../models/User');
const RiderProfile = require('../models/RiderProfile');
const { sendMail } = require('../utils/mailer');

async function createRiderDraft(req, res, next) {
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

    // Create user with role rider
    const user = await User.create({
      name: payload.name,
      email: payload.email,
      password: payload.password,
      phone: payload.phone ?? null,
      role: 'rider',
      avatarUrl: payload.avatarUrl ?? null,
    });

    // Create rider profile
    const rider = await RiderProfile.create({
      userId: user._id,
      vehicleType: payload.vehicleType,
      avatarUrl: payload.avatarUrl ?? null,
      idCardUrl: payload.idCardUrl ?? null,
      licenseUrl: payload.licenseUrl ?? null,
      vehicleUrlFront: payload.vehicleUrlFront ?? null,
      vehicleUrlSide: payload.vehicleUrlSide ?? null,
      licensePlateUrl: payload.licensePlateUrl ?? null,
    });

    // Send pending approval emails (best-effort)
    (async () => {
      try {
        if (user?.email) {
          await sendMail({
            to: user.email,
            subject: 'طلب التسجيل كمندوب قيد المراجعة - DelivaEat',
            html: `<p>مرحباً ${user.name || ''}،</p><p>تم استلام طلبك كمندوب وهو قيد مراجعة الإدارة. سنقوم بإشعارك عبر البريد عند التفعيل.</p>`,
          });
        }
        const adminEmail = process.env.ADMIN_EMAIL;
        if (adminEmail) {
          await sendMail({
            to: adminEmail,
            subject: 'طلب جديد لمندوب - موافقة مطلوبة',
            html: `<p>طلب جديد لمندوب:</p>
                   <ul>
                     <li>الاسم: ${user.name || ''}</li>
                     <li>البريد: ${user.email}</li>
                     <li>الهاتف: ${user.phone || ''}</li>
                     <li>نوع المركبة: ${rider.vehicleType}</li>
                     <li>رابط البروفايل (ID): ${rider._id}</li>
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
        rider,
      },
    });
  } catch (err) {
    return next(err);
  }
}

async function getMyRiderProfile(req, res, next) {
  try {
    // If needed later: fetch from DB by req.user.id
    return res.json({ success: true, data: { rider: { id: 'stub', name: req.user?.name ?? 'Rider', role: 'rider' } } });
  } catch (err) {
    return next(err);
  }
}

module.exports = { createRiderDraft, getMyRiderProfile };
