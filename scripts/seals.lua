SMODS.Sprite:new("redd_atlas_seal", Redditro.mod.path, "platinum_seal.png", 71, 95, "redd_atlas_seal"):register()

-- ####################################### VERSION 1.0.4 ###############################################

SMODS.Seal {
    key = "platinum",
    name = "platinum-seal",
    badge_colour = HEX("d9d9d9"),
    loc_txt = {
        label = "Platinum Seal",
        name = "Platinum Seal",
        text = {
            "Creates a {C:tarot}Chariot{} card",
            "if {C:attention}held{} in hand after",
            "the final played {C:attention}poker{}",
            "{C:attention}hand{} {C:inactive}(Must have room){}", 
        }
    },
    atlas = "redd_atlas_seal",
    pos = { x = 0, y = 0},
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.hand and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            SMODS.add_card(key = "chariot")
            card.juice_up(0.5, 0.5)
        end
    end,

}