--[[
JOKER TEMPLATE:

SMODS.Joker {
    key = "jokername",
    loc_txt = {
        name = "Joker Name",
        text = {
            "line 1",
            "line 2",
            ...
        }
    },
    atlas = "jokername / redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = n, y = m}, -- (just use number lol)
    rarity = 1,
    cost = 1,
    blueprint_compat = true/false,
    config = {
        extra = {
            mult = 1,
            gain = 0.,
            ...
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.gain,
                ...
            }
        }
    end,

    calculate = function(self, card, )
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,

}

]]--


-- ####################################### VERSION 1.0.4 ###############################################

SMODS.Atlas {
    key = 'Engagement Ring',
    path = 'Engagement_Ring.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = "engagment_ring",
    loc_txt = {
        name = "Engagement Ring",
        text = {
            "This {C:attention}Joker{} gains {C:blue}+#2#{}",
            "Chips when each {C:orange}Diamond{}",
            "Is scored.",
            "{C:inactive}(Currently {C:blue}+#1#{} Chips){}"
        }
    },
    atlas = "Engagement Ring",
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 6,
    blueprint_compat = true,
    config = {
        extra = {
            chips = 0,
            gain = 6,
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.gain,
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Diamonds") then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
                card:juice_up(0.5 , 0.5)
                return {
                    message = "+ " .. card.ability.extra.gain
                }
            end
        end
        
        if context.joker_main and card.ability.extra.chips > 1 then 
            card:juice_up(0.5 , 0.5)

            return {
                chips = card.ability.extra.chips 
            }
        end
    end,

    
}

SMODS.Joker {
    key = "in_the_knavy",
    loc_txt = {
        name = "In The Knavy",
        text = {
            "{C:attention}Jacks{} give {X:mult,C:white}+#1#{} Mult",
            "when scored."
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    blueprint_compat = true,
    rarity = 2,
    cost = 4,
    config = { extra = { mult = 10 } },
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then 
            if context.other_card:get_id() == 11 then
                card.juice_up(0.5 , 0.5)
                return {
                    mult = card.ability.extra.mult  
                }
            end
        end
    end,
}

SMODS.Joker {
    key = "grateful_joker",
    loc_txt = {
        name = "Grateful Joker",
        text = {
            "Gains {X:mult,C:white}X2{} Mult",
            "at end of shop if ",
            "no {C:green}Rerolls{} were used",
            "{C:inactive}(Curently {X:mult,C:white}X#1#{} mult)"
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0},
    rarity = 3,
    cost = 6,
    blueprint_compat = true,
    config = {
        extra = {
            mult = 1,
            gain = 2,
            add = true,
        }
    },

    loc_vars = function(self, info_queue, card) 
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            card.ability.extra.add = true
        end

        if context.reroll_shop and not context.blueprint then 
            card.ability.extra.add = false
            return {
                message = "Busted",
            }
        end

        if context.ending_shop and card.ability.extra.add == true then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
            card.juice_up(0.5, 0.5)
            return {
                message = card.ability.extra.mult
            }
        end

        if context.joker_main and card.ability.extra.mult > 1 then 
            return {
                mult = card.ability.extra.mult
            }
        end
    end,    
}

SMODS.PokerHandPart:take_ownership('_straight', {
	func = function(hand) return get_straight(hand, next(SMODS.find_card('j_four_fingers')) and 4 or 5, not not next(SMODS.find_card('j_shortcut')), next(SMODS.find_card('j_toroid'))) end
})

SMODS.Atlas {
    key = "Toroid",
    path = "toroid.png",
    px = 72,
    py = 55,
}

SMODS.Joker {
    key = "toroid",
    loc_txt = {
        name = "Toroid",
        text = {
            "{C:attention}Straights{} can wrap around",
            "(ex. {C:attention}Q K A 2 3{})",
        }
    },
    atlas = "Toroid", -- (depends if we use sprite sheets or not)
    display_size = {
        w = 72,
        h = 55
    },
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
}