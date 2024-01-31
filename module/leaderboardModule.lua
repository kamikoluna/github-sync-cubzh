leaderboardModule = {}
leaderboardModuleMetatable = {
	__index = {
		_isInit = false,
		_init = function(self)	
			if self._isInit then return end
			self._isInit = true
		end,
		sync = function(self)
			local e = Event()
			e.action = "lb_g"
			e:SendTo(Server)
		end,
		resetScore = function(self, resetvalue)
			if not self._isInit then self:_init() end
			local e = Event()
			e.action = "lb_sf"
			e.pname = Player.Username
			e.s = resetvalue or 0
			e:SendTo(Server)
		end,
		addScore = function(self, amount)
			if not self._isInit then self:_init() end
			local e = Event()
			e.action = "lb_as"
			e.pname = Player.Username
			e.a = amount
			e:SendTo(Server)
		end,
		saveScore = function(self, score)
			if not self._isInit then self:_init() end
			local e = Event()
			e.action = "lb_s"
			e.pname = Player.Username
			e.s = score
			e:SendTo(Server)
		end,
		onPlayerJoin = function(self)
			if not self._isInit then self:_init() end
			self:sync()
		end,
		adminSetScore = function(self, username, score)
			if not self._isInit then self:_init() end
			local e = Event()
			e.action = "lb_sf"
			e.pname = username
			e.s = score
			e:SendTo(Server)
		end,
		onClientEvent = function(self, e)
			if e.action ~= "lb_cs" then return false end
			if e.action == "lb_cs" then
				local scores = JSON:Decode(e.s)
				if self.onSyncLeaderboard then
					self.onSyncLeaderboard(scores)
				end
			end
			return true
		end,
		_sortScores = function(self, scores)
			local sortedScores = {}
			for username, score in pairs(scores) do
				table.insert(sortedScores, {username = username, score = score})
			end
			table.sort(sortedScores, function(a, b)
				return a.score > b.score
			end)
			return sortedScores
		end,
		onServerEvent = function(self, e)
			if e.action ~= "lb_g" and e.action ~= "lb_s" and e.action ~= "lb_sf" and e.action ~= "lb_as" then return false end
			local store = KeyValueStore("lb_leaderboard")
			store:Get("scores", function(success, results)
			    if not success then print("Error: can't access leaderboard") return end
				local username = e.Sender.Username
				if username == "guest" then
					username = username.."_"..e.Sender.UserID
				end
				local pname = username

				local scores = results.scores == nil and {} or JSON:Decode(results.scores)
				if e.action == "lb_g" then
					local e2 = Event()
					e2.action = "lb_cs"
					e2.s = JSON:Encode(self:_sortScores(scores))
					e2:SendTo(e.Sender)
				elseif e.action == "lb_as" then
					local newScore = (scores[pname] or 0) + e.a
					scores[pname] = newScore
					local serializedScores = JSON:Encode(scores)
					store:Set("scores", serializedScores, function() end)
					
					-- send scores
					local e2 = Event()
					e2.action = "lb_cs"
					e2.s = JSON:Encode(self:_sortScores(scores))
					e2:SendTo(e.Sender)
				elseif e.action == "lb_s" or e.action == "lb_sf" then -- sf force
					local newScore = e.s
					if e.action == "lb_sf" or not scores[pname] or scores[pname] < newScore then
						scores[pname] = newScore
						local serializedScores = JSON:Encode(scores)
						store:Set("scores", serializedScores, function() end)
					end
				end
			end)
			return true
		end
	}
}
setmetatable(leaderboardModule, leaderboardModuleMetatable)

if type(Client.IsMobile) == "boolean" then -- only for client
	LocalEvent:Listen(LocalEvent.Name.DidReceiveEvent, function(e)
		if leaderboardModule:onClientEvent(e) then return true end
	end)

	LocalEvent:Listen(LocalEvent.Name.OnPlayerJoin, function(p)
		leaderboardModule:onPlayerJoin(p)
	end)
end

leaderboardUIModule = {}
local leaderboardUIModuleMetatable = {
	__index = {
		TOP_LEFT = 1,
		TOP_RIGHT = 2,
		create = function(self, title, nbScores, anchor)
			local ui = require("uikit")
			local anchor = anchor or self.TOP_LEFT
			local nbScores = nbScores or 5

			local bg = ui:createFrame(Color(0.0,0.0,0.0,0.5))

			local title = ui:createText(title or "Leaderboard")
			title:setParent(bg)
			title.object.Color = Color.White
			title.object.Anchor = { 0.5, 0.5}
			title.LocalPosition.Z = -1

			local entries = {}
			for i=1,nbScores do
				local entry = ui:createFrame()
				entry:setParent(bg)
				table.insert(entries, entry)

				local name = ui:createText("")
				entry.name = name
				name:setParent(entry)
				name.object.Color = Color.White
				name.object.Anchor = { 0, 0.5 }
				name.LocalPosition.Z = -1

				local score = ui:createText("")
				entry.score = score
				score:setParent(entry)
				score.object.Color = Color.White
				score.object.Anchor = { 1, 0.5 }
				score.LocalPosition.Z = -1
			end

			bg.parentDidResize = function()
				local width = math.max(225, title.Width + 10)
				bg.Width = width

				local height = title.Height + 6
				for k,e in ipairs(entries) do
					e.Width = width
					e.Height = e.name.Height + 6
					height = height + e.Height

					e.LocalPosition.Y = (nbScores - k) * e.Height
					e.name.LocalPosition = Number3(5, e.Height / 2, 0)
					e.score.LocalPosition = Number3(e.Width - 5, e.Height / 2, 0)
				end
				bg.Height = height
				title.LocalPosition = Number3(width / 2, height - title.Height / 2 - 3, 0)

				local posX = 0
				if anchor == self.TOP_RIGHT then
					posX = Screen.Width - bg.Width
				end
				bg.LocalPosition = Number3(posX, Screen.Height - bg.Height - Screen.SafeArea.Top, 0)
			end
			bg:parentDidResize()

			bg.update = function(bg, list)
				for k,entry in ipairs(entries) do
					local data = list[k]
					local name = data.username or ""
					local score = data.score or ""
					if #name > 15 then
						name = string.sub(name,1,12).."..."
					end
					entry.name.object.Text = name
					entry.score.object.Text = tostring(score)
				end
			end

			return bg
		end
	}
}
setmetatable(leaderboardUIModule,leaderboardUIModuleMetatable)
