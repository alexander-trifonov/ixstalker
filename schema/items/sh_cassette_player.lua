ITEM.name = "Кассетный проигрыватель"
ITEM.model = Model("models/unconid/walkmann/walkmann.mdl")
ITEM.description = "Синий кассетный проигрыватель, американский"
ITEM.category = "Electronics"
ITEM.width = 1
ITEM.height = 1

ambient = ambient or {}
ambient.cassette = {
    "cassette/dontcry.mp3",
    "cassette/juarvleva1.mp3",
    "cassette/kino1.mp3",
    "cassette/kino2.mp3",
    "cassette/kino3.mp3",
    "cassette/kino4.mp3",
    "cassette/kino5.mp3",
    "cassette/kipelov1.mp3",
    "cassette/kipelov2.mp3",
    "cassette/komissar1.mp3",
    "cassette/lumen1.mp3",
    "cassette/miraj1.mp3",
    "cassette/miraj2.mp3",
    "cassette/molodoy.mp3",
    "cassette/splin1.mp3",
    "cassette/mgsv1.mp3",
    "cassette/eagles1.mp3",
    "cassette/kino7.mp3",
    "cassette/korneluk1.mp3",
    "cassette/kino6.mp3"
}
if (SERVER) then
    util.AddNetworkString("ixPlayCassette")
    util.AddNetworkString("ixStopCassette")
else
    net.Receive("ixPlayCassette", function()
        hook.Run("PlayAmbientMusic", "cassette", true, 0)    
    end)
    net.Receive("ixStopCassette", function()
        hook.Run("StopAmbientMusic")
        hook.Run("PlayAmbientMusic", "normal") -- launch a normal ambient
    end)
end

ITEM.functions.Play = {
    name = "Включить",
    sound = "cassette/cassette-in-1.mp3",
	OnRun = function(item)
        net.Start("ixPlayCassette")
        net.Send(item:GetOwner())
		return false
	end,
    OnCanRun = function(item)
        return IsValid(item:GetOwner())
    end
}

ITEM.functions.Next = {
    name = "Следующий",
    sound = "cassette/cassette-in-1.mp3",
	OnRun = function(item)
        net.Start("ixPlayCassette")
        net.Send(item:GetOwner())
		return false
	end,
    OnCanRun = function(item)
        return IsValid(item:GetOwner())
    end
}

ITEM.functions.Stop = {
    name = "Выключить",
    sound = "cassette/cassette-eject-1.mp3",
	OnRun = function(item)
        net.Start("ixStopCassette")
        net.Send(item:GetOwner())
        return false
	end,
    OnCanRun = function(item)
        return IsValid(item:GetOwner())
    end
}

ITEM.postHooks.drop = function(item, result)
    net.Start("ixStopCassette")
    net.Send(item.player)
end
--Hey 2