-- [Mod 配置]
-- [Mod Configuration]

-- 雾的消光系数，游戏默认是 0.3499999940395355。数值越高光线越难以穿透（越看不清）。
-- Fog extinction coefficient, Game's default is 0.3499999940395355. Higher values make light harder to penetrate (less visibility).
local EXTINCTION = 0.35

-- 默认是 1.0，数值越低雾越稀薄。不推荐设置过低，可能会影响游戏体验。
-- Game's Default is 1.0; lower values result in thinner fog. Not recommended to set too low, as it may affect gameplay experience.
local DENSITY_SCALE = 0.5

-- 屏障雾厚度，默认是 8。设置为 0 可以移除屏障雾。
-- Barrier fog thickness, default is 8. Setting to 0 removes barrier fog.
local BARRIER_FOG_THICKNESS = 0

--

print(string.format("[Less Dense Shroud Fog] Initializing with density: %.1f", DENSITY_SCALE))

local volumetric_fog3_resource = game.assets.get_resources_by_type("keen::VolumetricFog3Resource")
if #volumetric_fog3_resource == 0 then
    print("[Less Dense Shroud Fog] Error: keen::VolumetricFog3Resource not found!")
    return
end

local data = volumetric_fog3_resource[1].data
if not data then
    print("[Less Dense Shroud Fog] Error: Unable to read VolumetricFog3Resource!")
    return
end

if data.barrierFogThickness then
    data.barrierFogThickness = BARRIER_FOG_THICKNESS
    print(string.format("[Less Dense Shroud Fog] Set barrierFogThickness to %.1f", BARRIER_FOG_THICKNESS))
end

if data.materials then
    data.materials[2].extinction = EXTINCTION
    print(string.format("[Less Dense Shroud Fog] Set extinction to %.1f", EXTINCTION))

    data.materials[2].densityScale = DENSITY_SCALE
    print(string.format("[Less Dense Shroud Fog] Set densityScale to %.1f", DENSITY_SCALE))
else
    print("[Less Dense Shroud Fog] Error: VolumetricFog3Resource materials not found!")
end
