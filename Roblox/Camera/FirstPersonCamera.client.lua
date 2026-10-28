-- ÉXTASIS ESTELAR | Cámara en primera persona
-- Tipo: LocalScript
-- Ubicación prevista: StarterPlayer > StarterPlayerScripts
-- Nota: comprueba en Studio Lite si permite insertar LocalScripts aquí.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setFirstPerson()
	player.CameraMode = Enum.CameraMode.LockFirstPerson
end

setFirstPerson()

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	setFirstPerson()
end)
