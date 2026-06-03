DoIncludeScript("bindings.lua", nil)

function Spawn()
	-- Registers a function to get called each time the entity updates, or "thinks"
	thisEntity:SetContextThink(nil, MainThinkFunc, 0)
end

function MainThinkFunc()
	local playerEnt_pos = Entities:GetLocalPlayer()
	local startVector = playerEnt_pos:EyePosition()
	local playerHealth = playerEnt_pos:GetHealth()
	local traceTable =
	{
		startpos = startVector;
		endpos = startVector + RotatePosition(Vector(0,0,0), playerEnt_pos:EyeAngles(), Vector(200, 0, 0));
		ignore = playerEnt_pos;
		mask =  33636363; -- TRACE_MASK_PLAYER_SOLID from L4D2 script API, may not be correct for Source 2.
	}
	local fullpos = string.sub(string.format("%s", startVector),26,-2)
	--print(fullpos)
	local xpos_index = string.find(fullpos, " ")
	--print(xpos_index)
	local xpos = tonumber(string.sub(fullpos,0,xpos_index - 1))
	--print("Current x position: " .. xpos)
	local ypos_index = string.find(fullpos, " ", xpos_index + 1)
	--print(ypos_index)
	local ypos = tonumber(string.sub(fullpos,xpos_index + 1,ypos_index - 1))
	--print("Current y position: " .. ypos)
	local zpos = tonumber(string.sub(fullpos,ypos_index + 1,fullpos:len()))
	--print("Current z position: " .. zpos)
	
	-- POSITION
	if GetMapName() == "a1_intro_world" then
		if ( xpos > 464 and xpos < 519 ) and ( ypos > -2374 and ypos < -2303 ) then
			if _G.end_vent_shown == nil then
				local ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=5, ["x"]=-1, ["y"]=0.6})
				DoEntFireByInstanceHandle(ent, "SetText", "Press [" .. INTERACT .. "] to open the vent\n\nPress [" .. CROUCH .. "] and [" .. JUMP .. "] to get into the vent", 0, nil, nil)
				DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
				_G.end_vent_shown = "1"
			end
		elseif ( xpos > 562 and xpos < 655 ) and ( ypos > -2359 and ypos < -2310 ) then
			SendToConsole("ent_fire 563_vent_phys_hinge setoffset 0")
		end
	elseif GetMapName() == "a1_intro_world_2" then
		if ( xpos > -1370.55 and xpos < -1366.44 ) and ( ypos > 2295 and ypos < 2343 ) and ( zpos > -100 and zpos < -90 ) then
			SendToConsole("setpos_player 1 -1408 2307 -114")
			SendToConsole("ent_fire 4962_car_door_left_front open")
		elseif ( xpos > -1745 and xpos < -1710 ) and ( ypos > 324 and ypos < 327 ) and ( zpos > 140 and zpos < 143 ) then
			SendToConsole("setpos_player 1 -1727.60 303.17 94.03")
		end
	end
	
	return 0.5
end