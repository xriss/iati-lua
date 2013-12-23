local socket=require("socket")
local http=require("socket.http")

local sxml=require("wetgenes.simpxml")
local json=require("wetgenes.json")
local wstr=require("wetgenes.string")

local ox=require("posix")

local readfile=function(name)
	local fp=io.open(name,"r")
	if fp then
		local body=fp:read("*a")
		fp:close()
		return body
	end
end

local names=json.decode(readfile("cache/index.json"))

print(#names,"files to parse")

local total=0
local start=0

local args={...}

start=tonumber(args[1] or 0 ) or 0

for i,name in ipairs(names) do
local pct=math.floor(100*i/#names)
if pct>=start then
print(pct.."%",name)

local baseurl="http://127.0.0.1:5000/api/1/access/activity.xml?registry-dataset="
local baseurl="http://iati-datastore.herokuapp.com/api/1/access/activity.xml?registry-dataset="
	local body, headers, code = socket.http.request(baseurl..name)
	if body then
--		local xml=sxml.parse(body)
--		local base=sxml.child(xml,"result")
--		local base=sxml.child(xml,"iati-activities")
print(wstr.dump(xml))
--		print(base)

os.exit()
	end
end
end


