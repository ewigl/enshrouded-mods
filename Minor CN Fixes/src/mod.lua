print("[Minor CN Fixes] Initializing...")

local localization = game.assets.get_resources_by_type("keen::LocaTagCollectionResource")[1].data

local content_hash = nil
for _, loc in ipairs(localization.languages) do
    if loc.language == "Zh_Cn" then
        content_hash = loc.dataHash
        break
    end
end
local original_guid = game.guid.from_content_hash(content_hash)
local original_buf = game.assets.get_content(original_guid):read_data()
local data = original_buf:read_resource("keen::LocaTagCollectionResourceData")

local tag_texts = {
    [3049645436] = "隐藏",
    [1529083238] = "隐藏手套",
    [1583741505] = "隐藏头盔",
    [4258249521] = "隐藏HUD",
    [1727251319] = "瘴气枢纽",
    [2198869897] = "比较装备",
    [1125830499] = "补充的瘴气停留时间",
    [2119713903] = "当瘴气停留时间低于%k时，击败敌人将掉落补充时间的恢复球。",
    [3014896536] = "使用 \"增殖工具 \"将其应用于基地中的建筑。",
    [3655386310] = "一种神奇的工具，能在基地的墙壁上<b>添加或移除各种杂草</b>。 \n\n它只能<b>在火焰祭坛范围内</b>使用，并且需要<b>增殖材料</b>。",
    [2624896441] = "一位在你的基地中生活与工作的乐于助人的村民。",
    [2593600341] = "一盆美丽的鲜花，能够美化你的世界。",
    [3813070346] = "与%k交谈",
    [3589593636] = "使你的<b>毒素抗性</b>增加<b>10%</b>，这将降低你承受的<b>毒素</b>伤害。\n\n除此以外，你还有<b>25%</b>的几率避免中毒。",
    [2706117185] = "伤害",
    [3398431124] = "防护",
    [1484904994] = "普通",
}

for _, tag in ipairs(data.tags) do
    if tag_texts[tag.id.value] then
        tag.text = tag_texts[tag.id.value]
    end
end

local new_buffer = buffer.create()
new_buffer:write_resource("keen::LocaTagCollectionResourceData", data)

local new_content = game.assets.create_content(new_buffer)
content_hash = game.guid.to_content_hash(new_content.guid)

for _, loc in ipairs(localization.languages) do
    if loc.language == "Zh_Cn" then
        loc.dataHash = content_hash
        break
    end
end

print("[Minor CN Fixes] Applied localization fixes.")
