require "Farming/farming_vegetableconf"

RRFarmNewVeggies = {}
-- Cucumber
-- Need 4 seeds
-- Water lvl 70
-- Need 4 weeks to grow (112h per phase)
RRFarmNewVeggies.growCucumber = function(planting, nextGrowing, updateNbOfGrow)
	local nbOfGrow = planting.nbOfGrow;
	local water = farming_vegetableconf.calcWater(planting.waterNeeded, planting.waterLvl);
	local diseaseLvl = farming_vegetableconf.calcDisease(planting.mildewLvl);
	if(nbOfGrow <= 0) then -- young
		nbOfGrow = 0;
		planting.nbOfGrow = 0;
		planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
		planting.waterNeeded = 80;
	elseif (nbOfGrow <= 4) then -- young
		if(water >= 0 and diseaseLvl >= 0) then
			planting = growNext(planting, farming_vegetableconf.getSpriteName(planting), farming_vegetableconf.getObjectName(planting), nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting.waterNeeded = farming_vegetableconf.props[planting.typeOfSeed].waterLvl;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 5) then -- mature
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, farming_vegetableconf.props[planting.typeOfSeed].timeToGrow + water + diseaseLvl);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (nbOfGrow == 6) then -- mature with seed
		if(water >= 0 and diseaseLvl >= 0) then
			planting.nextGrowing = calcNextGrowing(nextGrowing, 248);
			planting:setObjectName(farming_vegetableconf.getObjectName(planting))
			planting:setSpriteName(farming_vegetableconf.getSpriteName(planting))
			planting.hasVegetable = true;
			planting.hasSeed = true;
		else
			badPlant(water, nil, diseaseLvl, planting, nextGrowing, updateNbOfGrow);
		end
	elseif (planting.state ~= "rotten") then -- rotten
		planting:rottenThis()
	end
	return planting;
end

--Icons
farming_vegetableconf.icons["Cucumber"] = "media/textures/Item_Cucumber.png";

-- Cucumber
farming_vegetableconf.props["Cucumber"] = {};
farming_vegetableconf.props["Cucumber"].seedsRequired = 8;
farming_vegetableconf.props["Cucumber"].texture = "vegetation_farming_01_36";
farming_vegetableconf.props["Cucumber"].waterLvl = 70;
farming_vegetableconf.props["Cucumber"].timeToGrow = ZombRand(40,45);
farming_vegetableconf.props["Cucumber"].vegetableName = "RuggedRecipes.Cucumber";
farming_vegetableconf.props["Cucumber"].seedName = "RuggedRecipes.CucumberSeed";
farming_vegetableconf.props["Cucumber"].growCode = "RRFarmNewVeggies.growCucumber";
farming_vegetableconf.props["Cucumber"].seedPerVeg = 2;
farming_vegetableconf.props["Cucumber"].minVeg = 8;
farming_vegetableconf.props["Cucumber"].maxVeg = 12;
farming_vegetableconf.props["Cucumber"].minVegAutorized = 9;
farming_vegetableconf.props["Cucumber"].maxVegAutorized = 13;
farming_vegetableconf.props["Cucumber"].retainOnHarvest = 2;

farming_vegetableconf.sprite["Cucumber"] = {
"vegetation_farming_01_1",
"vegetation_farming_01_16",
"vegetation_farming_01_17",
"vegetation_farming_01_18",
"vegetation_farming_01_34",
"vegetation_farming_01_35",
"vegetation_farming_01_36",
"vegetation_farming_01_5",
}