-- This function checks if the player from a JSON object is the same and prints "ok" if they are the same.
-- @param json: The JSON object containing player information.
-- @param player: The player to compare with the JSON object.
function checkPlayerFromJson(json, player)
    -- Convert the JSON object to a Lua table
    local jsonData = json.decode(json)

    -- Check if the player in the JSON object is the same as the given player
    if jsonData.player == player then
        print("ok")
    end
end
local url = "https://mybestapi.com/api/users"
HTTP:Get(url, function(res)
    if res.StatusCode ~= 200 then
      print("Error " .. res.StatusCode)
      return
    end
    -- body is [{"id": 289733, "name": "Mike", "age": 15}]
    users,err = JSON:Decode(res.Body)
    local user = users[1]
    print(user.id, user.name, user.age)
    -- prints 289734 Mike 15.0
  end)
-- Example usage of the checkPlayerFromJson function

-- JSON object containing player information
local json = '{"player": "John Doe", "score": 100}'

-- Player to compare with the JSON object
local player = "John Doe"

-- Check if the player from the JSON object is the same as the given player
checkPlayerFromJson(json, player)