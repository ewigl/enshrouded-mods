-- [Mod 配置]
-- [Mod Configuration]

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
    for i, material in ipairs(data.materials) do
        if i ~= 1 then
            material.densityScale = DENSITY_SCALE
            print(string.format("[Less Dense Shroud Fog] Set densityScale of volumetric fog material %d to %.2f", i,
                DENSITY_SCALE))
        end
    end
else
    print("[Less Dense Shroud Fog] Error: VolumetricFog3Resource materials not found!")
end
