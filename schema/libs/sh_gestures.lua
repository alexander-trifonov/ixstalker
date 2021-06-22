--male citizen: "g_righthandheavy" -> "g_righthandheavyapexarms"

ix.gestures = ix.gestures or {}


if (SERVER) then
    util.AddNetworkString("ixGesturesPlay")

    function ix.gestures.Play(client, sequence, autokill)
        autokill = autokill or false
        net.Start("ixGesturesPlay")
        net.WriteString(sequence)
        net.WriteBool(autokill)
        net.WriteEntity(client)
        net.SendOmit(client)
        client:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, client:LookupSequence(sequence), 0, autokill);
    end

    net.Receive("ixGesturesPlay", function(length, client)
        local sequence = net.ReadString()
        local autokill = net.ReadBool()
        local entity = client
        ix.gestures.Play(client, sequence, autokill)
    end)
end

if (CLIENT) then
    function ix.gestures.Play(sequence, autokill)
        autokill = autokill or false
        net.Start("ixGesturesPlay")
        net.WriteString(sequence)
        net.WriteBool(autokill)
        net.SendToServer()
        LocalPlayer():AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, client:LookupSequence(sequence), 0, autokill);
    end

    net.Receive("ixGesturesPlay", function()
        local sequence = net.ReadString()
        local autokill = net.ReadBool()
        local entity = net.ReadEntity()
        entity:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, entity:LookupSequence(sequence), 0, autokill);
    end)
end

ix.command.Add("TestPlay", {
    description = "Make everyone play an animation",
    superAdminOnly = true,
    OnRun = function(self, client)
        ix.gestures.Play(player.GetAll()[2], "g_look", true) 
    end
})

ix.command.Add("play", {
    description = "Play a gesture",
    superAdminOnly = false,
    arguments = {
        ix.type.text
    },
    OnRun = function(self, client, sequence)
        ix.gestures.Play(client, sequence, true)
    end
})