SMODS.Sprite:new("redd_atlas_s", Redditro.mod.path, "redd_spectrals_atlas.png", 71, 95, "redd_atlas_s"):register()

-- ####################################### VERSION 1.0.4 ###############################################


SMODS.Consumable {
    set = "Spectral",
    key = "honk",
	config = {
        -- How many cards can be selected.
        max_highlighted = 1,
        -- the key of the seal to change to
        extra = 'redd_iron',
    },
    loc_vars = function(self, info_queue, card)
        -- Handle creating a tooltip with seal args.
        info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
        -- Description vars
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    loc_txt = {
        name = 'Patriarcha',
        text = {
            "Select {C:attention}#1#{} card to",
            "apply {C:attention}Iron Seal{}"
        }
    },
    cost = 4,
    atlas = "redd_atlas_s",
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true end }))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_seal(card.ability.extra, nil, true)
                return true end }))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}

SMODS.Consumable {
    key = 'shade',
    set = 'Spectral',
    config = { max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative_playing_card
        return { vars = { card.ability.max_highlighted } }
    end,
    loc_txt = {
        name = "Shade",
        text = {
            "Add {C:negative}Negative{} to",
            "{C:attention}#1#{} selected card in hand"
        }
    },
    cost = 4,
    atlas = "redd_atlas_s",
    pos = {x=0, y=0},
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                G.hand.highlighted[1]:set_edition('e_negative', true)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end,
    -- The config field already handles the functionality so it doesn't need to be implemented
    -- The following is how the implementation would be
    --[[
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted <= card.config.max_highlighted and #G.hand.highlighted > 0
    end
    --]]
}