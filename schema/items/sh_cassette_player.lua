ITEM.name = "Cassette Player"
ITEM.model = Model("models/unconid/walkmann/walkmann.mdl")
ITEM.description = "A blue cassette player"
ITEM.category = "Electronics"
ITEM.width = 1
ITEM.height = 1

ambient = ambient or {}
ambient.cassette = {
    "cassette_test/dontcry.mp3",
    "cassette_test/juarvleva1.mp3",
    "cassette_test/kino1.mp3",
    "cassette_test/kino2.mp3",
    "cassette_test/kino3.mp3",
    "cassette_test/kino4.mp3",
    "cassette_test/kino5.mp3",
    "cassette_test/kipelov1.mp3",
    "cassette_test/kipelov2.mp3",
    "cassette_test/komissar1.mp3",
    "cassette_test/lumen1.mp3",
    "cassette_test/miraj1.mp3",
    "cassette_test/miraj2.mp3",
    "cassette_test/molodoy.mp3",
    "cassette_test/splin1.mp3",
    "cassette_test/mgsv1.mp3",
    "cassette_test/eagles1.mp3",
    "cassette_test/kino7.mp3",
    "cassette_test/korneluk1.mp3",
    "cassette_test/kino6.mp3"
}
if (SERVER) then
    util.AddNetworkString("ixPlayCassette")
    util.AddNetworkString("ixStopCassette")
else
    net.Receive("ixPlayCassette", function()
        hook.Run("PlayAmbientMusic", "cassette", true)    
    end)
    net.Receive("ixStopCassette", function()
        hook.Run("StopAmbientMusic")
        hook.Run("PlayAmbientMusic", "normal")
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
    sound = "cassette/cassette-out-1.mp3",
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
    