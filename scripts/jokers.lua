
SMODS.Sprite:new("redd_atlas_j", Redditro.mod.path, "redd_jokers_atlas.png", 71, 95, "redd_atlas_j"):register()
SMODS.Sprite:new("redd_ace", Redditro.mod.path, "Ace_sexual.png", 71, 95, "redd_ace"):register()

SMODS.Joker {
    key = "redd_noise",
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
    config = { extra = { mult = 1, round_counted = false, type = "skip" } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.round_counted, card.ability.extra.type } }
    end,
    blueprint_compat = true,
    rarity = 3,
    atlas = "redd_atlas_j",
    pos = { x = 1, y = 0 },
    cost = 7,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            card.ability.extra.round_counted = true
            local available = { "play", "skip" }
            local chosen = pseudorandom_element(available, pseudoseed("asc_noise"))
            card.ability.extra.type = chosen
            message = "Now " .. chosen
            return { message = message, other_card = card }
        end

        if context.skip_blind and card.ability.extra.type == "skip" then
            card.ability.extra.mult = card.ability.extra.mult + 0.5
            card:juice_up(0.5, 0.5)

            local available = { "play", "skip" }
            local chosen = pseudorandom_element(available, pseudoseed("asc_noise"))
            card.ability.extra.type = chosen

            return { message = "X0.5", other_card = card }
        end

        if context.setting_blind and card.ability.extra.type == "play" then
            card.ability.extra.mult = card.ability.extra.mult + 0.5
            card:juice_up(0.5, 0.5)

            return { 
                message = "X0.5",
                other_card = card,
            }
        end

        if context.joker_main then
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
    key = "redd_rot",
    loc_txt = {
        name = "Rule of Three",
        text = {
            "Rettrigger {C:attention}third{} played",
            "card. If it's a {C:attention}3{},",
            "rettriger it {C:attention}three{}",
            "times instead."
        }
    },
    rarity = 2,
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    cost = 4,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[3] then
            if context.other_card:get_id() == 3 then
                repeat_count = 3
            else
                repeat_count = 1
            end
            return {
                repetitions = repeat_count
            }
        end
    end,
}

SMODS.Joker {
    key = "redd_square",
    loc_txt = {
        name = "Four Square",
        text = {
            "This joker gains {X:mult,C:white} x0.5{}",
            "Mult for every fourth",
            "{C:attention}4{} scored {C:inactive}(#1#/4){}",
            "{C:inactive}(Currently: {X:mult,C:white}x#2#{}){}",    
        }
    },
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
            return {
                message = "Upgraded"
            }

        end
        if context.joker_main then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.mult
            }
        end
    end,
    rarity = 2,
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    cost = 4,
}

SMODS.Joker {
    key = "redd_high_five",
    loc_txt = {
        name = "High Five",
        text = {
            "{X:mult,C:white} x5{} Mult if scored hand",
            "is a {C:attention}5 high card{}.",   
        }
    },
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
                        return {
                            xmult = card.ability.extra.xmult
                        }
                    end
                end
            end
        end
    end,
        

    
    rarity = 2,
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    cost = 4,
}

SMODS.Joker {
    key = "redd_six_figures",
    loc_txt = {
        name = "Six Figures",
        text = {
            "Played {C:attention}6{}s earn {C:gold}$2{} when",
            "scored.",   
        }
    },
    rarity = 2,
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    cost = 4,
    calculate = function(self, card, context) 
        if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card:get_id() == 6 then
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
    key = "redd_lucky_seven",
    loc_txt = {
        name = "Lucky Seven",
        text = {
            "Played {C:attention}7{}s become {C:attention}Lucky{}",
            "when scored.",   
        }
    },
    rarity = 2,
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    cost = 4,
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
                return {
                    message = localize('k_lucky'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}




SMODS.Joker{
    key = "redd_acesexual",
    loc_txt = {
        name = "Ace-sexual",
        text = {
            "This joker gains {X:mult,C:white}X0.05{}",
            "Mult when each played",
            "{C:attention}Ace{} is scored.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{} Mult){}"
        }
    },
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
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 14 then 
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            end
        end
    
        if context.joker_main then 
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.mult
            }
        end
    end,
    rarity = 3,
    atlas = "redd_ace",
    cost = 7,
}