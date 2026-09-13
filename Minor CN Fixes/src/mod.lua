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

local function decode_json(json)
    local position = 1

    local function skip_whitespace()
        while json:sub(position, position):match("%s") do
            position = position + 1
        end
    end

    local function parse_string()
        position = position + 1
        local result = {}
        while position <= #json do
            local character = json:sub(position, position)
            position = position + 1
            if character == '"' then
                return table.concat(result)
            elseif character == "\\" then
                local escaped = json:sub(position, position)
                position = position + 1
                local replacements = {
                    ["n"] = "\n",
                    ["r"] = "\r",
                    ["t"] = "\t",
                    ["b"] = "\b",
                    ["f"] = "\f"
                }
                table.insert(result, replacements[escaped] or escaped)
            else
                table.insert(result, character)
            end
        end
        error("Unterminated JSON string")
    end

    local parse_value
    local function parse_array()
        position = position + 1
        local result = {}
        skip_whitespace()
        if json:sub(position, position) == "]" then
            position = position + 1
            return result
        end
        while true do
            table.insert(result, parse_value())
            skip_whitespace()
            local delimiter = json:sub(position, position)
            position = position + 1
            if delimiter == "]" then
                return result
            end
            if delimiter ~= "," then
                error("Expected ',' or ']' in JSON array")
            end
            skip_whitespace()
        end
    end

    local function parse_object()
        position = position + 1
        local result = {}
        skip_whitespace()
        if json:sub(position, position) == "}" then
            position = position + 1
            return result
        end
        while true do
            if json:sub(position, position) ~= '"' then
                error("Expected JSON object key")
            end
            local key = parse_string()
            skip_whitespace()
            if json:sub(position, position) ~= ":" then
                error("Expected ':' after JSON object key")
            end
            position = position + 1
            result[key] = parse_value()
            skip_whitespace()
            local delimiter = json:sub(position, position)
            position = position + 1
            if delimiter == "}" then
                return result
            end
            if delimiter ~= "," then
                error("Expected ',' or '}' in JSON object")
            end
            skip_whitespace()
        end
    end

    parse_value = function()
        skip_whitespace()
        local character = json:sub(position, position)
        if character == '"' then
            return parse_string()
        end
        if character == "[" then
            return parse_array()
        end
        if character == "{" then
            return parse_object()
        end
        local value = json:match("^-?%d+%.?%d*[eE]?[+-]?%d*", position)
        if value and #value > 0 then
            position = position + #value
            return tonumber(value)
        end
        error("Invalid JSON value at position " .. position)
    end

    local result = parse_value()
    skip_whitespace()
    if position <= #json then
        error("Unexpected content after JSON value")
    end
    return result
end

local function read_json_file(filename)
    local content = io.read_to_string("src/" .. filename)
    return decode_json(tostring(content))
end

local function normalize_id(id)
    if id == nil then
        return nil
    end
    return tostring(id)
end

local mistranslation_tags = {}
for _, entry in ipairs(read_json_file("./tags/mistranslation_tags.json")) do
    if entry.id == nil or entry.cn_fixed == nil then
        error("Invalid mistranslation tag entry")
    end
    mistranslation_tags[normalize_id(entry.id)] = entry.cn_fixed
end

local no_translation_tags = read_json_file("./tags/no_translation_tags.json")

for _, tag in ipairs(data.tags) do
    local tag_id = normalize_id(tag.id.value)
    if mistranslation_tags[tag_id] then
        -- print(string.format("[Minor CN Fixes] Translating tag ID %d: '%s' -> '%s'", tag.id.value, tag.text, mistranslation_tags[tag.id.value]))
        tag.text = mistranslation_tags[tag_id]
    end
end

-- if no_translation_tags has any entries, add them to the tags list
if #no_translation_tags > 0 then
    print(string.format("[Minor CN Fixes] Adding %d new tags to localization data.", #no_translation_tags))
    for _, tag in ipairs(no_translation_tags) do
        local new_tag = {
            id = {
                value = tag.id or tag[1]
            },
            text = tag.text or tag.cn_fixed or tag[2],
            arguments = {},
            genericArguments = 0
        }
        table.insert(data.tags, new_tag)
        -- print(string.format("[Minor CN Fixes] Added new tag %d: '%s'", tag[1], tag[2]))
    end

    table.sort(data.tags, function(a, b)
        return tonumber(a.id.value) < tonumber(b.id.value)
    end)

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
