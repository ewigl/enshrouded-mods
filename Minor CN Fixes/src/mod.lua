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

print(string.format("[Minor CN Fixes] Loaded original localization data with %d tags.", #data.tags))

local mistranslation_tags = {
    [176227438] = "我的兄弟，我似乎已经真正到了无药可救的地步。护士海伦说我除了休息之外什么也做不了……但是我拒绝接受这种事。\n\n来自燃火荒原的人们说过远古者神通广大……<i>还记得那个方尖碑吗？小时候我们曾在那里玩耍。我决定无论如何都要去到那里。</i>\n也许那里能找到治好我的方法。不要跟过来，我心意已决。\n\n—维特尔",
    [219934874] = "改进后的魔法弹药，使用时将创造一枚寒冰矢，命中时对敌人造成伤害并使其减速。\n\n<b>法术：使用后会消耗</b>。装备该法术并使用<b>法力</b>来用<b>法杖施法。</b>",
    [235247107] = "这个可爱的毛绒玩具能够让最可怕的怪物也变得可爱起来。",
    [373717649] = "未设置过滤条件",
    [403972664] = "使用 选择/使用 选项时, 快捷键拥有双重功能。非选中状态的物品会被选中。已选中的物品会被使用。",
    [1021163939] = "寒冰矢 I",
    [1125830499] = "补充的瘴气停留时间",
    [1529083238] = "隐藏手套",
    [1583741505] = "隐藏头盔",
    [1727251319] = "瘴气枢纽",
    [2074075141] = "极巨魔法箱",
    [2119713903] = "当瘴气停留时间低于%k时，击败敌人将掉落补充时间的恢复球。",
    [2198869897] = "比较装备",
    [2207530326] = "今天，一小队难民从燃火荒原长途跋涉抵达这里。我一向不善于和陌生人打交道，但现在顾不得这么多了。我投入工作，包扎伤口。直到现在这仍是一场生死之战。遗憾的是，有些人死了。我们把他们安葬在<b>地下墓室</b>。愿北风指引他们走向来生。\n\n尽管如此，还有一个人可能会活下来。他腿上的伤口很深，但还没有到无法挽回的地步。伤者萨利姆笑得很开心。他说他欠我一条命......我想，这不过是运气罢了。",
    [2624896441] = "一位乐于助人的村民，很乐意在你的基地中生活与工作。",
    [2665461345] = "其名为瘴气，一种只求蔓延与吞噬的毁灭性迷雾。",
    [2706117185] = "伤害",
    [3014896536] = "使用 \"增殖工具 \"将其应用于基地中的建筑。",
    [3049645436] = "隐藏",
    [3070911806] = "总算来了！看看你，一副弱不禁风的样子。堂堂火之子就这种样子么？首先需要的是装备... 幸好你先找到了我。你可以先从制作<b>废料剑、尖刺棒或一些铠甲</b>开始着手！",
    [3203744016] = "寒冰矢 II",
    [3342269239] = "今天，我们又安葬了一个人。可怜的人。他一路旅行寻找喘息的机会，却只找到了废墟和残骸。海伦也说，这个教堂撑不住了。风呼啸着，每天晚上都能找到吹进大厅的新口子。我们的屋顶被暴风雨撕裂了，我们忙于照顾车队的人，没空修补它。然而，我们必须留下来。这里需要我们，在其他地方也几乎找不到容身之所。\n\n<i>在遗物和古物旁边</i>埋葬这些流浪汉总让我觉得不对劲，但也许海伦是对的。或许旧时代终究要为新的习俗和仪式让路。",
    [3398431124] = "防护",
    [3517621637] = "魔法弹药，使用时将创造一枚寒冰矢，命中时对敌人造成伤害并使其减速。\n\n<b>法术：使用后会消耗</b>。装备该法术并使用<b>法力</b>来用<b>法杖施法。</b>",
    [3655386310] = "一种神奇的工具，能在基地的墙壁上<b>添加或移除各种杂草</b>。 \n\n它只能<b>在火焰祭坛范围内</b>使用，并且需要<b>增殖材料</b>。",
    [3695884516] = "寒冰矢 I 的永恒版本。该法术会在命中敌人时对其造成伤害，并使其减速。\n\n<b>永恒法术</b>永恒法术不会消耗<b>。</b>装备永恒法术，消耗<b>法力</b>来用<b>法杖施法。</b>",
    [4258249521] = "隐藏HUD",
}

local no_translation_tags = {
}


for _, tag in ipairs(data.tags) do
    if mistranslation_tags[tag.id.value] then
        -- print(string.format("[Minor CN Fixes] Translating tag ID %d: '%s' -> '%s'", tag.id.value, tag.text, mistranslation_tags[tag.id.value]))
        tag.text = mistranslation_tags[tag.id.value]
    end
end

-- if no_translation_tags has any entries, add them to the tags list
if #no_translation_tags > 0 then
    print(string.format("[Minor CN Fixes] Adding %d new tags to localization data.", #no_translation_tags))
    for _, tag  in ipairs(no_translation_tags) do
        local new_tag = {
            id = { value = tag[1] },
            text = tag[2],
            arguments = {},
            genericArguments = 0
        }
        table.insert(data.tags, new_tag)
        -- print(string.format("[Minor CN Fixes] Added new tag %d: '%s'", tag[1], tag[2]))
    end

    table.sort(data.tags, function(a, b) return a.id.value < b.id.value end)
    
    print(string.format("[Minor CN Fixes] New localization data has %d tags.", #data.tags))
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
