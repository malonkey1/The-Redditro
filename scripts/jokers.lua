
SMODS.Sprite:new("redd_atlas_j", Redditro.mod.path, "redd_jokers_atlas.png", 71, 95, "redd_atlas_j"):register()
SMODS.Sprite:new("redd_ace", Redditro.mod.path, "Ace_sexual.png", 71, 95, "redd_ace"):register()


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

SMODS.Joker {
    key = "noise",
    loc_txt = {
        name = "Static Noise",
        text = {
            "Gains {X:mult,C:white} x0.5{} Mult if you",
            " {C:chips}Play{} or {C:red}Skip{} a {C:attention}Blind{}.",
            "Changes every blind",
            "Now {X:mult,C:white} x#1#{} Mult",
            "{C:inactive}Currently: #3#{}",
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 1, y = 0 },
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    config = { extra = { mult = 1, round_counted = false, type = "skip" } },
   
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.round_counted, card.ability.extra.type } }
    end,

    calculate = function(self, card, context)

        if (context.skip_blind or context.setting_blind) and not context.blueprint then 
            message = ""
            if context.skip_blind and card.ability.extra.type == "skip" then
                card.ability.extra.mult = card.ability.extra.mult + 0.5
                message = " - " .. card.ability.extra.mult
                card:juice_up(0.5, 0.5)
            end
            if context.setting_blind and card.ability.extra.type == "play" then
                card.ability.extra.mult = card.ability.extra.mult + 0.5
                message = " - " .. card.ability.extra.mult
                card:juice_up(0.5, 0.5)
            end
            local available = { "play", "skip" }
            local chosen = pseudorandom_element(available, pseudoseed("asc_noise"))
            card.ability.extra.type = chosen
            text = "Now " .. chosen .. message
            return { message = text, other_card = card }
        end

        if context.joker_main and card.ability.extra.mult > 1 then
            local mult = card.ability.extra.mult or 1
            return {
                message = localize { type = "variable", key = "a_xmult", vars = { mult } },
                Xmult_mod = mult
            }
        end
    end,

    copying = function(self, card, from)
        card.ability.extra.mult = from.ability.extra.mult or 1
    end,

    set_badges = function(self, card, badges)
        badges[#badges + 1] = create_badge('Idea: Tisisrealnow', G.C.BLACK, G.C.WHITE, 0.9)
    end
}

SMODS.Joker {
    key = "rot",
    loc_txt = {
        name = "Rule of Three",
        text = {
            "Rettrigger {C:attention}third{} played",
            "card. If it's a {C:attention}3{},",
            "rettriger it {C:attention}three{}",
            "times instead."
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[3] then
            if context.other_card:get_id() == 3 then
                repeat_count = 3
            else
                repeat_count = 1
            end
            card.juice_up(0.5 , 0.5)
            return {
                repetitions = repeat_count
            }
        end
    end,
}

SMODS.Joker {
    key = "square",
    loc_txt = {
        name = "Four Square",
        text = {
            "This joker gains {X:mult,C:white} x0.5{}",
            "Mult for every fourth",
            "{C:attention}4{} scored {C:inactive}(#1#/4){}",
            "{C:inactive}(Currently: {X:mult,C:white}x#2#{}){}",    
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    config = { extra = { mult = 1, count = 0, gain = 0.5 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.count, card.ability.extra.mult, card.ability.extra.gain } }
    end,
    
    calculate = function(self, card, context)
        if  context.individual and context.cardarea == G.play and context.other_card:get_id() == 4 and not context.blueprint then
            card.ability.extra.count = card.ability.extra.count + 1
            if card.ability.extra.count >= 4 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                card.ability.extra.count = 0
            end
            card.juice_up(0.5 , 0.5)
            return {
                message = card.ability.extra.mult
            }

        end
        if context.joker_main and card.ability.extra.mult > 1 then
            card.juice_up(0.5 , 0.5)
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.mult } },
                Xmult_mod = card.ability.extra.mult
            }
        end
    end,
}

SMODS.Joker {
    key = "high_five",
    loc_txt = {
        name = "High Five",
        text = {
            "{X:mult,C:white} x5{} Mult if scored hand",
            "is a {C:attention}5 high card{}.",   
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    config = { extra = { xmult = 5} },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult} }
    end,    
    
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == "High Card" then
            trigger = false
            for _, pcard in ipairs(context.scoring_hand) do
                if not SMODS.has_enhancement(pcard, 'm_stone') then
                    if pcard:get_id() == 5 then
                        card.juice_up(0.5 , 0.5)
                        return {
                            xmult = card.ability.extra.xmult
                        }
                    end
                end
            end
        end
    end,
}

SMODS.Joker {
    key = "six_figures",
    loc_txt = {
        name = "Six Figures",
        text = {
            "Played {C:attention}6{}s earn {C:gold}$2{} when",
            "scored.",   
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,

    calculate = function(self, card, context) 
        if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == 6 then
                card.juice_up(0.5 , 0.5)
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
                    
                    dollars = 2,
					card = context.other_card
				}
			end
		end
    end
}

SMODS.Joker {
    key = "lucky_seven",
    loc_txt = {
        name = "Lucky Seven",
        text = {
            "Played {C:attention}7{}s become {C:attention}Lucky{}",
            "when scored.",   
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 7 then
                    faces = faces + 1
                    scored_card:set_ability('m_lucky', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                card.juice_up(0.5 , 0.5)
                return {
                    message = localize('k_lucky'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}

SMODS.Joker{
    key = "acesexual",
    loc_txt = {
        name = "Ace-sexual",
        text = {
            "This joker gains {X:mult,C:white}X0.05{}",
            "Mult when each played",
            "{C:attention}Ace{} is scored.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{} Mult){}"
        }
    },
    atlas = "redd_ace",
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 1,
            gain = 0.05
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.gain
            }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:get_id() == 14 then 
                card.juice_up(0.5 , 0.5)
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                return {
                    message = card.ability.extra.xmult
                }
            end
        end
    
        if context.joker_main and card.ability.extra.xmult > 1 then 
            card.juice_up(0.5 , 0.5)
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                Xmult_mod = card.ability.extra.xmult
            }
        end
    end,
}


-- ####################################### VERSION 1.0.2 ###############################################

SMODS.Joker{
    key = "engagment_ring",
    loc_txt = {
        name = "Engagment Ring",
        text = {
            "This {C:attention}Joker{} gains {C:blue}+#2#{}",
            "Chips when each {C:orange}Diamond{}",
            "Is scored."
            "{C:inactive}(Currently {C:blue}+#1#{} Chips){}"
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 6,
    blueprint_compat = true,
    config = {
        extra = {
            chips = 0,
            gain = 1,
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
                card.juice_up(0.5 , 0.5)
                return {
                    message = "+ " .. card.ability.extra.gain
                }
            end
        end
        
        if context.joker_main and card.ability.extra.chips > 1 then 
            card.juice_up(0.5 , 0.5)

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
    }
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    config = {
        extra = {
            mult = 10
        }
    },

    loc_vars = function(self, info_queue, card) {
        return {
            vars = {
                card.ability.extra.mult
            }
        }
    },

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
    key = "greatfull_joker",
    loc_txt = {
        name = "Greatfull Joker",
        text = {
            "Gains {X:mult,C:white}X2{} Mult",
            "at end of shop if ",
            "no {C:green}Rerolls{} were used",
            "{C:inactive}(Curently {X:mult,C:white}X#1#{} mult)"
        }
    }
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