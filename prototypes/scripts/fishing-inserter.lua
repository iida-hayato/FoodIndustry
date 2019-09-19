﻿if not util then require("prototypes.scripts.util") end

local fishingDistance = 5
local catchDistance = 2

local local_try_pickup_fish_at_position = function(inserter,entity)

	if #inserter.held_stack == 0 and distance(inserter.position.x,inserter.position.y,entity.position.x,entity.position.y) <= fishingDistance then
		inserter.pickup_position = {
			x = entity.position.x,
			y = entity.position.y
		}
		inserter.direction = inserter.direction
		if distance(inserter.held_stack_position.x,inserter.held_stack_position.y,entity.position.x,entity.position.y) <= catchDistance then
			if entity.prototype.mineable_properties.products ~= nil then
				for _, r in ipairs(entity.prototype.mineable_properties.products) do
					inserter.held_stack.set_stack({name=r.name, count=r.amount})
					break
				end
			end
			entity.destroy()
		end
	end
end

local local_fishing_inserter_process = function(entity)

	if entity.held_stack.valid_for_read then
		if entity.held_stack.count > 0 then
			return
		end
	end

	if entity.energy == 0 then
		return
	end

	local fish = get_entities_around(entity, 10, "fish")
	-- local fish_count = 0
	-- local spawner = nil
	local target = nil
	local current_dist = 0
	local target_dist = 100
	if fish ~= nil then
		for i, ent in pairs(fish) do
			if ent.prototype.type == "fish" then
				-- fish_count = fish_count + 1	
				local dist = distance(entity.held_stack_position.x,entity.held_stack_position.y,ent.position.x,ent.position.y)
				if dist > current_dist then
					current_dist = dist
					-- spawner = ent
				end
				if dist < target_dist then
					target_dist = dist
					target = ent
				end
			end
		end
	end
	if target ~= nil then	
		local_try_pickup_fish_at_position(entity,target)
	end
	-- if game.tick % 3600 == 0 then
	-- 	if spawner ~= nil and fish_count < 10 then
	-- 		local r = math.random()
	-- 		if r < 0.05 then
	-- 			entity.surface.create_entity({name="fish", amount=1, position=spawner.position})
	-- 			--player_print(r)
	-- 		end
	-- 	end
	-- end
end

local local_fishing_inserter_tick = function()
	if game.tick % 30 == 0 then
		for index, fishing_inserter in ipairs(global.foodi.fishing_inserters) do
			if fishing_inserter.valid then
				if not fishing_inserter.to_be_deconstructed(fishing_inserter.force) then					
				    local_fishing_inserter_process(fishing_inserter)				
				end
			end
		end
	end
end

local local_fishing_inserter_added = function(ent)
	if ent.name == "fishing-inserter" or ent.name == "burner-fishing-inserter" then
		ent.operable = false
		ent.set_filter(1,"raw-fish")
		table.insert(global.foodi.fishing_inserters, ent)
	end
end

local local_fishing_inserter_removed = function(entity)
	if entity.name == "fishing-inserter" or entity.name == "burner-fishing-inserter" then
		for index, fishing_inserter in ipairs(global.foodi.fishing_inserters) do
			if fishing_inserter.valid and fishing_inserter == entity then
				table.remove(global.foodi.fishing_inserters, index)
				return
			end
		end
	end
end

local isInitFishingInserter = false
function initFishingInserter()
	if isInitFishingInserter then
		return false
	end
	isInitFishingInserter = true
	if foodi.ticks ~= nil then
		table.insert(foodi.ticks,local_fishing_inserter_tick)
		table.insert(foodi.on_added,local_fishing_inserter_added)
		table.insert(foodi.on_remove,local_fishing_inserter_removed)
	end

	if global ~= nil then
		if not global.foodi then global.foodi = {} end
		if not global.foodi.fishing_inserters then global.foodi.fishing_inserters = {} end
	end

end