local function get_translations(locale)
	local localization = game.assets.get_resources_by_type("keen::LocaTagCollectionResource")[1].data
	local content_hash = nil

	if locale ~= nil then
		for _, loc in ipairs(localization.languages) do
			if loc.language == locale then
				content_hash = loc.dataHash
				break
			end
		end
	else
		content_hash = localization.keenglishDataHash
	end

	if content_hash == nil then
		error("Locale not found: " .. tostring(locale))
	end

	local guid = game.guid.from_content_hash(content_hash)
	local buf = game.assets.get_content(guid):read_data()

	local localization_data = buf:read_resource("keen::LocaTagCollectionResourceData")

	local dict = {}

	for _, tag in ipairs(localization_data.tags) do
		dict[tag.id.value] = tag.text
	end

	return dict
end

local function json_escape(s)
    if type(s) ~= "string" then return tostring(s) end
    local res = s
    res = res:gsub("\\", "\\\\")
    res = res:gsub("\"", "\\\"")
    res = res:gsub("\n", "\\n")
    res = res:gsub("\r", "\\r")
    res = res:gsub("\t", "\\t")
    return res
end

-- 1. 获取字典
local dict_en = get_translations("En_Us")
local dict_cn = get_translations("Zh_Cn")

-- 2. 将所有 ID 提取到一个数组中
local sorted_ids = {}
for id, _ in pairs(dict_en) do
    table.insert(sorted_ids, id)
end

-- 3. 对 ID 数组进行升序排序
table.sort(sorted_ids)

-- 4. 按排序后的 ID 顺序构建数组格式
local output_array = {}

for _, id in ipairs(sorted_ids) do
    local text_en = dict_en[id]
    local item = "  {\n"
    item = item .. '    "id": ' .. tostring(id) .. ',\n'
    item = item .. '    "en": "' .. json_escape(text_en) .. '"'
    
    local text_cn = dict_cn[id]
    if text_cn and text_cn ~= "" then
        item = item .. ',\n    "cn": "' .. json_escape(text_cn) .. '"\n'
    else
        item = item .. "\n"
    end
    
    item = item .. "  }"
    table.insert(output_array, item)
end

local final_json = "[\n" .. table.concat(output_array, ",\n") .. "\n]"

io.export("localizations.json", final_json)

print("[Localization Export] 已导出" .. #output_array .. "条记录。")