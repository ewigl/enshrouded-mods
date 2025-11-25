-- [Mod 配置]
-- [Mod Configuration]

-- [倍率]
-- [Multiplier]
local COUNT_MULTIPLIER = 2.0

-- [最大安全数量] 防止设置过大而可能导致的潜在问题。游戏默认为 10。
-- [Maximum Safe Count] Prevents potential issues from setting too high. Default in-game is 10.
local MAX_SAFE_COUNT = 100

--

print(string.format("[More Flame Altars] Initializing with multiplier: %.1f", COUNT_MULTIPLIER))

local balancing_resources = game.assets.get_resources_by_type("keen::BalancingTable")
if #balancing_resources == 0 then
    print("[More Flame Altars] Error: keen::BalancingTable not found!")
    return
end

local data = balancing_resources[1].data
if not data then
    print("[More Flame Altars] Error: Unable to read BalancingTable!")
    return
end

if data.altarsPerFlameLevel then
    local count = 0
    local altar_levels = data.altarsPerFlameLevel

    for i, old_count in ipairs(altar_levels) do
        local raw_new_count = old_count * COUNT_MULTIPLIER
        local new_count = math.floor(raw_new_count + 0.5)

        if new_count > MAX_SAFE_COUNT then
            new_count = MAX_SAFE_COUNT
        end

        if new_count > old_count then
            altar_levels[i] = new_count

            print(string.format("[More Flame Altars] Altars at Flame Level %d: %d => %d", i, old_count, new_count))
            count = count + 1
        end
    end

    if count > 0 then
        print("[More Flame Altars] Modified " .. count .. " Flame Levels.")
    else
        print("[More Flame Altars] No changes made (Multiplier too low or MAX_SAFE_COUNT reached).")
    end
else
    print("[More Flame Altars] Error: altarsPerFlameLevel not found!")
end
