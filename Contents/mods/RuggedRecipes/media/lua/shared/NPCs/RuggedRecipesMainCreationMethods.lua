require('NPCs/MainCreationMethods');

local function initRuggedRecipesTraits()
    --===========--
    --Good Traits--
    --===========--
	local fermento = TraitFactory.addTrait("fermento", getText("UI_trait_fermento"), 1, getText("UI_trait_fermentodesc"), false, false);
    fermento:getFreeRecipes():add("Make Kentucky Kimchi");
	fermento:getFreeRecipes():add("Make Jar of Pickles");
	local jerk = TraitFactory.addTrait("jerk", getText("UI_trait_jerk"), 1, getText("UI_trait_jerkdesc"), false, false);
    jerk:getFreeRecipes():add("Prepare Fish for Smoking");
	jerk:getFreeRecipes():add("Prepare Beef for Jerky");
	jerk:getFreeRecipes():add("Prepare Meat for Biltong");
	local shiner = TraitFactory.addTrait("shiner", getText("UI_trait_shiner"), 1, getText("UI_trait_shinerdesc"), false, false);
    shiner:getFreeRecipes():add("Create Hooch Mash");
	shiner:getFreeRecipes():add("Filter Hooch Mash");
    --===========--
    --Bad Traits --
    --===========--
    --local example = TraitFactory.addTrait("example", getText("UI_trait_example"), -#, getText("UI_trait_exampledesc"), false, false);
    --Exclusives
    --TraitFactory.setMutualExclusive("example", "example");
end

Events.OnGameBoot.Add(initRuggedRecipesTraits);
