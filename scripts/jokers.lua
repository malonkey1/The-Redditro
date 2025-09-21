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

    calculate = function(self, card, context)
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
                    focus = card,
                    message = localize("k_upgrade_ex"),
                    colour = G.C.CHIPS,
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
                card:juice_up(0.5 , 0.5)
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
            x_mult = 1,
            gain = 2,
            add = true,
        }
    },

    loc_vars = function(self, info_queue, card) 
        return {
            vars = {
                card.ability.extra.x_mult,
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
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
            card:juice_up(0.5, 0.5)
            return {
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
                    colour = G.C.RED,
                })
            }
        end

        if context.joker_main and card.ability.extra.x_mult > 1 then 
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
                Xmult_mod = card.ability.extra.x_mult,
            }
        end
    end,    
}

-- ##### MALONKEY1's JOKERS #####

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

SMODS.Joker {
    key = "black_cat",
    loc_txt = {
        name = "Black Cat",
        text = {
            "This {C:attention}Joker{} gains {C:blue}+#2#{}",
            "Chips every time a",
            "{C:attention}Lucky{} card {C:red}fails{}",
            "to trigger",
            "{C:inactive}(Currently {C:blue}+#1#{} Chips){}"
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    config = {
        extra = {
            chips = 0,
            gain = 4,
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
            if SMODS.has_enhancement(context.other_card,'m_lucky') and not context.other_card.lucky_trigger then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
                card:juice_up(0.5,0.5)
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
    key = "double_rainbow",
    loc_txt = {
        name = "Double Rainbow",
        text = {
            "Retrigger all",
            "played {C:attention}Wild{} cards"
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 5,
    config = { extra = { repetitions = 1 } },
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card,'m_wild') then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}

SMODS.Joker {
    key = "diffraction",
    loc_txt = {
        name = "Diffraction",
        text = {
            "Each scored {C:attention}Wild{} card",
            "has a {C:green}#1# in #2#{} chance to",
            "become {C:dark_edition}Polychrome{}"
        }
    },
    config = {
        extra = {
            odds = 4
        }
    },
    atlas = "redd_atlas_j",
    post = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'diffraction')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local scored_cards = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(scored_card,'m_wild') and not scored_card.debuff and SMODS.pseudorandom_probability(card, 'diffraction', 1, card.ability.extra.odds) then
                    scored_cards[#scored_cards + 1] = scored_card
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card:set_edition('e_polychrome',nil,true)
                            play_sound('tarot1')
                            return true
                        end
                    }))
                end
            end
            if #scored_cards > 0 then 
                return {
                    message = "Diffracted!",
                    colour = G.C.EDITION,
                }
            end
        end
    end
}

SMODS.Joker {
    key = "prism",
    loc_txt = {
        name = "Prism",
        text = {
            "{C:green}#1# in #2#{} chance to",
            "create a {C:spectral}Spectral{} card",
            "when a {C:attention}Wild{} card is",
            "scored"
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 3,
    cost = 9,
    blueprint_compat = true,
    config = {
        extra = {
            odds = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'prism')
        return { vars = { numerator, denominator } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card,'m_wild') and
        #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if SMODS.pseudorandom_probability(card, 'prism', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_spectral'),
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Spectral',
                                        key_append = 'prism' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end,

}

SMODS.Joker {
    key = "dusty_lamp",
    loc_txt = {
        name = "Dusty Lamp",
        text = {
            "Upon defeating a {C:attention}Blind{},",
            "create a {C:purple}Tarot{}",
            "{C:red}Debuffed{} after third",
            "{C:purple}Tarot{} create",
            "{C:inactive}(#1#/3 left){}"
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    config = {
        extra = {
            charges = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.charges
            }
        }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'box')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Spectral})
                card.ability.extra.charges = card.ability.extra.charges - 1
                if card.ability.extra.charges < 1 then
                    SMODS.debuff_card(card,true,'dusty_lamp')
                end
            end
        end
        if context.selling_self and card.ability.extra.charges > 0 then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'box')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Freedom!", colour = G.C.SECONDARY_SET.Spectral})
            end
        end
    end,

}

SMODS.Joker {
    key = "checklist",
    loc_txt = {
        name = "Checklist",
        text = {
            "Gains {X:mult,C:white}x#2#{} Mult",
            "for each unique",
            "{C:attention}poker hand{} played",
            "{C:inactive}(Curently {X:mult,C:white}X#1#{} mult){}"
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = {
        extra = {
            x_mult = 1,
            gain = 0.25,
            played_hands = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        card.ability.extra.x_mult = 1
        for scoring_name, played_count in pairs(card.ability.extra.played_hands) do
			if played_count >= 1 then
				card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
			end
		end
		return {
			vars = {
				card.ability.extra.x_mult,
                card.ability.extra.gain
			}
		}
    end,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.played_hands[context.scoring_name] = (card.ability.extra.played_hands[context.scoring_name] or 0) + 1
        end
		if context.joker_main then
			card.ability.extra.x_mult = 1
			for scoring_name, played_count in pairs(card.ability.extra.played_hands) do
				if played_count >= 1 then
					card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
				end
			end
			return {
                message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } },
				Xmult_mod = card.ability.extra.x_mult
			}
		end
    end,

}

SMODS.Joker {
    key = "tower_of_babel",
    loc_txt = {
        name = "Tower of Babel",
        text = {
            "Creates a {C:tarot}Tower{} when a",
            "Blind is selected",
            "{C:red}Self-destructs{} when",
            "your full deck has 20 or",
            "more {C:attention}Stone Cards{}",
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 6,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.setting_blind and context.main_eval then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        SMODS.add_card{key = 'c_tower'}
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "BRICK", colour = G.C.SECONDARY_SET.Spectral})
            end
        end
        if context.joker_main and not context.blueprint then
            local stone_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_stone') then stone_tally = stone_tally + 1 end
                if stone_tally >= 20 then SMODS.destroy_cards(card,true,true) end
            end
        end
    end,

}

SMODS.Joker {
    key = "2048",
    loc_txt = {
        name = "2048",
        text = {
            "If {C:attention}first discard{} of",
            "round is {C:attention}2{} cards of the",
            "{C:attention}same rank{}, destroy",
            "both and create a card",
            "of the next rank"
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    config = { extra = { type = 'Pair' }, },
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.pre_discard and G.GAME.current_round.discards_used <= 0 and not context.hook and
            G.FUNCS.get_poker_hand_info(G.hand.highlighted) == card.ability.extra.type and #context.full_hand == 2 then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local copy_card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
            copy_card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, copy_card)
            G.hand:emplace(copy_card)
            SMODS.modify_rank(copy_card, 1)
            copy_card.states.visible = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    copy_card:start_materialize()
                    return true
                end
            }))
            return {
                message = 'Combined!',
                colour = G.C.CHIPS,
                func = function() -- This is for timing purposes, it runs after the message
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
                            return true
                        end
                    }))
                end,
            }
        end
        if context.discard and G.GAME.current_round.discards_used <= 0 and not context.hook and
            G.FUNCS.get_poker_hand_info(G.hand.highlighted) == card.ability.extra.type and #context.full_hand == 2 then
            return {
                remove = true
            }
        end
    end,

}

SMODS.Joker {
    key = "wizard",
    loc_txt = {
        name = "Wizard",
        text = {
            "When you use", "{C:tarot}#1#{},",
            "this Joker gains {X:mult,C:white}x#2#{} Mult",
            "{C:tarot}Tarot{} Changes after",
            "each {C:attention}Boss Blind{}",
            "{C:inactive}(Currently {X:mult,C:white}x#3#{}{C:inactive}){}"          
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    config = {
        extra = {
            active_tarot = 'c_wheel_of_fortune',
            gain = 0.2,
            x_mult = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize{ type = 'name_text', set = "Tarot", key = card.ability.extra.active_tarot },
                card.ability.extra.gain,
                card.ability.extra.x_mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.config.center_key == card.ability.extra.active_tarot then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
            return { message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } } }
        end
        if (context.beat_boss or (context.card_added and context.other_card == card)) and context.main_eval then
            local next_tarot = active_tarot
            while next_tarot == active_tarot or G.GAME.banned_keys[next_tarot] do
                next_tarot = pseudorandom_element(G.P_CENTER_POOLS.Tarot, pseudoseed('wizard')).key -- Preventing it from repeating by forcing a reroll any time it rolls the same one
            end
            card.ability.extra.active_tarot = next_tarot
            return {
                message = localize{ type = 'name_text', set = "Tarot", key = card.ability.extra.active_tarot },
                colour = G.C.PURPLE
            }
        end
        if context.joker_main then
            return {
                message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } },
				Xmult_mod = card.ability.extra.x_mult
            }
        end
    end,

}

SMODS.Joker {
    key = "astrologer",
    loc_txt = {
        name = "Astrologer",
        text = {
            "When you use", "{C:planet}#1#{},",
            "this Joker gains {X:mult,C:white}x#2#{} Mult",
            "{C:planet}Planet{} Changes after",
            "each {C:attention}Boss Blind{}",
            "{C:inactive}(Currently {X:mult,C:white}x#3#{}{C:inactive}){}"          
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    config = {
        extra = {
            active_planet = 'c_pluto',
            gain = 0.2,
            x_mult = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize{ type = 'name_text', set = "Planet", key = card.ability.extra.active_planet },
                card.ability.extra.gain,
                card.ability.extra.x_mult
            }
        }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.config.center_key == card.ability.extra.active_planet then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
            return { message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } } }
        end
        if (context.beat_boss or (context.card_added and context.other_card == card)) and context.main_eval then
            local next_planet = active_planet
            while next_planet == active_planet or G.GAME.banned_keys[next_planet] do
                next_planet = pseudorandom_element(G.P_CENTER_POOLS.Planet, pseudoseed('astrologer')).key -- Preventing it from repeating by forcing a reroll any time it rolls the same one
            end
            card.ability.extra.active_planet = next_planet
            return {
                message = localize{ type = 'name_text', set = "Planet", key = card.ability.extra.active_planet },
                colour = G.C.PURPLE
            }
        end
        if context.joker_main then
            return {
                message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.x_mult } },
				Xmult_mod = card.ability.extra.x_mult
            }
        end
    end,

}

SMODS.Joker {
    key = "flint",
    loc_txt = {
        name = "Flint Joker",
        text = {
            "{C:attention}Steel{} cards give",
            "{X:mult,C:white}X1.5{} Mult when scored"
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    config = {
        extra = {
            Xmult = 1.5
        }
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_steel') then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,

}

-- Joker idea by Lawn_Mower_6639

SMODS.Atlas {
    key = 'Chain Reaction',
    path = 'chain_reaction.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "chain_reaction",
    loc_txt = {
        name = "Chain Reaction",
        text = {
            "When a {C:attention}#1#{} of {V:1}#2#{} is",
            "destroyed, destroy all {C:attention}#1#{}s",
            "in your full deck",
            "{s:0.8}{C:inactive}Changes after each round{}{}"
        }
    },
    atlas = "Chain Reaction", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 1,
    cost = 1,
    blueprint_compat = false,
    config = {
        extra = {
            rank = '2',
            suit = 'Diamonds',
            id = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.rank, 'ranks'),
                localize(card.ability.extra.suit, 'suits_plural'),
                colours = { G.C.SUITS[card.ability.extra.suit] }
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint and context.remove_playing_cards then
            local removed = false
            for _, removed_card in ipairs(context.removed) do
                if removed_card:get_id() == card.ability.extra.id and removed_card:is_suit(card.ability.extra.suit) and not SMODS.has_no_rank(removed_card) and not SMODS.has_no_suit(removed_card) then
                    removed = true
                end
            end
            if removed then
                local to_destroy = {}
                for _, this_card in ipairs(G.playing_cards) do
                    if this_card:get_id() == card.ability.extra.id then
                        to_destroy[#to_destroy+1]=this_card
                        -- print(this_card.get_id())
                    end
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        SMODS.destroy_cards(to_destroy)
                        return true
                    end
                }))
                return {
                    focus = card,
                    message = "CHAIN REACTION",
                    colour = G.C.BLACK
                }
            end
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.rank = '2'
            card.ability.extra.suit = 'Diamonds'
            local valid_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) and not SMODS.has_no_rank(playing_card) then
                    valid_cards[#valid_cards + 1] = playing_card
                end
            end
            local chosen_card = pseudorandom_element(valid_cards, 'chain_reaction' .. G.GAME.round_resets.ante)
            card.ability.extra.rank = chosen_card.base.value
            card.ability.extra.suit = chosen_card.base.suit
            card.ability.extra.id = chosen_card.base.id
            return {
                focus = card,
                message = "NEW TARGET",
                colour = G.C.GOLD
            }
        end
    end,

    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Lawn_Mower_6639", G.C.DARK_EDITION, G.C.WHITE, 1.2 )
    end,

}

-- This Joker only exists to make hetero-flexible work
-- it should NEVER appear outside that challenge

SMODS.Joker {
    key = "hetero_flexible",
    loc_txt = {
        name = "Fragile Heterosexuality",
        text = {
            "You can only play {C:attention}Straights{}",
            "and {C:attention}Straight Flushes{}",
            "{C:inactive}Only used in{}",
            "{C:inactive}the Hetero-Flexible{}",
            "{C:inactive}Challenge{}",
        }
    },
    atlas = "redd_atlas_j", -- (depends if we use sprite sheets or not)
    post = { x = 0, y = 0}, -- (just use number lol)
    rarity = 1,
    cost = 0,
    blueprint_compat = false,
    no_collection = true,
    unlocked = false,

    calculate = function(self, card, context)
        if context.debuff_hand then
            if context.scoring_name ~= "Straight Flush" and context.scoring_name ~= "Straight" then
                return {
                    debuff = true
                }
            end
        end
    end,

}