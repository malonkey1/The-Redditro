SMODS.Sprite:new("party_pack", Redditro.mod.path, "party_pack.png", 71, 95, "party_pack"):register()

SMODS.Booster {
    key = "party_pack_1",
    weight = 1,
    kind = 'party_pack',
    cost = 4,
    atlas = "party_pack",
    pos = { x = 0, y = 0 },
    config = { extra = 4, choose = 1 },
    group_key = "k_party_pack",
    draw_hand = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1,-3),
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        local _card
        local _edition = poll_edition('party_pack_edition' .. G.GAME.round_resets.ante, 2, true)
        local _seal = SMODS.poll_seal({ mod = 10 })
        local _planet, _hand, _tally = nil, nil, 0
        if pseudorandom('party_pack') < 8/83 then
            _card = {
                set = "Spectral",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "party_pack_spectral"
            }
        elseif pseudorandom('party_pack') < 20/83 then
            _card = {
                set = "Playing Card",
                edition = _edition,
                seal = _seal,
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "party_pack_playing"
            }
        elseif pseudorandom('party_pack') < 38/83 then
            _card = {
                set = "Planet",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "party_pack_planet"
            }
        elseif pseudorandom('party_pack') < 56/83 then
            _card = {
                set = "Tarot",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "party_pack_tarot"
            }
        else
            _card = {
                set = "Joker",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "party_pack_joker"
            }
        end
        return _card
    end,
}

