SMODS.Challenge {
    key = 'hetero_flexible',
    jokers = {
        {id = 'j_toroid', eternal = true, edition = 'negative'},
        {id = 'j_shortcut', eternal = true, edition = 'negative'},
        {id = 'j_hetero_flexible', eternal = true, edition = 'negative'},
    },
    rules = {
        modifiers = {
            { id = 'hands', value = 2 },
            { id = 'discards', value = 2 },
        }
    },
    restrictions = {
        banned_cards = {
            { id = 'c_mercury' },
            { id = 'c_venus' },
            { id = 'c_earth' },
            { id = 'c_mars' },
            { id = 'c_jupiter' },
            { id = 'c_uranus' },
            { id = 'c_pluto' },
            { id = 'c_planet_x' },
            { id = 'c_ceres' },
            { id = 'c_eris' },
            { id = 'c_high_priestess' },
            { id = 'c_temperance' },
            { id = 'c_ouija' },
            { id = 'j_jolly' },
            { id = 'j_zany' },
            { id = 'j_mad' },
            { id = 'j_sly' },
            { id = 'j_half' },
            { id = 'j_clever' },
            { id = 'j_wily' },
            { id = 'j_obelisk' },
            { id = 'j_redd_high_five' },
            { id = 'j_joker21' },
        },
        banned_tags = {
            { id = 'tag_orbital' },
        },
        banned_other = {
            { id = 'bl_eye', type = 'blind' },
        },
    },
}