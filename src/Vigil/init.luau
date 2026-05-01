local Vigil = {}

local Mount = require(script.Mount)
local Tracker = require(script.Tracker)


Vigil.Mount = Mount.MountPlayer --> Create/Get a harness
Vigil.Get = Mount.Get --> Get an existing harness

Vigil.Boolean = Tracker.Boolean --> Create a boolean tracker
Vigil.Stages = Tracker.Stages --> Create a stages tracker
Vigil.Numeric = Tracker.Numeric --> Create a numeric tracker

return Vigil