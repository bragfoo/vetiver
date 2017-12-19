local http = require "resty.http"
local httpc = http.new()
local res, err = httpc:request_uri("http://39.106.120.181:12580/")
local taskid = res.body

local timestamp = os.time()

local userid = ngx.req.get_headers()["userid"]

local reqType = "type"

local uri = ngx.var.request_uri

local process = "process"

-- ngx.header["timestamp"] = timestamp
ngx.header["taskid"] = taskid
-- ngx.header["userid"] = userid
-- ngx.header["type"] = reqType
-- ngx.header["uri"] = uri
-- ngx.header["process"] = process

ngx.log(ngx.INFO, "timestamp:", timestamp, " taskid:", taskid, " userid:", userid, " type:", reqType, " uri:", uri, " process:", process)

