# Éxtasis Estelar — scripts iniciales

Este repositorio contiene una base de scripts para un proyecto de Roblox pensado para desarrollarse desde móvil con Studio Lite.

## Scripts incluidos

- `Roblox/Camera/FirstPersonCamera.client.lua`: intenta fijar la cámara en primera persona.
- `Roblox/Player/PlayerStats.server.lua`: crea las estadísticas Coins y Wins.
- `Roblox/Rounds/MapRoundManager.server.lua`: controla el temporizador y rota entre mapas preparados.

## Importante sobre Studio Lite

Los scripts están escritos en Luau para Roblox, pero no se han probado dentro de tu proyecto de Studio Lite. La ubicación de los scripts y algunas funciones disponibles pueden variar según la versión del editor. No se garantiza que todos se puedan insertar o ejecutar desde Studio Lite.

## Preparación de las rondas

El sistema de rondas necesita esta estructura en el Explorador:

```
ServerStorage
└── Maps
    ├── MapaEstelar (Model)
    │   └── Spawns (Folder)
    │       ├── Spawn1 (Part)
    │       └── Spawn2 (Part)
    └── OtroMapa (Model)
        └── Spawns (Folder)
            └── Spawn1 (Part)
```

Cada mapa debe ser un Model y tener una carpeta `Spawns` con una o más Parts colocadas donde deban aparecer los jugadores. Las Parts de aparición deben estar ancladas.

Ubicaciones previstas:
- El LocalScript de cámara: `StarterPlayer > StarterPlayerScripts`.
- Los Scripts de estadísticas y rondas: `ServerScriptService`.

## Estado actual

Esta es una base inicial, no un juego completo listo para publicar. Las estadísticas aún no se guardan entre sesiones, no hay interfaz personalizada y el sistema de rondas no elige un ganador. Primero hay que verificar qué permite tu versión de Studio Lite y probar cada sistema por separado.
