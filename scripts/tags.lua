SMODS.Tag:take_ownership('tag_economy',
    {
        loc_vars = function(self, info_queue, tag)
            if G.GAME and G.GAME.used_vouchers.v_bonus_pay then return { vars = { math.huge } }
            elseif G.GAME.used_vouchers.v_pay_rise then return { vars = { (tag.config.max + 10) } }
            else return { vars = { tag.config.max } } end
        end,
        apply = function(self, tag, context)
            if context.type == 'immediate' then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                tag:yep('+', G.C.MONEY, function()
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        if G.GAME and G.GAME.used_vouchers.v_bonus_pay then ease_dollars(max(0, G.GAME.dollars),true)
                        elseif G.GAME.used_vouchers.v_pay_rise then ease_dollars(math.min((tag.config.max + 10), math.max(0, G.GAME.dollars)), true)
                        else ease_dollars(math.min(tag.config.max, math.max(0, G.GAME.dollars)), true) end
                        return true
                    end
                }))
                tag.triggered = true
                return true
            end
        end
    },
    true
)