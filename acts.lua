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
	
	local body=readfile("cache/"..name..".xml")
	if body then
		local xml=sxml.parse(body)
--print(wstr.dump(xml))
		if xml then
			local base=sxml.child(xml,"iati-activities")
			if base then
				local childs=sxml.childs(base,"iati-activity")		
				if childs then
					total=total+#childs
print("","","",#childs,total)
				end
			end
		end
--os.exit()
--		break
	end
end
end


