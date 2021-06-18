
-- Here is where all of your shared hooks should go.

-- Disable entity driving.
function Schema:CanDrive(client, entity)
	return false
end

-- function Schema:PlayerSwitchFlashlight(client, enabled)

-- end

function Schema:PlayerSwitchFlashlight(ply, enabled)
	if (IsValid(ply)) then
		if (ply:GetCharacter()) then
			local inventory = ply:GetCharacter():GetInventory()
			if (inventory) then
				if (inventory:HasItem("flashlight")) then
					return true
				else
					return false
				end
			end
		end
	end
	return false
end