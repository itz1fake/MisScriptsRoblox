-- ÉXTASIS ESTELAR
-- Archivo: FirstPersonCamera.client.lua
-- Ubicación en Roblox Studio: StarterPlayer > StarterPlayerScripts
-- Fuerza la cámara en primera persona para cada jugador.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

player.CameraMode = Enum.CameraMode.LockFirstPerson
player.CameraMinZoomDistance = 0.5
player.CameraMaxZoomDistance = 0.5

print("Éxtasis Estelar: cámara en primera persona activada.")
