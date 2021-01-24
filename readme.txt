text2vol4, replaces text2data for famitone2
doug fraker, ver 4.2021, unofficial update, nesdoug.com


additions so far:
	-volume column support
	-full note range
	-1xx,2xx,4xx effects
	
version4.1:
	-added command line switch -allin to prevent removing unused instruments
	-added command line switch -Wno to ignore warnings about unsupported effects
	-fixed bug, multiple D00 effects (different channels) incorrect pattern length
	-fixed bug, Bxx below D00 effect (different channels) incorrect pattern length
	-fixed bug, Bxx loop back causing wrong instrument inserted at loop point
example of new switches:
text2vol4 filename.txt -ca65 -allin -Wno	

usage notes:
	-use the "v1.15 by Shiru 04'17" version of nsf2data (included) for sound effects.
	-must use with famitone4 asm files
	-should use with famitracker 0.4.6 (or later) text export
	-use volume column for Square 1, Square 2, and Noise Channels
	-at the start of a song, the volume column is assumed to be 'f'
	-if you loop backwards, use a volume column entry for the first note at the loop point, or else it will carry over whatever volume is still loaded
Example - at the start of the loop, you fail to put a volume column entry, but at the end of the loop, you fade out to zero. When it loops backwards, the volume will still be set to zero.
	-use any note for Square 1 + 2, Triangle, or Noise Channel
	-restrict DPCM to C-1 to D-6
	-pal support fixed.


added features:
	-use the command line -allin to ensure all instruments are output, even if no song uses it. this may come in handy if you have too many songs and need to split the famitracker file into 2 parts.
	-the song titles will appear in comments in the asm data. This may come in handy if you need to cut or move 1 song for space reasons.

***new with version 4 - support for 1xx,2xx,4xx effects. They apply to the Square and Triangle channels. Use 100 or 200 to disable the pitch bend. Use 400 to disable to vibrato. The vibrato speed (4xy where x is speed) is permanently set to 6. I recommend that you write all the vibrato effects like 461 462 463, etc. "a" (like 46a) is the maximum depth. 

You can put a 1xx(2xx) and 4xx effect at the same time on a note, but not on the same line...only 1 fx column is allowed(per channel), so 1xx(2xx) on the first line and 4xx on the line below that.

It's not perfectly the same as famitracker. You might have to make slight adjustments to get it to do what you want.
	
	
comparison:
	-a level of efficiency has been removed to make room for more elements
	-even without volume column, file sizes could be 110-125% of what they would have been in the official famitone2
	-every volume column entry will add another byte
	-every fx change will add another byte
	
	
other notes:
	-i've marked all changes with ** or *** in the files and in the source code
	-i have not modified the licence, which states...
	

	
The library is open source and released into the Public Domain. You can 
use it for any purpose without restrictions: redistribute, modify, use 
for commercial and non-commercial projects. You may credit the author, 
inform the author about your project, donate, etc, but nothing is 
obligatory, you could do it at free will. Obviously, the library 
provided AS IS without warranties of any kind, the author is not 
responsible for anything.

	-Shiru wrote the original famitone2 library
	
	







Troubleshooting

My song is silent? Possible reasons...

-you are calling a song # too high. The first song is 0, not 1
LDA #song_number before calling FamiToneMusicPlay

-you forgot to initialize the music code, make sure you 
send the correct address of the music data to the init code
LDX #<music_data ;low
LDY #>music_data ;high
LDA #1 ;NTSC = 1, PAL = 0
JSR FamiToneInit

-you forgot to call FamiToneUpdate once per frame



Sound Fx aren't working? Possible reasons...

-you are calling a sfx # too high. The first sfx is 0, not 1

-you are calling a sfx channel too high
FT_SFX_STREAMS	= 1 means that x should be #0 when calling a sfx
LDX #channel, LDA #which_sfx, JSR FamiToneSfxPlay

-forgot to turn on sfx... FT_SFX_ENABLE shouldn't be commented out

-forgot to initialize sfx, you need to send a pointer to the sfx data 
LDX #<sfx_data ;low
LDY #>sfx_data ;high
JSR FamiToneSfxInit

-using the old nsf2data (earlier than v1.15) which has a different
header system to the data.



famitone comparison (2021)
-------------------
ROM size
famitracker  5743
famitone2    1478-1645
famitone3    1886-2104
famitone4    2381-2603
famitone5    2975-3197
*smaller size if only NTSC or only PAL
 larger if both, because of the note tables
** sizes are about 250 bytes bigger than the previous
 versions because of the volume table added, as some
 musicians requested an exact copy of famitracker.
 It should save some CPU time, since it no longer
 has to multiply volumes on the fly.

Song size
famitracker 4752  131%
famitone2   3624  100%
famitone3   4859  134%
famitone4   4859  134%
famitone5   4866  134%

CPU Time (estimated)
famitracker 3000  167%
famitone2   1800  100%
famitone3   2000  111%
famitone4   2300  128%
famitone5   2500  139%

Features
famitracker = all effects
famitone2 = Bxx,Fxx,D00 no duty envelopes, no volume column, reduced note range
famitone3 + all notes, volume column
famitone4 + 1xx,2xx,4xx
famitone5 + 3xx,Rxx,Qxx, duty envelopes, sfx > 256 bytes

