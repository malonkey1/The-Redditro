SMODS.Sprite:new("redd_atlas_t", Redditro.mod.path, "redd_tarots_atlas.png", 71, 95, "redd_atlas_t"):register()

SMODS.Consumable:take_ownership('c_hermit',
    {
        loc_vars = function(self, info_queue, card)
            if G.GAME and G.GAME.used_vouchers.v_bonus_pay then return { vars = { math.huge } }
            elseif G.GAME.used_vouchers.v_pay_rise then return { vars = { (card.ability.extra + 10) }}
            else return { vars = { card.ability.extra } } end
        end,
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    if G.GAME.used_vouchers.v_bonus_pay then ease_dollars(math.max(0, G.GAME.dollars), true)
                    elseif G.GAME.used_vouchers.v_pay_rise then ease_dollars(math.max(0, math.min(G.GAME.dollars, (card.ability.extra + 10))), true)
                    else ease_dollars(math.max(0, math.min(G.GAME.dollars, card.ability.extra)), true) end
                    return true
                end
            }))
            delay(0.6)
        end
    },
    true
)

SMODS.Consumable:take_ownership('c_temperance',
    {
        loc_vars = function(self, info_queue, card)
            local money = 0
            local max = card.ability.extra
            if G.jokers then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].ability.set == 'Joker' then
                        money = money + G.jokers.cards[i].sell_cost
                    end
                end
            end
            if G.GAME.used_vouchers.v_bonus_pay then
                card.ability.money = money
                max = math.huge
            elseif G.GAME.used_vouchers.v_pay_rise then
                card.ability.money = math.min(money, (card.ability.extra + 10))
                max = max + 10
            else card.ability.money = math.min(money, card.ability.extra) end

            return { vars = { max, card.ability.money } }
        end,
        use = function(self, card, area, copier)
            local money = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    money = money + G.jokers.cards[i].sell_cost
                end
            end
            if G.GAME.used_vouchers.v_bonus_pay then card.ability.money = money
            elseif G.GAME.used_vouchers.v_pay_rise then card.ability.money = math.min(money, (card.ability.extra + 10))
            else card.ability.money = math.min(money, card.ability.extra) end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    card:juice_up(0.3, 0.5)
                    ease_dollars(self.ability.money, true)
                    return true
                end
            }))
            delay(0.6)
        end,
    },
    true
)