-- this is sync code 
-- This function executes a Lua script file from a website.
-- @param url: The URL of the Lua script file.
-- @return: Returns true if the script was executed successfully, false otherwise.
function executeScriptFromWebsite(url)
    -- Check if the LuaSocket library is available
    local hasLuaSocket, socket = pcall(require, "socket")
    if not hasLuaSocket then
        print("LuaSocket library is required to execute scripts from a website.")
        return false
    end

    -- Create a TCP socket connection to the website
    local connection = socket.tcp()
    connection:settimeout(10) -- Set a timeout of 10 seconds

    local success, errorMessage = connection:connect(url, 80)
    if not success then
        print("Failed to connect to the website:", errorMessage)
        return false
    end

    -- Send an HTTP GET request to retrieve the Lua script file
    local request = "GET " .. url .. " HTTP/1.1\r\n" ..
                    "Host: " .. url .. "\r\n" ..
                    "Connection: close\r\n\r\n"

    local bytesSent, sendError = connection:send(request)
    if not bytesSent then
        print("Failed to send the HTTP request:", sendError)
        return false
    end

    -- Read the response from the website
    local response = ""
    while true do
        local data, receiveError, partialData = connection:receive()
        if not data then
            if receiveError ~= "timeout" then
                print("Failed to receive data from the website:", receiveError)
                return false
            end
            break
        end
        response = response .. data
        if partialData == "" then
            break
        end
    end

    -- Close the connection
    connection:close()

    -- Execute the Lua script
    local success, scriptError = pcall(loadstring(response))
    if not success then
        print("Failed to execute the Lua script:", scriptError)
        return false
    end

    return true
end

-- Example usage of the executeScriptFromWebsite function

-- Usage Example 1: Execute a Lua script file from a website
local url = "http://www.example.com/script.lua"
local success = executeScriptFromWebsite(url)
if success then
    print("Script executed successfully.")
else
    print("Failed to execute the script.")
end
