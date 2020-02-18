-- linked

-- 2x stereo ping-pong delay
-- version 1.0.0 @andrew
-- https://llllllll.co/t/supercut

-- e1: voice 1 loop start
-- e2: voice 1 rate
-- e3: voice 2 rate
-- k2: voice 1 reverse
-- k3: share

include "lib/supercut"

function init()
  
  -- supercut (softcut) initial settings
  supercut.buffer_clear()
  
  audio.level_adc_cut(1)
  
  supercut.init(1, "stereo")
  supercut.init(2, "stereo")
  
  supercut.level_input_cut(2, i, 1.0, 2)
  
  for i = 1,2 do
    supercut.play(i, 1)
    supercut.pre_level(i, 0.0)
    supercut.rate_slew_time(i, 0.2)
    supercut.rec_level(i, 0.5)
    supercut.phase_quant(i, 0.05)
    supercut.level_slew_time(i, 0.1)
    supercut.home_region_length(i, 5)
  end
  
  redraw()
end