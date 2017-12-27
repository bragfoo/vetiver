local idURL = "http://172.17.106.161:12580/"

local parse= require "parse"
local http = require "resty.http"

local httpc = http.new()
local res, err = httpc:request_uri(idURL)
local newTaskid = res.body

ngx.update_time()
local timestamp = ngx.now() * 1000

local userid = ngx.req.get_headers()["userid"]

local uri = ngx.var.request_uri
parse.parse(uri)

local reqType = parse.getType()

local resourceid = parse.getResourceId()

local process = parse.getProcess()

if parse.needNewTaskId()
then
    ngx.header["taskid"] = newTaskid
    taskid = newTaskid
else
    taskid = ngx.req.get_headers()["taskid"]
end

if (reqType ~= 'block' )
then
    ngx.log(ngx.ERR, "timestamp:", timestamp, " taskid:", taskid, " userid:", userid, " type:", reqType, " resourceid:", resourceid, " process:", process, " uri:", uri)
end
