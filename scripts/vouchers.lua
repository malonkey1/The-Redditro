SMODS.Sprite:new("redd_atlas_v", Redditro.mod.path, "redd_vouchers_atlas.png", 71, 95, "redd_atlas_v"):register()

SMODS.Atlas {
    key = 'pay_rise',
    path = 'Payrise.png',
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = 'bonus_pay',
    path = 'Bonus_Pay.png',
    px = 71,
    py = 95,
}

SMODS.Voucher {
    key = 'pay_rise',
    atlas = 'pay_rise',
    cost = 10,
}

SMODS.Voucher {
    key = 'bonus_pay',
    atlas = 'bonus_pay',
    cost = 10,
}

