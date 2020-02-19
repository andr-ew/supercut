-- linked

-- 2x stereo delay
-- version 1.0.0 @andrew
-- https://llllllll.co/t/supercut

-- e1: voice 2 rate
-- e2: voice 2 start
-- e3: voice 2 length
-- k2: link
-- k3: voice 2 reverse

include "supercut/lib/supercut"

function init()
  
  -- initial settings
  supercut.buffer_clear()
  
  audio.level_adc_cut(1)
  
  supercut.init(1, "stereo")
  supercut.init(2, "stereo")
  
  for i = 1,2 do
    supercut.play(i, 1)
    supercut.rec(i, 1)
    supercut.pre_level(i, 0.5)
    supercut.rate_slew_time(i, 0.2)
    supercut.phase_quant(i, 0.01)
    supercut.level_slew_time(i, 0.1)
    supercut.fade_time(i, 0.01)
  end
  
  -- establish home regions, regions, and loops
  
  supercut.home_region_length(1, 0.4)
  supercut.region_length(1, 0.4)
  supercut.loop_length(1, 0.4)
  
  supercut.home_region_length(2, 0.4)
  supercut.region_length(2, 0.4)
  supercut.loop_length(2, 0.25)
  
  supercut.rate(2, 0.5)
  
  redraw()
end

linked = false

function key(n, z)
  if z == 1 then
    if n == 2 then
      if linked == false then ------------------- link
        linked = true
        
        supercut.rec(2, 0)
        supercut.steal_voice_home_region(2, 1)
      elseif linked == true then ---------------- unlink
        linked = false
        
        supercut.rec(2, 1)
        supercut.steal_voice_home_region(2, 2)
      end
    elseif n == 3 then
      supercut.rate(2, supercut.rate(2) * -1) --------- reverse
    end
  end
end

function enc(n, delta)
  if n == 1 then
    if delta > 0 then supercut.rate(2, supercut.rate(2) * 2) ---------- double speed
    elseif delta < 0 then supercut.rate(2, supercut.rate(2) * 0.5) --------- half speed
    end
  elseif n == 2 then
    supercut.loop_start(2, supercut.loop_start(2) + delta * 0.001) ----- move loop window
    supercut.loop_end(2, supercut.loop_end(2) + delta * 0.001)
  elseif n == 3 then
    supercut.loop_length(2, supercut.loop_length(2) + delta * 0.001) ----- change loop length
  end
end

function redraw()
  screen.clear()
  
  local top = 32
  
  for i = 1,2 do
    local left = 2 + (i-1) * 58
    local width = 22
    
    screen.level(2)
    screen.pixel(left + width * supercut.loop_start(i) / supercut.region_length(i), top) --loop start
    screen.fill()
    screen.pixel(left + width * supercut.loop_end(i) / supercut.region_length(i), top) --loop end
    screen.fill()
    screen.level(16)
    screen.pixel(left + (width + 1) * supercut.region_position(i) / supercut.region_length(i), top) -- loop point
    screen.fill()
    
    if linked then -- link indicator
      screen.level(16)
      screen.pixel(40, 34)
      screen.fill()
    end
  end
  
  screen.level(12)
  screen.pixel(102, top - math.abs(supercut.rate(2))) -- rate
  screen.fill()
  
  screen.update()
end

re = metro.init(function() redraw() end,  0.01)
re:start()