-- linked

-- 2x stereo ping-pong delay
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
  
  supercut.level_input_cut(1, 1, 1, 1)
  supercut.level_input_cut(2, 1, 1, 1)
  
  supercut.level_input_cut(1, 2, 1, 2)
  supercut.level_input_cut(2, 2, 1, 2)
  
  supercut.level_cut_cut(1, 1, 1, 1, 2)
  supercut.level_cut_cut(1, 1, 1, 2, 1)
  
  supercut.level_cut_cut(2, 2, 1, 1, 2)
  supercut.level_cut_cut(2, 2, 1, 2, 1)
  
  for i = 1,2 do
    supercut.play(i, 1)
    supercut.rec(i, 1)
    supercut.pre_level(i, 0.0)
    supercut.rate_slew_time(i, 0.2)
    supercut.rec_level(i, 0.5)
    supercut.phase_quant(i, 0.01)
    supercut.level_slew_time(i, 0.1)
  end
  
  supercut.home_region_length(1, 0.4)
  supercut.region_length(1, 0.4)
  supercut.loop_length(1, 0.4)
  
  supercut.home_region_length(2, 0.4)
  supercut.region_length(2, 0.4)
  supercut.loop_length(2, 0.25)
  
  supercut.rate(2, 0.5)
  
  redraw()
end

function key()
end

function enc()
end

function redraw()
  screen.clear()
  
  for i = 1,2 do
    
    local left = 2 + (i-1) * 58
    local top = 34
    local width = 22
    
    screen.level(2)
    screen.pixel(left + width * supercut.loop_start(i) / supercut.region_length(i), top) --loop start
    screen.fill()
 
    screen.pixel(left + width * supercut.loop_end(i) / supercut.region_length(i), top) --loop end
    screen.fill()
    
    screen.level(16)
    
    screen.pixel(left + width * supercut.region_position(i) / supercut.region_length(i), top) -- loop point
    screen.fill()
  end
  
  screen.update()
end

re = metro.init(function() redraw() end,  1/60)
re:start()