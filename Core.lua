
local BottleCap = LibStub("AceAddon-3.0"):NewAddon("BottleCap")
local db

local function bottleCaps(_, _, msg, ...)
	if db.ignore and msg == msg:upper() then return true end -- prevent all caps from showing in the chatframes

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

		return false, msg, ...
	end
end


function BottleCap:OnEnable()
	self.db = LibStub("AceDB-3.0"):New("BottleCapDB", { profile = {
		verbose = false, ignore = true,
		filter = {
			SAY = true, YELL = true, GUILD = false, OFFICER = false,
			PARTY = true, RAID = true, RAID_LEADER = true, RAID_WARNING = true, 
			BATTLEGROUND = true, BATTLEGROUND_LEADER = true,
			CHANNEL = true, WHISPER = true,
		},
	}}, "Default")

	db = self.db.profile

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
				name = "Converts ALL CAPS CHAT into lowercase chat.",
			},
			filter = {
				name = "Channels to Monitor",
				get = function(key) return db.filter[key.arg] end, set = "ToggleFilter", handler = self,
				type = "group", inline = true, order = 2, args = {
					desc = {
						type = "description", order = 1, width = "full",
						name = "Choose which channels should be monitored for all caps chat.\nPlease note that removing all the ticks will render BottleCap useless.",
					},
					say = { type = "toggle", name = "Say", arg = "SAY", order = 2 },
					yell = { type = "toggle", name = "Yell", arg = "YELL", order = 3 },
					guild = { type = "toggle", name = "Guild", arg = "GUILD", order = 4 },
					officer = { type = "toggle", name = "Guild Officer", arg = "OFFICER", order = 5 },
					party = { type = "toggle", name = "Party", arg = "PARTY", order = 6 },
					raid = { type = "toggle", name = "Raid", arg = "RAID", order = 7 },
					raidleader = { type = "toggle", name = "Raid Leader", arg = "RAID_LEADER", order = 8 },
					raidwarning = { type = "toggle", name = "Raid Warning", arg = "RAID_WARNING", order = 9 },
					battleground = { type = "toggle", name = "Battleground", arg = "BATTLEGROUND", order = 10 },
					battlegroundleader = { type = "toggle", name = "Battleground Leader", arg = "BATTLEGROUND_LEADER", order = 11 },
					channel = { type = "toggle", name = "Channel", arg = "CHANNEL", order = 12 },
					whisper = { type = "toggle", name = "Whisper", arg = "WHISPER", order = 13 },
				},
			},
			verbose = {
				name = "Verbose Mode",
				desc = "Convert all chat into lowercase text, regardless of original case.",
				type = "toggle", order = 2, arg = "verbose",
			},
			ignore = {
				name = "Ignore",
				desc = "Prevent all caps chat from showing in your chat frames instead of forcing it into lowercase.  Text which is not all caps but was forced into lowercase by Verbose Mode is unaffected.",
				type = "toggle", order = 3, arg = "ignore",
			},
		},
	})

	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BottleCap", "Bottle Cap")

	_G.SlashCmdList["BOTTLECAP"] = function() InterfaceOptionsFrame_OpenToCategory("Bottle Cap") end
	_G["SLASH_BOTTLECAP1"] = "/bottlecap"
	_G["SLASH_BOTTLECAP2"] = "/bc"
end

function BottleCap:ToggleFilter(key, value)
	db.filter[key.arg] = value

	if value then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_"..key.arg, bottleCaps)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_"..key.arg, bottleCaps) -- attempting to remove a non-existant filter will fail silently
	end
end
