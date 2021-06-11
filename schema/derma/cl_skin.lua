local gradient = surface.GetTextureID("vgui/gradient-d")
local gradientUp = surface.GetTextureID("vgui/gradient-u")
local gradientLeft = surface.GetTextureID("vgui/gradient-l")
local gradientRadial = Material("helix/gui/radial-gradient.png")
local defaultBackgroundColor = Color(30, 30, 30, 200)

local SKIN = derma.GetNamedSkin("helix")
derma.DefineSkin("helixStalker", "The base skin for the Helix framework with some modifications", SKIN)

function SKIN:PaintChatboxBackground(panel, width, height)
	ix.util.DrawBlur(panel, 2)

	if (panel:GetActive()) then
		surface.SetDrawColor(ColorAlpha(color_black, 200))
		surface.SetTexture(gradientUp)
		surface.DrawTexturedRect(0, panel.tabs.buttons:GetTall(), width, height)

        surface.SetDrawColor(ColorAlpha(color_black, 255))
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, panel.tabs.buttons:GetTall(), width, height)
        -- surface.SetDrawColor(0, 0, 0, 200)
        -- surface.DrawRect(0, panel.tabs.buttons:GetTall(), width, height)
	end

	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(0, 0, width, height)
end

derma.RefreshSkins()


function Schema:ForceDermaSkin()
	return "helixStalker"
end