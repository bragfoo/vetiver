local parse   = {}
local urlType = {
    "other",    -- 1
    "block",    -- 2
    "home",     -- 3
    "article",  -- 4
    "video",    -- 5
    "category", -- 6
    "message",  -- 7
    "user",     -- 8
    "comment",  -- 9
    "action"    -- 10
}
local newTaskIdType = {"home", "category", "message"}
local actType = {"open", "comments", "like", "follow"}

local reqType = nil
local resourceId = nil
local process = nil

-- DFA --
local stat = 1
local apat = 2
local stats = {"/", "?", "&"}
local resDFA = {
    "@", "start",
    {"/",  "api",
        {"/", "monitor",          {"res", {urlType[2], actType[1]}}},
        {"/", "home_center",      {"res", {urlType[3], actType[1]}}},
        {"/", "message",          {"res", {urlType[7], actType[1]}}},
        {"/", "message_parse",    {"res", {urlType[7], actType[1]}}},
        {"/", "home",
            {"/", "banners",      {"res", {urlType[3], actType[1]}}},
            {"/", "bannerClick",  {"res", {urlType[3], actType[1]}}},
            {"/", "latest",       {"res", {urlType[3], actType[1]}}},
            {"/", "navs",
                {"/", "{}",       {"res", {urlType[6], actType[1]}}},
                {"res", {urlType[6], actType[1]}}
            }
        },
        {"/", "items",
            {"/", "{}",
                {"/", "comments",     {"res", {urlType[9], actType[1]}}},
                {"/", "videos",       {"res", {urlType[2], actType[1]}}},
                {"?", "format=video", {"res", {urlType[5], actType[1]}}},
                {"res", {urlType[4], actType[1]}}
            }
        },
        {"/", "users",
            {"/", "center",     {"res", {urlType[1], actType[1]}}},
            {"/", "{}",
                {"/", "follows",
                    {"/", "users",  {"res", {urlType[8], actType[1]}}},
                    {"/", "users",
                        {"/", "{}", {"res", urlType[8], actType[1]}}
                    },
                    {"res", {urlType[6], actType[1]}},
                },
                {"/", "fans",  {"res", {urlType[6], actType[1]}}}
            }
        }
    },
    {"/",  "action",
        {"/", "getaction",   {"res", {urlType[10], actType[1]}}}
    },
    {"res", {urlType[1], actType[1]}}
}

function getWord(uri)
    len = 4096
    for k,v in ipairs(stats) do
       l = string.find(uri, v, 2)
       if ( l ~= nil )
       then
           len = l
           break
       end
    end
    if ( len == 4096 )
    then
        len = uri:len() + 1
    end
    return uri:sub(2, len - 1)
end

function parseUri(dfa, uri)
    if ( dfa[stat] == "res" )
    then
        return dfa[apat]
    end
    if ( string.find(uri, dfa[stat]) == 1 )
    then
        word = getWord(uri)
        uri = uri:sub(word:len() + 2)
        if "{}" == dfa[apat]
        then
            resourceId = word
        end
        if word == dfa[apat] or "{}" == dfa[apat]
        then
            for k,v in ipairs(dfa) do
                if ( k > 2 )
                then
                    res = parseUri(v, uri)
                    if ( 0 ~= res )
                    then
                        return res
                    end
                end
            end
        end
    end
    return 0
end

function parse.parse(uri)
    reqType = nil
    resourceId = nil
    process = nil
    uri = string.lower(uri)
    res = parseUri(resDFA, "@start"..uri)
    if ( 0 == res )
    then
        reqType = urlType[1]
    else
        -- ngx.log(ngx.ERR, "==== res:", res[1])
        reqType = res[1]
        process = res[2]
    end
end

function parse.getType()
    return reqType
end

function parse.getResourceId()
    if ( resourceId == nil )
    then
        return "other"
    end
    return resourceId
end

function parse.getProcess()
    if ( process == nil )
    then
        return "other"
    end
    return process
end

function parse.needNewTaskId()
    for k,v in ipairs(newTaskIdType) do
        if ( v == reqType )
        then
            return true
        end
    end
    return false
end

return parse