
SMODS.Sprite:new("redd_atlas_j", Redditro.mod.path, "redd_jokers_atlas.png", 71, 95, "redd_atlas_j"):register()
SMODS.Sprite:new("redd_ace", Redditro.mod.path, "Ace_sexual.png", 71, 95, "redd_ace"):register()


--[[
JOKER TEMPLATE:

SMODS.Joker {
    key = "redd_jokername",
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
    key = "redd_noise",
    loc_txt = {
        name = "Static Noise",
        text = {
            "Gains {X:mult,C:white} x0.5{} Mult if you",
            " {C:chips}Play{} or {C:red}Skip{} a {C:attention}Blind{}.",
            "Changes every blind",
            "Now {X:mult,C:white} x#1#{} Mult",
            "{C:inactive}Currently: #2#{}",
        }
    },
    atlas = "redd_atlas_j",
    pos = { x = 1, y = 0 },
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    config = { extra = { mult = 1, type = "skip" } },
   
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.type } }
    end,

    calculate = function(self, card, context)

        if (context.skip_blind or context.setting_blind) and not context.blueprint then 
            message = ""
            if context.skip_blind and card.ability.extra.type == "skip" then
                card.ability.extra.mult = card.ability.extra.mult + 0.5
                message = " - X0.5"
                card:juice_up(0.5, 0.5)
            end
            if context.setting_blind and card.ability.extra.type == "play" then
                card.ability.extra.mult = card.ability.extra.mult + 0.5
                message = " - X0.5"
                card:juice_up(0.5, 0.5)
            end
            local available = { "play", "skip" }
            local chosen = pseudorandom_element(available, pseudoseed("asc_noise"))
            card.ability.extra.type = chosen
            text = "Now " .. chosen .. message
            return { message = text, other_card = card }
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
    key = "redd_six_figures",
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
}

-- ####################################### VERSION 1.0.2 ###############################################


-- ################################## HYSTERICAL JOKERS ##########################################


SMODS.Atlas {
    key = 'cheese house',
    path = 'cheese house.png',
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'joker2',
    loc_txt = {
        name = 'Cheese House',
        text = {
            '{C:red}+5 {}Mult.',
            'If current {C:attention}Ante {}is {C:attention}8{}, or',
            'higher, {C:red}+50 {}Mult instead'
        }
    },
    atlas = 'cheese house',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            early_mult = 5,
            late_mult = 50
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
        local ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        return { mult = card.ability.extra[ante >=8 and 'late_mult' or 'early_mult']}
    end
end
}
-- credit to U/chum724 for joker idea and sprite, and MogDogBlog for original art (and nubbys number factory)

SMODS.Atlas {
    key = 'one for all',
    path = 'one for all.png',
    px = '71',
    py = '95'
}

SMODS.Joker {
    key = 'joker3',
    loc_txt = {
        name = 'one for all',
        text = {
            'Earn {C:attention}$1 {}for each owned {C:attention}joker {}',
            'at the end of each {C:attention}round.'
        }
    },
    atlas = 'one for all',
    pos = {x = 0, y = 0},
    blueprint_compat = false,
    rarity = 1,
    cost = 6,
    config = {extra = {dollars = 1}},
    local_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollars * (G.jokers and #G.jokers.cards or 0) } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * (G.jokers and #G.jokers.cards or 0)
    end
}
-- credit to U/emmanuelfelix700 for joker idea

SMODS.Atlas {
    key = 'Seven Eleven',
    path = '711.png',
    px = '71',
    py = '95'
}

SMODS.Joker {
    key = 'joker4',
    loc_txt = {
        name = 'Seven Eleven',
        text = {
        '{C:red}+11 {}mult if played hand',
        'contains a {C:attention}7{}.'
        }
    },
    atlas = 'Seven Eleven',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
    config = { extra = { mult = 11 }},
    local_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult}}
    end,
    calculate =function(self, card, context)
        if context.joker_main then
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard:get_id() == 7 then
            return { mult =
            card.ability.extra.mult}
                end
            end
        end
    end
    }
-- credit to U/pick-and-shot for joker idea 

SMODS.Atlas {
    key = 'joker5',
    path = 'we are legion.png',
    px = '71',
    py = '95',
}

SMODS.Joker{
    key = 'We Are Legion',
    loc_txt = {
        name = 'We Are Legion',
        text = {
            'Retriggers all played {C:attention}face {}cards twice'
        }
    },
    atlas = 'joker5',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    config = { extra = { repetitions = 2 } },
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:is_face() then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end
}
-- credit to U/TennoWolf for the joker idea

SMODS.Atlas {
    key = 'joker6',
    path = 'american healthcare.png',
    px = '71',
    py = '95',
}

SMODS.Joker{
    key = 'joker6',
    loc_txt = {
        name = 'American Healthcare',
        text = {
            'Prevents {C:attention}death {}when chips',
            'scored are insufficient. Upon',
            'activation: you must pay {C:attention}$200{}.'
        }
    },
    atlas = 'joker6',
    pos = {x = 0, y = 0},
    blueprint_compat = false,
    rarity = 4,
    cost = 20,
    config = {extra = {dollars = -200 }},
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and context.main_eval then
            if G.GAME.chips / G.GAME.blind.chips >= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand_text_area.blind_chips:juice_up()
                        G.hand_text_area.game_chips:juice_up()
                        return true
                    end
                }))
                return {
                    dollars = -200,
                    message = localize('k_saved_ex'),
                    saved = 'ph_mr_bones',
                    colour = G.C.RED
                }
            end
        end
    end,
}
-- Joker idea and sprite by U/Chemical_Golf2958

SMODS.Atlas{
    key = 'joker7',
    path = 'streamer luck.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker7',
    loc_txt = {
        name = 'Streamer Luck',
        text = {'Converts all played cards',
        'into {C:attention}lucky {}cards.'
    }
    },
    atlas = 'joker7',
    pos = {x = 0, y = 0},
    blueprint_compat = false,
    rarity = 2,
    cost = 7,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local faces = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                    faces[#faces + 1] = scored_card
                    scored_card:set_ability('m_lucky', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end,
}
-- Credit to U/Ultimate6722 for the joker idea

SMODS.Atlas{
    key = 'joker8',
    path = 'rainbow joker.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker8',
    loc_txt = {
        name = 'Rainbow Joker',
        text = {'{X:mult,C:white}+1X{} mult for each {C:attention}scoring{} unique',
    '{C:attention}suit {}in played hand'}
    },
    atlas = 'joker8',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 3,
    cost = 12,
    config = { extra = { Xmult } },
    calculate = function(self, card, context)
        if context.joker_main then
         local suitsInHand = {}
         for i,v in ipairs(context.scoring_hand) do
         suitsInHand[v.base.suit] = true
         end
     local count = 0
     for k,v in pairs(suitsInHand) do
     count = count + 1
     end
     return { Xmult = count }
    end
end
}
-- credit to U/NeoShard1 for joker idea, and U/Pivozhizh for joker art

SMODS.Atlas{
    key = 'joker9',
    path = 'red thread.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker9',
    loc_txt = {
        name = 'Red Thread',
        text = {
            '{X:mult,C:white}3X{} mult if all cards in hand are',
            '{C:hearts}hearts{}, or {C:diamonds}diamonds{}.'
        }
    },
    atlas = 'joker9',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    config = { extra = { xmult = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, localize('Hearts', 'suits_plural'), localize('Diamonds', 'suits_plural') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local all_red_suits = true
            for _, playing_card in ipairs(G.hand.cards) do
                if not playing_card:is_suit('Diamonds', nil, true) and not playing_card:is_suit('Hearts', nil, true) then
                    all_red_suits = false
                    break
                end
            end
            if all_red_suits then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}
-- Credit to U/Ultimate6722 for the joker idea

SMODS.Atlas{
    key = 'joker10',
    path = 'frying pan.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker10',
    loc_txt = {
        name = 'Frying Pan',
        text = {
            'At the end of each {C:attention}blind{}',
            'create an {C:attention}Egg',
            '(must have room)'
        }
    },
    atlas = 'joker10',
    pos = {x = 0, y = 0},
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    config = { extra = { creates = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.creates } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit and context.main_eval then
            local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                        SMODS.add_card{
                        key = "j_egg"
                        }                       
                        G.GAME.joker_buffer = 1
                    return true
                end
            }))
            return {
                message = localize('k_plus_joker'),
                colour = G.C.BLUE,
            }
        end
    end,
}
-- Credit to U/LogLucy for joker idea

SMODS.Atlas{
    key = 'joker11',
    path = 'sleep.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker11',
    loc_txt = {
        name = 'Sleepy Joker',
        text = {

        '{X:mult,C:white}7X {} mult if total {C:attention}chips{}',
        'is 250 or less.'
        }
    },
    atlas = 'joker11',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 3,
    cost = 10,
    config = {extra = {xmult = 7}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult }}
    end,
    calculate = function (self, card, context)
        if context.joker_main and hand_chips <=250 then
            return{
                xmult = card.ability.extra.xmult
            }
        end
    end,
}
-- Credit to U/LeastEquivalent5263 for joker idea

SMODS.Atlas{
    key = 'joker12',
    path = 'astro icecream.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker12',
    loc_txt = {
        name = 'Astronaut Icecream',
        text = {
            'After {C:attention}3 rounds{}, sell this to upgrade',
            'your {C:attention}last played poker hand {}by',
            '3 levels'
        }
    },
    atlas = 'joker12',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    config = { extra = { invis_rounds = 0, total_rounds = 3 } },
        loc_vars = function(self, info_queue, card)
        local main_end
    end, 
    calculate = function(self, card, context)
        if context.selling_self and (card.ability.extra.invis_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
            return {
                level_up = 3,
                message = localize('k_level_up_ex')
            }
        end
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1
            if card.ability.extra.invis_rounds == card.ability.extra.total_rounds then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.invis_rounds < card.ability.extra.total_rounds) and
                    (card.ability.extra.invis_rounds .. '/' .. card.ability.extra.total_rounds) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end
}
-- Credit to U/Stock-Ad-3113 for joker idea

SMODS.Atlas{
    key = 'joker14',
    path = 'distinct.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker14',
    loc_txt = {
        name = 'Legally Distinct',
        text = { 
            'All played {C:attention}face {}cards become',
            '{C:attention}steel {}cards when scored'
        }
    },
    atlas = 'joker14',
    pos = {x = 0, y = 0},
    rarity = 3,
    cost = 10,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local faces = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces[#faces + 1] = scored_card
                    scored_card:set_ability('m_steel', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if #faces > 0 then
                return {
                    colour = G.C.MONEY
                }
            end
        end
    end
}
-- Credit to U/Princemerkimer for joker idea and sprite

SMODS.Atlas{
    key = 'joker15',
    path = 'sniper.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker15',
    loc_txt = {
        name = 'Sniper',
        text = {
            'If total {C:attention}score {}is exactly the same',
            'as required {C:attention}score {}',
            'create a free etherial tag'
        }
    },
    atlas = 'joker15',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if G.GAME.chips / G.GAME.blind.chips == 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_tag(Tag('tag_ethereal'))
                        return true
                    end
                }))
            end
        end
    end,
} 
-- credit to u/whooligun for joker idea

SMODS.Atlas{
    key = 'joker16',
    path = 'crutch.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker16',
    loc_txt = {
        name = 'Crutch',
        text = {
            '{X:mult,C:white}3X {} mult.',
            'debuffed after ante 7.'
        }
    },
    atlas = 'joker16',
    pos = {x = 0, y = 0},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    config = {extra = {xmult = 3}},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if G.GAME.round_resets.ante >= 7 then

        card.debuff = true
        end
    end,
}
-- Credit to u/KevlarGorilla for joker idea

SMODS.Atlas{
    key = 'joker17',
    path = 'lie.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker17',
    loc_txt = {
        name = "Inconspicuous Joker",
        text = {
            'Does {C:attention}something{}...'
        }
    },
    atlas = 'joker17',
    pos = {x = 0, y = 0},
    rarity = 1,
    cost = 3,
    blueprint_compat = true
}
-- Credit to u/pequodbestboy for joker idea

SMODS.Atlas{
    key = 'joker18',
    path = 'pineapple.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker18',
    loc_txt = {
        name = "Pineapple Joker",
        text = {
            '{X:mult,C:white}2X {} mult for each scored',
            'card with the {C:hearts}heart {}suit.'
        }
    },
    atlas = 'joker18',
    pos = {x = 0, y = 0},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    config = { extra = { Xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}
-- Credit to j0ker 17 for joker idea

SMODS.Atlas{
    key = 'joker19',
    path = 'Goldfinger.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker19',
    loc_txt = {
        name = "Goldfinger",
        text = {
            '{X:mult,C:white}9X {}mult',
            'indestructable'
        }
    },
    atlas = 'joker19',
    pos = {x = 0, y = 0},
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    config = { extra = { Xmult = 9 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    in_pool = function(self, args)
        return G.GAME.pool_flags.vremade_cavendish_extinct
    end
}
-- credit to u/abemc123 for joker idea and sprite
SMODS.Joker:take_ownership('joker',
    { 
     calculate = function(self, card, context)
	 if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('vremade_cavendish') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.vremade_cavendish_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
	end
    },
    true
)
-- this is just cavendish rewrited in order to work with goldfinger

SMODS.Atlas{
    key = 'joker20',
    path = 'anarchist.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker20',
    loc_txt = {
        name = "Anarchist",
        text = {
            'Each scored {C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5',
            'gives {X:mult,C:white}X1.5 {} mult.',
            '{C:attention}Face {}cards are',
            '{C:red}debuffed{}.'
        }
    },
    atlas = 'joker20',
    pos = {x = 0, y = 0},
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    config = { extra = { Xmult = 1.5 } },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 2 or
                context.other_card:get_id() == 3 or
                context.other_card:get_id() == 4 or
                context.other_card:get_id() == 5 then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
        if context.debuff_card then
            if context.debuff_card:get_id() == 11 or
            context.debuff_card:get_id() == 12 or
            context.debuff_card:get_id() == 13 then
                return { debuff = true }
            end
        end
    end
}
-- credit to u/malonkey1 for joker idea and sprite

SMODS.Atlas{
    key = 'joker21',
    path = 'bottom half.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker21',
    loc_txt = {
        name = 'Bottom Half',
        text = {
            '{C:blue}+100 {}chips if hand contains {C:attention}2{}',
            'or fewer cards.'
        }
    },
    atlas = 'joker21',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    config = { extra = { chips = 100, size = 2 } },
    pixel_size = { h = 91 / 1.7 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand <= card.ability.extra.size then
            return {
                chips = card.ability.extra.chips
            }
        end
    end

}
-- credit to u/Jbinsky for joker idea
SMODS.Atlas{
    key = 'joker22',
    path = 'blush.png',
    px = '71',
    py = '95'
}

SMODS.Joker{
    key = 'joker22',
    loc_txt = {
        name = 'Blush',
        text = { 
            'All played {C:attention}face {}cards become',
            '{C:attention}wild {}cards when scored'
        }
    },
    atlas = 'joker22',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local faces = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces[#faces + 1] = scored_card
                    scored_card:set_ability('m_wild', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if #faces > 0 then
                return {
                    colour = G.C.MONEY
                }
            end
        end
    end
}


-- ####################################### VERSION 1.0.2 ###############################################