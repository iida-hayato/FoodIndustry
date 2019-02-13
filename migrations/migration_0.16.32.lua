for i, force in pairs(game.forces) do
	force.recipes["fi-table-logo-lamp"].enabled = force.technologies["optics"].researched
	force.recipes["fi-fluid-tank"].enabled = force.technologies["fluid-handling"].researched
end

-- inicialize new global variables
if not global.drinks then
	global.drinks = {}      -- values of current drinking (new!)
end
if not global.food_eaten_energy then
	global.food_eaten_energy = {}    -- values of current food eaten (new!)
end

-- add migration for global.energy_max[index] with researched technology 
for index, player in pairs(game.players) do
	if player.valid and player.connected then
		local leftGui = player.gui.left
		
		if not leftGui.frame then break end
		if leftGui.frame.energylabel then  -- destroy all old frame data of GUI (after 0.16.30)
			leftGui.frame.destroy()
			player.print("FI migration_0.16.31: Old frame data of GUI (after 0.16.30) sucesfuly replaced")
		end
	end
	
	
	if player.connected then
		if not global.fullness[index] then
			global.fullness[index] = {}
		end
		if not global.energy_max[index] then
			global.energy_max[index] = 100 -- set initial max Energy for connected players
		end
	end
end