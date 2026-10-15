Palette = {
  [1] = 0x0000,
  [2] = 0x1884,
  [3] = 0x1CA8,
  [4] = 0x18EC,
  [5] = 0x1D51,
  [6] = 0x11DB,
  [7] = 0x329B,
  [8] = 0x4F1D,
  [9] = 0x1BDF,
  [10] = 0x2B93,
  [11] = 0x1AED,
  [12] = 0x3646,
  [13] = 0x15A9,
  [14] = 0x112A,
  [15] = 0x1CE6,
  [16] = 0x38E7,
  [17] = 0x4186,
  [18] = 0x71AB,
  [19] = 0x7E6C,
  [20] = 0x732B,
  [21] = 0x7F79,
  [22] = 0x7FFF,
  [23] = 0x5AB3,
  [24] = 0x41F0,
  [25] = 0x35AD,
  [26] = 0x294B,
  [27] = 0x450E,
  [28] = 0x18D5,
  [29] = 0x315B,
  [30] = 0x5DFA,
  [31] = 0x2651,
  [32] = 0x19B1,
  [33] = 0x0000,
}

local parsed_colors = {}
local rgb_cache = {}
local hex_cache = {}

for i = 1, #Palette do
  local val = Palette[i]
  local b5 = math.floor(val / 1024) % 32
  local g5 = math.floor(val / 32) % 32
  local r5 = val % 32
  parsed_colors[i] = {
    r = r5 * 8 + math.floor(r5 / 4),
    g = g5 * 8 + math.floor(g5 / 4),
    b = b5 * 8 + math.floor(b5 / 4)
  }
end

function Palette.rgb(r, g, b)
  local cache_key = r * 65536 + g * 256 + b
  local cached = rgb_cache[cache_key]
  if cached then
    return cached
  end

  local min_dist = 99999999
  local best_idx = 1

  for i = 1, #parsed_colors do
    local c = parsed_colors[i]
    local dr = c.r - r
    local dg = c.g - g
    local db = c.b - b
    local dist = dr * dr + dg * dg + db * db
    if dist < min_dist then
      min_dist = dist
      best_idx = i
    end
  end

  local result_idx = best_idx - 1
  rgb_cache[cache_key] = result_idx
  return result_idx
end

function Palette.hex(h)
  local cached = hex_cache[h]
  if cached then
    return cached
  end

  local r, g, b
  if type(h) == "number" then
    r = math.floor(h / 65536) % 256
    g = math.floor(h / 256) % 256
    b = h % 256
  elseif type(h) == "string" then
    local clean = h:gsub("^#", ""):gsub("^0[xX]", "")
    local val = tonumber(clean, 16)
    if val then
      r = math.floor(val / 65536) % 256
      g = math.floor(val / 256) % 256
      b = val % 256
    end
  end

  if r and g and b then
    local idx = Palette.rgb(r, g, b)
    hex_cache[h] = idx
    return idx
  end

  return 0
end

return Palette
