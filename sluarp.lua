local socket=require("socket")
local http=require("socket.http")

local sxml=require("wetgenes.simpxml")
local json=require("wetgenes.json")
local wstr=require("wetgenes.string")

local ox=require("posix")

local baseurl="http://iatiregistry.org/api/rest/package"

print("STARTING sluarp")

local body, headers, code = socket.http.request(baseurl)
print("Received "..#body.." bytes\n")

local names=json.decode(body)

print(#names,"files to grab")

do local fp=io.open("cache/index.json","wb") fp:write(body) fp:close() end

for i,name in ipairs(names) do
local pct=math.floor(100*i/#names)

local lock=ox.open("cache/"..name..".lock", ox.O_RDWR + ox.O_CREAT + ox.O_EXCL , "777" )
if lock then
--print(pct,"LOCK",name)
	
	-- already got something?
	local skip=false
	local fp=io.open("cache/"..name..".json","r")
	if fp then
		fp:close()
		local fp=io.open("cache/"..name..".xml","r")
		if fp then
			fp:close()
			skip=true
		end
	end

	
--if not skip then print(pct,name) end
--skip=true
if not skip then

	local body, headers, code = socket.http.request(baseurl.."/"..name)
	if body then
		print(pct.."%","Received "..name..".json")

		local fp=io.open("cache/"..name..".json","wb")
		fp:write(body)
		fp:close()

		local js=json.decode(body)
		if js and js["download_url"] then
			local xmlurl=js["download_url"]
--			print(pct.."%","Fetching",xmlurl)
			local body, headers, code = socket.http.request(xmlurl)
			if body then
				local fp=io.open("cache/"..name..".xml","wb")
				fp:write(body)
				fp:close()
				print(pct.."%","Received "..name..".xml")
			else
				print(pct.."%","Failed "..name..".xml")
			end
		else
			print(pct.."%","Skipping "..name..".xml")
		end
		
	end

end
ox.close(lock)
os.remove("cache/"..name..".lock")
end

end
print("ENDING sluarp")
