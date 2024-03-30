local fplus = {}
local l = require("localevent")
local function fplus:ChatMessageInfo(func)
    l.name(l.Name.ChatMessage, function(info)
    	if type(func) == "function" then
            func(info)
        end
   	 end)
    end

local function fplus:KeyPressed(key, statement, func)
    local inputCodes = {
        NONE = 0,
        ESC = 1,
        RETURN = 2,
        NUMPAD_RETURN = 3,
        TAB = 4,
        BACKSPACE = 5, -- backward delete
        UP = 6,
        DOWN = 7,
        LEFT = 8,
        RIGHT = 9,
        INSERT = 10,
        DELETE = 11, -- forward delete
        HOME = 12,
        END = 13,
        PAGE_UP = 14,
        PAGE_DOWN = 15,
        PRINT = 16,
        CLEAR = 17,
        F1 = 18,
        F2 = 19,
        F3 = 20,
        F4 = 21,
        F5 = 22,
        F6 = 23,
        F7 = 24,
        F8 = 25,
        F9 = 26,
        F10 = 27,
        F11 = 28,
        F12 = 29,
        F13 = 30,
        F14 = 31,
        F15 = 32,
        F16 = 33,
        F17 = 34,
        F18 = 35,
        F19 = 36,
        F20 = 37,
        GAMEPAD_A = 38,
        GAMEPAD_B = 39,
        GAMEPAD_X = 40,
        GAMEPAD_Y = 41,
        GAMEPAD_THUMB_L = 42,
        GAMEPAD_THUMB_R = 43,
        GAMEPAD_SHOULDER_L = 44,
        GAMEPAD_SHOULDER_R = 45,
        GAMEPAD_UP = 46,
        GAMEPAD_DOWN = 47,
        GAMEPAD_LEFT = 48,
        GAMEPAD_RIGHT = 49,
        GAMEPAD_SHOULDER_BACK = 50,
        GAMEPAD_SHOULDER_START = 51,
        GAMEPAD_SHOULDER_GUIDE = 52,
        PLUS = 53,
        NUMPAD_PLUS = 54,
        MINUS = 55,
        NUMPAD_MINUS = 56,
        DIVIDE = 57,
        MULTIPLY = 58,
        DECIMAL = 59,
        EQUAL = 60,
        NUMPAD_EQUAL = 61,
        LEFT_BRACKET = 62,
        RIGHT_BRACKET = 63,
        SEMICOLON = 64,
        QUOTE = 65,
        COMMA = 66,
        PERIOD = 67,
        SLASH = 68,
        BACKSLASH = 69,
        TILDE = 70,
        NUMPAD_0 = 71,
        NUMPAD_1 = 72,
        NUMPAD_2 = 73,
        NUMPAD_3 = 74,
        NUMPAD_4 = 75,
        NUMPAD_5 = 76,
        NUMPAD_6 = 77,
        NUMPAD_7 = 78,
        NUMPAD_8 = 79,
        NUMPAD_9 = 80,
        KEY_0 = 81,
        KEY_1 = 82,
        KEY_2 = 83,
        KEY_3 = 84,
        KEY_4 = 85,
        KEY_5 = 86,
        KEY_6 = 87,
        KEY_7 = 88,
        KEY_8 = 89,
        KEY_9 = 90,
        KEY_A = 91,
        KEY_B = 92,
        KEY_C = 93,
        KEY_D = 94,
        KEY_E = 95,
        KEY_F = 96,
        KEY_G = 97,
        KEY_H = 98,
        KEY_I = 99,
        KEY_J = 100,
        KEY_K = 101,
        KEY_L = 102,
        KEY_M = 103,
        KEY_N = 104,
        KEY_O = 105,
        KEY_P = 106,
        KEY_Q = 107,
        KEY_R = 108,
        KEY_S = 109,
        KEY_T = 110,
        KEY_U = 111,
        KEY_V = 112,
        KEY_W = 113,
        KEY_X = 114,
        KEY_Y = 115,
        KEY_Z = 116,
        SPACE = 117,
        modifiers = {
            Option = 1,
            Alt = 1, --Same as options, for windows coders
            Ctrl = 2,
            Shift = 4,
            Cmd = 8,
        },
    }
    
    l.name(l.Name.KeyboardInput, function(char, keyCode, modifiers, down)
    	if keyCode == inputKey.[key] and down == true then 
    		func()
    	end
   	 end)
end
local function fplus.newton_sqrt_2( precision=1e-7 )
    local precision = precision or 1e-7
    local x = 1.0
    while True do
        local next_x = 0.5 * ( x + 2 / x)
        if math.abs( next_x - x ) < precision then
            return next_x
        end
        x = next_x
    end
end

local function fplus.pluralize(n, str)
    if n == 1 then
        return "1 " .. str
    else
        return tostring(n) .. " " .. str .. "s"
    end
end

local function fplus.formatBytes(bytes)
    if bytes < 1024 then
        return pluralize(bytes, "byte")
    elseif bytes < 1024^2 then
        return string.format("%.2f KB", bytes / 1024)
    elseif bytes < 1024^3 then
        return string.format("%.2f MB", bytes / 1024^2)
    elseif bytes < 1024^4 then
        return string.format("%.2f GB", bytes / 1024^3)
    else
        return string.format("%.2f TB", bytes / 1024^4)
    end
end

local function fplus.commandPrefix()
    return "go "
end

local function fplus.run_code(code, env)
    if env == nil then
        env = _ENV
    end

    local exec, error = pcall(function()
        local func = load(code, nil, "bt", env)
        func()
    end)

    return { exec, error }
end

local function fplus.max(a, b)
    if a < b then
        return a
    else
        return b
    end
end

function fplus.newCounter()
local count = 0
    return function()
      count = count + 1
      return count
    end
  end

local function fplus.min(a, b)
    if a > b then
        return a
    else
        return b
    end
end

local function fplus.clamp(a, min, max)
    return math.max(min, math.min(a, max))
end

local function fplus.lerp(a, b, w)
    return a + ((b - a) * w)
end

local function fplus.lerpColor(a, b, w)
    return Color(lerp(a.R, b.R, w), lerp(a.G, b.G, w), lerp(a.B, b.B, w))
end

local function fplus.angleLerp(a, b, w)
    cs = (1 - w) * math.cos(a) + w * math.cos(b)
    sn = (1 - w) * math.sin(a) + w * math.sin(b)
    return math.atan(sn, cs)
end

local function fplus.abs (a)
    if a > 0 then
        return a
    end
    if a < 0 then
        return a * -1
    end
    return a
end

--Round function (1.5 = 2, 1.4 = 1)
local function fplus.round(a)
    return math.floor(a + 0.5)
end

--Get random element from table
local function fplus.table_random(t)
    return t[math.random(1, #t)]
end

--Remove element from table BY VALUE
local function fplus.table_remove(t, element, first_only)
    if first_only == nil then
        first_only = true
    end
    for i = #t, 1, -1 do
        if t[i] == element then
            table.remove(t, i)
            if first_only == true then
                return
            end
        end
    end
end

--Search value in table by value (element first index or nil)
local function fplus.table_search(t, value)
    for i = 1, #t do
        if t[i] == value then
            return i
        end
    end
end

--Search value in table by value (All element indexes in table or empty table)
local function fplus.table_search_ext(t, value)
    local indexes = {}
    for i = 1, #t do
        if t[i] == value then
            table.insert(indexes, i)
        end
    end
    return indexes
end

--Get number of exact values in table
local function fplus.table_numberof(t, value)
    local n = 0
    for i = 1, #t do
        if t[i] == value then
            n = n + 1
        end
    end
    return n
end

--boolean to 0, 1 (if not bool then 1)
local function fplus.bool_to_num(bool)
    if bool == nil then
        return 0
    end
    if bool == true then
        return 1
    end
    if bool == false then
        return 0
    else
        return 1
    end
end

--Distance in 2D
local function fplus.distance2(x1, y1, x2, y2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

--Distance in 3D
local function fplus.distance3(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2))
end

--Alternative with Number3`s
local function fplus.distance(pos1, pos2)
    return math.sqrt(
        (pos1.X - pos2.X) * (pos1.X - pos2.X)
            + (pos1.Y - pos2.Y) * (pos1.Y - pos2.Y)
            + (pos1.Z - pos2.Z) * (pos1.Z - pos2.Z)
    )
end
local function fplus.atan_deg(y, x)
    return (math.deg(math.atan(y, x)))
    end
    
local function fplus.hypotenuse(x, y)
    return (math.sqrt(x^2 + y^2))
    end
return fplus