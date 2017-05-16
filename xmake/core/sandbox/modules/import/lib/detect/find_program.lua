--!The Make-like Build Utility based on Lua
--
-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- 
-- Copyright (C) 2015 - 2017, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        find_program.lua
--

-- define module
local sandbox_lib_detect_find_program = sandbox_lib_detect_find_program or {}

-- load modules
local os        = require("base/os")
local path      = require("base/path")
local table     = require("base/table")
local utils     = require("base/utils")
local option    = require("base/option")
local sandbox   = require("sandbox/sandbox")
local raise     = require("sandbox/modules/raise")

-- the cache info
local cacheinfo = cacheinfo or {}

-- check program
function sandbox_lib_detect_find_program._check(program, check)

    -- no check script? attempt to run it directly
    if not check then
        return 0 == os.exec(shellname, xmake._NULDEV, xmake._NULDEV)
    end

    -- check it
    local ok, errors = sandbox.load(check, program) 
    if not ok then
        utils.verror(errors)
    end

    -- ok?
    return ok
end

-- find program
function sandbox_lib_detect_find_program._find(name, dirs, check)

    -- attempt to check it directly in current environment 
    if sandbox_lib_detect_find_program._check(name, check) then
        return name
    end

    -- attempt to check it from the given directories
    if not path.is_absolute(name) then
        for _, dir in ipairs(table.wrap(dirs)) do

            -- TODO
            -- dir is registry path?

            -- the program path
            local program_path = path.join(dir, name)
            if os.isexec(program_path) then
            
                -- check it
                if sandbox_lib_detect_find_program._check(program_path, check) then
                    return program_path
                end
            end
        end
    end
end

-- find program
--
-- @param name  the program name
-- @param dirs  the program directories
-- @param check the check script 
--
-- @return      the program name or path
--
function sandbox_lib_detect_find_program.main(name, dirs, check)
 
    -- attempt to get result from cache first
    local result = cacheinfo[name]
    if result then
        return result
    end

    -- find executable program
    result = sandbox_lib_detect_find_program._find(name, dirs, check) 

    -- cache result
    if result then
        cacheinfo[name] = result
    end

    -- trace
    if option.get("verbose") then
        if result then
            utils.cprint("checking for the %s ... ${green}%s", name, result)
        else
            utils.cprint("checking for the %s ... ${red}no", name)
        end
    end

    -- ok?
    return result
end

-- return module
return sandbox_lib_detect_find_program