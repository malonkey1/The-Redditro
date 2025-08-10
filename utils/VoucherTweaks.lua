local lookup = {}

lookup.vouchers = {
    ["v_overstock_norm"] = "v_overstock_plus",
    ["v_clearance_sale"] = "v_liquidation",
    ["v_hone"] = "v_glow_up",
    ["v_reroll_surplus"] = "v_reroll_glutm",
    ["v_crystal_ball"] = "v_omen_globe",
    ["v_telescope"] = "v_observatory",
    ["v_grabber"] = "v_nacho_tong",
    ["v_wasteful"] = "v_recyclomancy",
    ["v_tarot_merchant"] = "v_tarot_tycoon",
    ["v_planet_merchant"] = "v_planet_tycoon",
    ["v_seed_money"] = "v_money_tree",
    ["v_blank"] = "v_antimatter",
    ["v_magic_trick"] = "v_illusion",
    ["v_hieroglyph"] = "v_petroglyph",
    ["v_directors_cut"] = "v_retcon",
    ["v_paint_brush"] = "v_palette",
}


-- Function: Get all Tier 2 voucher keys you don't already own
function lookup.getAvailableTier2Vouchers()
    local tier2Keys = {}

    for key in pairs(G.GAME.used_vouchers) do
        local tier2Key = lookup.vouchers[key]  -- Check the mapping

        if tier2Key then
            -- Check if you already own the Tier 2 voucher
            if not G.GAME.used_vouchers[tier2Key] then
                table.insert(tier2Keys, tier2Key)
            end
        end
    end

    if #tier2Keys == 0 then
        return {
            "v_blank",
            "v_blank"
        }
    end


    return tier2Keys -- tier2Keys
end

function lookup.grantTier2Voucher()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.01,
        func = function()
            local voucher_keys = Redditro.VoucherTweaks.getAvailableTier2Vouchers()
            local voucher_selected = pseudorandom_element(voucher_keys, pseudoseed("redd_broker"))
            if voucher_selected and voucher_selected ~= "v_blank" then
                
                
                lookup.animation(voucher_selected)
            

                return true
            end
            return true
        end
    }))
end


function lookup.grantVoucher(key)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.01,
        func = function()
            if not key  then
                return true
            end
            
            
            lookup.animation(key)
            
            return true
        end
    }))
end


function lookup.animation(keyRedeem, redeem = true) 
    local area
    if G.STATE == G.STATES.HAND_PLAYED then
        if not G.redeemed_vouchers_during_hand then
            G.redeemed_vouchers_during_hand = CardArea(
                G.play.T.x,
                G.play.T.y,
                G.play.T.w,
                G.play.T.h,
                { type = "play", card_limit = 5 }
            )
        end
        area = G.redeemed_vouchers_during_hand
    else
        area = G.play
    end

    local card = create_card("Voucher", area, nil, nil, nil, nil, keyRedeem)
    
    card:start_materialize()
    area:emplace(card)
    card.cost = 0
    card.shop_voucher = false
    local current_round_voucher = G.GAME.current_round.voucher
    if redeem then
        card:redeem()
    end
    G.GAME.current_round.voucher = current_round_voucher
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0,
        func = function()
            card:start_dissolve()
            return true
        end,
    }))
end

return lookup
