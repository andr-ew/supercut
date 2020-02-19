# guide

supercut is a wrapper utility for softcut which is particularly useful for managing common inter-voice relationships and statuses. commands are issued to supercut much the same as with softcut:

`supercut.play(1, 1)`

the difference here is that voices are abstracted into 3-6 **supervoices** which include:
- mono or stereo i/o
- state recall
- buffer region management

to start using a supervoice, run

`supercut.init(1, "mono")`

or, for stereo, run

`supercut.init(1, "stereo")`

init() takes care of initializing most of the values needed to start things moving, though you can roll without it. just check the source if yr curious about what's going on

for voice count, note that the norns limitations still apply, so a max of 6 mono voices or 3 stereo voices. any combo of those is also fine (2 stereo + 2 mono)

in supercut, every setter is also a getter:

`print(supercut.play(1))`

this makes some actions super simple while keeping data centrilized

to transpose by an octave:
`supercut.rate(1, supercut.rate(1) * 2)`

to toggle recording:
`supercut.rec(1, (supercut.rec(1) == 1) and 0 or 1)`

in the REPL at the bottom, calling `supercut.status(1)` will yield immediate insight into the full status of a supervoice. some of these will look familiar from [softcut docs](http://norns.local/doc/modules/softcut.html) but a few are new. the biggest additions afford some handy buffer management options.

there are 3 levels of specificity: `loop`, `region`, and `home_region`. within each supervoice, `loop_start` and `loop_end` begin at 0 and are bound to `region`. `regions` default to a ~116 second sections of softcut's 2 buffers. by default these regions inhabit seperate territories, but an interesting way to interrupt this is stealing the region of another supervoice:

`supercut.region_start(1, supercut.region_start(2))`
`supercut.region_end(1, supercut.region_end(2))`
`supercut.buffer(1, supercut.buffer(2))`

there's even a helper funtion for this:

`supercut.steal_voice_region(1, 2)`

now you can, for example, record to a region at rate = 1 and play back at rate = 2 for a live pitch shift effect

but how do we go back ? that's what `home_region` is for. just run this:

`supercut.steal_home_region(1, 1)`

in addition to `position`, supercut also adds `loop_position`, `region_position`, and `home_region_position` to track tapeheads in each relative sector. they're also updated automatically at the `phase_quant` time.

for a complete, interactive example, check out `demo/linked` from the video above !
