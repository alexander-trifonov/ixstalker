
-- Here is where all of your clientside hooks should go.

-- Disables the crosshair permanently.
-- function Schema:CharacterLoaded(character)
-- 	self:ExampleFunction("@serverWelcome", character:GetName())
-- end


-- function Schema:ShouldShowPlayerOnScoreboard(client)
-- 	return false
-- end

function Schema:BuildScoreboardMenu()
	return LocalPlayer():IsAdmin()
end

function Schema:BuildBusinessMenu()
	return false
end