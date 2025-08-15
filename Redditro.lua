--- STEAMODDED HEADER
--- MOD_NAME: Redditro
--- MOD_ID: redditro
--- MOD_AUTHOR: [Hysterical ,Kathexis]
--- MOD_DESCRIPTION: Adds a set of jokers and other card ideas from r/Balatro subreddit.
--- BADGE_COLOUR: 9B42F5
--- PRIORITY: 100000
--- PREFIX: redd
--- DEPENDENCIES: [Steamodded>=1.0.0~BETA]
--- VERSION: 1.0.2
----------------------------------------------
------------MOD CODE -------------------------

Redditro = {}



Redditro.mod_id = 'redditro'
Redditro.INIT = {}


function SMODS.INIT.redditro()
    Redditro.mod = SMODS.findModByID(Redditro.mod_id)

    Redditro.VoucherTweaks = NFS.load(Redditro.mod.path .. "utils/VoucherTweaks.lua") or {}
    
    NFS.load(Redditro.mod.path .. "scripts/finished_jokers.lua")()
--    NFS.load(Redditro.mod.path .. "scripts/spectrals.lua")()
    NFS.load(Redditro.mod.path .. "scripts/tarots.lua")()
 --   NFS.load(Redditro.mod.path .. "scripts/seals.lua")()
    NFS.load(Redditro.mod.path .. "scripts/enhancements.lua")()
    NFS.load(Redditro.mod.path .. "scripts/vouchers.lua")()


    for _, v in pairs(Redditro.INIT) do
        if v and type(v) == 'function' then v() end
    end

    SMODS.LOAD_LOC()
end


local sprite_logo = SMODS.Atlas{
	key = "balatro",
	path = "redditro.png",
	px = 333,
	py = 216,
	prefix_config = { key = false },
}:register()