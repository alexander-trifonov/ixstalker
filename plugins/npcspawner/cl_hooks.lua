
net.Receive("ixNPCSpawnerManager", function()
	vgui.Create("ixNPCSpawnerManager"):Populate(net.ReadTable())
end)
