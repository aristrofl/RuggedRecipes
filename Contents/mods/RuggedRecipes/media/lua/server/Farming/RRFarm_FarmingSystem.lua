require 'Farming/SFarmingSystem'

-- grow the plant
function SFarmingSystem:growPlant(luaObject, nextGrowing, updateNbOfGrow)
	if(luaObject.state == "seeded") then
		local new = luaObject.nbOfGrow <= 0
		if(luaObject.typeOfSeed == "Carrots") then
			luaObject = farming_vegetableconf.growCarrots(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Broccoli") then
			luaObject = farming_vegetableconf.growBroccoli(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Strawberry plant") then
			luaObject = farming_vegetableconf.growStrewberries(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Radishes") then
			luaObject = farming_vegetableconf.growRedRadish(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Tomato") then
			luaObject = farming_vegetableconf.growTomato(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Potatoes") then
			luaObject = farming_vegetableconf.growPotato(luaObject, nextGrowing, updateNbOfGrow)
		elseif(luaObject.typeOfSeed == "Cabbages") then
			luaObject = farming_vegetableconf.growCabbage(luaObject, nextGrowing, updateNbOfGrow)
		elseif luaObject.typeOfSeed then
			if farming_vegetableconf.props[luaObject.typeOfSeed].growCode ~= nil then
				local growCode = farming_vegetableconf.props[luaObject.typeOfSeed].growCode
				luaObject = assert(loadstring('return '..growCode..'(...)'))(luaObject, nextGrowing, updateNbOfGrow)
			end
		end
		-- maybe this plant gonna be disease
		if not new and luaObject.nbOfGrow > 0 then
			self:diseaseThis(luaObject, true)
		end
		luaObject.nbOfGrow = luaObject.nbOfGrow + 1
	end
end

function SFarmingSystem:harvest(luaObject, player)
	local props = farming_vegetableconf.props[luaObject.typeOfSeed]
	local numberOfVeg = getVegetablesNumber(props.minVeg, props.maxVeg, props.minVegAutorized, props.maxVegAutorized, luaObject)
	if player then
		player:sendObjectChange('addItemOfType', { type = props.vegetableName, count = numberOfVeg })
	end

	if luaObject.hasSeed and player then
		player:sendObjectChange('addItemOfType', { type = props.seedName, count = (props.seedPerVeg * numberOfVeg) })
	end

	luaObject.hasVegetable = false
	luaObject.hasSeed = false

	-- the strawberrie don't disapear, it goes on phase 2 again
	if luaObject.typeOfSeed == "Strawberry plant" then
		luaObject.nbOfGrow = 1
		self:growPlant(luaObject, nil, true)
		luaObject:saveData()
	elseif luaObject.retainOnHarvest ~= nil then
		luaObject.nbOfGrow = luaObject.retainOnHarvest
		self:growPlant(luaObject, nil, true)
		luaObject:saveData()
	else
		self:removePlant(luaObject)
	end
end

-- get the object name depending on his current phase
farming_vegetableconf.getObjectName = function(plant)
	if plant.state == "plow" then return getText("Farming_Plowed_Land") end
	if plant.state == "destroy" then return getText("Farming_Destroyed") .. " " .. getText("Farming_" .. plant.typeOfSeed) end
	if plant.state == "dry" then return getText("Farming_Receding") .. " " .. getText("Farming_" .. plant.typeOfSeed) end
	if plant.state == "rotten" then return getText("Farming_Rotten") .. " " .. getText("Farming_" .. plant.typeOfSeed) end
	if plant.nbOfGrow <= 1 then
		if plant.phaseName1 ~= nil then
			return getText(plant.phaseName1) .. " " .. getText("Farming_" ..plant.typeOfSeed);
		else
			return getText("Farming_Seedling") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
	elseif plant.nbOfGrow <= 4 then
		return getText("Farming_Young") .. " " .. getText("Farming_" ..plant.typeOfSeed);
	elseif plant.nbOfGrow == 5 then
        if plant.typeOfSeed == "Tomato" then
            return getText("Farming_Young") .. " " .. getText("Farming_" ..plant.typeOfSeed);
        end
		if plant.typeOfSeed == "Strawberry plant" or plant.typeOfSeed == "Potatoes" or plant.typeOfSeed == "Corn" then
			return getText("Farming_In_bloom") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		else
			return getText("Farming_Ready_for_Harvest") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
	elseif plant.nbOfGrow == 6 then
		if plant.phaseName6 ~= nil then
			return getText(plant.phaseName6) .. " " .. getText("Farming_" ..plant.typeOfSeed);
		else
			return getText("Farming_Seed-bearing") .. " " .. getText("Farming_" ..plant.typeOfSeed);
		end
	end
	return "Mystery Plant"
end