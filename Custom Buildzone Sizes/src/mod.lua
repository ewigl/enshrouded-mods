-- [Mod 配置]
-- [Mod Configuration]

-- [倍率] 注意这里的倍率是边长，也就是说：如果倍率为 2，建造区域的长、宽、高均 x2，实际体积为原体积 8 倍。
-- [Scale] Note that this is for the side length. Meaning: if the scale is 2, resulting in a volume 8 times the original.
local RANGE_MULTIPLIER = 1.5

-- [保留高度] 如果为 true，则不缩放高度。
-- [Preserve Height] If true, the height will not be scaled, preserving the original dimension.
local PRESERVE_HEIGHT = true

-- [最大安全边长] 防止过大导致游戏崩溃，我也不知道多大会导致游戏崩溃，仅供以防万一。目前游戏默认最大建造区域边长是 160。
-- [Maximum Safe Length] To prevent game crashes due to excessive size; I don't know exactly what size would cause a crash, just in case.
-- Default maximum build area length in the game is 160.
local MAX_SAFE_SIZE = 320.0

--
print(string.format("[Custom Buildzone Sizes] Initializing with Multiplier=%.2f, ReserveHeight=%s...", RANGE_MULTIPLIER,
    tostring(PRESERVE_HEIGHT)))

local balancing_resources = game.assets.get_resources_by_type("keen::BalancingTable")
if #balancing_resources == 0 then
    print("[Custom Buildzone Sizes] Error: keen::BalancingTable not found!")
    return
end

local data = balancing_resources[1].data
if not data then
    print("[Custom Buildzone Sizes] Error: Unable to read BalancingTable data!")
    return
end

if data.buildzoneSizesPerAltarLevel then
    local count = 0
    for i, size in ipairs(data.buildzoneSizesPerAltarLevel) do
        local old_x = size.x

        local new_val_xz = old_x * RANGE_MULTIPLIER
        if new_val_xz > MAX_SAFE_SIZE then new_val_xz = MAX_SAFE_SIZE end

        local new_val_y = old_x
        if not PRESERVE_HEIGHT then
            new_val_y = old_x * RANGE_MULTIPLIER
            if new_val_y > MAX_SAFE_SIZE then new_val_y = MAX_SAFE_SIZE end
        end

        if math.abs(new_val_xz - old_x) > 0.01 or math.abs(new_val_y - old_x) > 0.01 then
            size.x = new_val_xz
            size.z = new_val_xz

            size.y = new_val_y

            print(string.format(
                "[Custom Buildzone Sizes] Altar Level %d: X/Z: %.1f -> %.1f, Y(Height): %.1f -> %.1f", i - 1, old_x,
                new_val_xz, old_x, new_val_y))
            count = count + 1
        end
    end

    if count > 0 then
        print("[Custom Buildzone Sizes] Modified " .. count .. " Altar Levels.")
    else
        print("[Custom Buildzone Sizes] No changes made.")
    end
else
    print("[Custom Buildzone Sizes] Error: buildzoneSizesPerAltarLevel not found!")
end
