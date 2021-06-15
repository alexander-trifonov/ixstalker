
-- Here is where all of your clientside hooks should go.

-- Disables the crosshair permanently.
-- function Schema:CharacterLoaded(character)
-- 	self:ExampleFunction("@serverWelcome", character:GetName())
-- end

function Schema:BuildScoreboardMenu()
	return LocalPlayer():IsAdmin()
end

function Schema:BuildBusinessMenu()
	return false
end

local tab = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = -0.01,
	[ "$pp_colour_contrast" ] = 0.9,
	[ "$pp_colour_colour" ] = 0.8,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

function Schema:RenderScreenspaceEffects()
	DrawColorModify(tab)
end