
-- Here is where all of your serverside hooks should go.

-- Change death sounds of people in the police faction to the metropolice death sound.
function Schema:GetPlayerDeathSound(client)
	local character = client:GetCharacter()

	if (character and character:IsPolice()) then
		return "NPC_MetroPolice.Die"
	end
end


function Schema:OnCharacterCreated(client, character)
	character:SetData("modelOriginal", character:GetModel()) -- prime, original player model he was created with. Usefull for outfit system
end