SMODS.Sprite:new("redd_atlas_seal", Redditro.mod.path, "iron_seal.png", 71, 95, "redd_atlas_seal"):register()

-- ####################################### VERSION 1.0.4 ###############################################

SMODS.Seal {
    key = "redd_iron",
    name = "redd_iron",
    badge_colour = HEX("d9d9d9"),
    loc_txt = {
        label = "Iron Seal",
        name = "Iron Seal",
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
        if context.playing_card_end_of_round and context.cardarea == G.hand then
            -- if G.consumeables.config.card_limit > #G.consumeables.cards then
            --     SMODS.add_card{key = "c_chariot"}
            --     card:juice_up()
            -- end
            if #G.consumeables.cards < G.consumeables.config.card_limit then
                return {
                    SMODS.add_card{key = "c_chariot"},
                    message = localize('c_chariot'),
                    colour = G.C.BLACK
                }
            end
        end
    end,

}