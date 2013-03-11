
local BottleCap = LibStub("AceAddon-3.0"):NewAddon("BottleCap")
local db

local function bottleCaps(_, _, msg, ...)
	if db.verbose or msg == msg:upper() then
		-- Verbose Mode = all chat becomes lower case, regardless of original case
		-- else all ALL CAPS CHAT becomes lower case
		msg = msg:lower()

		-- Fix links
		msg = msg:gsub("|hitem", "|Hitem")
		msg = msg:gsub("|hquest", "|Hquest")
		msg = msg:gsub("|hspell", "|Hspell")
		msg = msg:gsub("|htalent", "|Htalent")
		msg = msg:gsub("|hachievement", "|Hachievement")
		msg = msg:gsub("|htrade", "|Htrade")
		msg = msg:gsub("|henchant", "|Henchant")
		msg = msg:gsub("|hglyph", "|Hglyph")
		msg = msg:gsub("|hjournal", "|Hjournal")
		msg = msg:gsub("|hbattlepet", "|Hbattlepet")
		msg = msg:gsub("|hurl", "|Hurl") -- website links created by Chatter, Prat etc.

		return false, msg, ...
	end
end


function BottleCap:OnEnable()
	db = LibStub("AceDB-3.0"):New("BottleCapDB", { profile = {
		verbose = false,
		filter = {
			SAY = true, YELL = true,
			GUILD = false, OFFICER = false,
			PARTY = true, PARTY_LEADER = true,
			INSTANCE_CHAT = true, INSTANCE_CHAT_LEADER = true,
			RAID = true, RAID_LEADER = true, RAID_WARNING = true,
			CHANNEL = true,
			WHISPER = true,
		},
	}}, "Default").profile

	-- redundant loop, but cleaner than alternatives
	for key, value in pairs(db.filter) do
		if value then ChatFrame_AddMessageEventFilter("CHAT_MSG_"..key, bottleCaps) end
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("BottleCap", {
		name = "Bottle Cap", type = "group",
		get = function(key) return db[key.arg] end,
		set = function(key, value) db[key.arg] = value end,
		args = {
			desc = {
				type = "description", order = 1,
				name = "Converts incoming ALL CAPS CHAT into lowercase text.",
			},
			filter = {
				name = "Channels to Monitor", type = "group", inline = true, order = 2,
				get = function(key) return db.filter[key.arg] end, set = "ToggleFilter", handler = self,
				args = {
					say = { type = "toggle", name = "Say", arg = "SAY", order = 2 },
					yell = { type = "toggle", name = "Yell", arg = "YELL", order = 3 },
					channel = { type = "toggle", name = "Channel", arg = "CHANNEL", order = 4 },
					guild = { type = "toggle", name = "Guild", arg = "GUILD", order = 5 },
					officer = { type = "toggle", name = "Guild Officer", arg = "OFFICER", order = 6 },
					party = { type = "toggle", name = "Party", arg = "PARTY", order = 7 },
					partyLeader = { type = "toggle", name = "Party Leader", arg = "PARTY_LEADER", order = 8 },
					instance = { type = "toggle", name = "Instance", arg = "INSTANCE_CHAT", order = 9 },
					instanceLeader = { type = "toggle", name = "Instance Leader", arg = "INSTANCE_CHAT_LEADER", order = 10 },
					raid = { type = "toggle", name = "Raid", arg = "RAID", order = 11 },
					raidLeader = { type = "toggle", name = "Raid Leader", arg = "RAID_LEADER", order = 12 },
					raidWarning = { type = "toggle", name = "Raid Warning", arg = "RAID_WARNING", order = 13 },
					whisper = { type = "toggle", name = "Whisper", arg = "WHISPER", order = 14 },
				},
			},
			verbose = {
				name = "Verbose Mode",
				desc = "Force all chat into lowercase text, regardless of original case.",
				type = "toggle", order = 3, arg = "verbose",
			},
		},
	})

	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BottleCap", "Bottle Cap")

	_G.SlashCmdList["BOTTLECAP"] = function() InterfaceOptionsFrame_OpenToCategory("Bottle Cap") end
	_G["SLASH_BOTTLECAP1"] = "/bottlecap"
end

function BottleCap:ToggleFilter(key, value)
	local channel = key.arg

	db.filter[channel] = value

	if value then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_"..channel, bottleCaps)
	else
		 -- attempting to remove a non-existant filter will fail silently
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_"..channel, bottleCaps)
	end
end
