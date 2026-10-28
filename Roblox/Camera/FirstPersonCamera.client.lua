-- ÉXTASIS ESTELAR | Cámara en primera persona
-- Tipo: LocalScript
-- Colócalo en: StarterPlayer > StarterPlayerScripts
-- Funciona en PC y móvil con los controles de cámara estándar de Roblox.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function applyCamera()
	player.CameraMode = Enum.CameraMode.LockFirstPerson
	player.CameraMinZoomDistance = 0.5
	player.CameraMaxZoomDistance = 0.5
end

applyCamera()
player.CharacterAdded:Connect(function()
	task.wait(0.2)
	applyCamera()
end)

print("[Éxtasis Estelar] Cámara en primera persona lista.")
