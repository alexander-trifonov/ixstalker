PLUGIN.name = "AddResource Temporary"
PLUGIN.author = "Mobious"
PLUGIN.description = "pENIS  RESOURCES"
resource.AddFile("resource/fonts/agletterica.ttf")

if (CLIENT) then

function Schema:LoadFonts(font, genericFont)
    surface.CreateFont("ixStalkerChat", {
        font = "AGLettericaCondensed",
        extended = true,
        size = 20,
        weight = 800,
        blursize = 1,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    })

    surface.CreateFont("ixStalkerChatName", {
        font = "AGLettericaCondensed",
        extended = true,
        size = 24,
        weight = 800,
        blursize = 1,
        antialias = true
    })
end

-- chat.PlaySound = function()
--     surface.PlaySound("physics/flesh/flesh_impact_hard1.wav")
-- end

end

function Schema:InitializedChatClasses()
    ix.chat.Register("pm", {
        format = "[PM] %s -> %s: %s",
        color = Color(125, 150, 75, 255),
        deadCanChat = true,
        font = "ixStalkerChat",
    
        OnChatAdd = function(self, speaker, text, bAnonymous, data)
            chat.AddText(self.color, speaker, self.color, "\n [PDA]: "..text)-- string.format(self.format, speaker:GetName(), data.target:GetName(), text))
    
            --if (LocalPlayer() != speaker) then
                surface.PlaySound("hl1/fvox/bell.wav")
            --end
        end
    })
    
    ix.chat.Register("it", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(ix.config.Get("chatColor"), "** "..text.." **")
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/It"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        deadCanChat = true
    })

    ix.chat.Register("me", {
        --GetColor = ix.chat.classes.ic.GetColor,
        color = Color(125, 150, 75, 255),
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/Me", "/Action"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        deadCanChat = true
    })
    if (CLIENT) then
        ix.chat.classes["ic"].font = "ixStalkerChat";
        ix.chat.classes["w"].font = "ixStalkerChat";
        ix.chat.classes["y"].font = "ixStalkerChat";
        ix.chat.classes["me"].font = "ixStalkerChat";
        ix.chat.classes["it"].font = "ixStalkerChat";
    end
end

    -- Actions and such.
