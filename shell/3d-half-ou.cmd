@echo off
set mplayer=C:\Portable\mplayer
rem arcg anaglyph_red_cyan_gray 
rem arch anaglyph_red_cyan_half_color 
rem arcc anaglyph_red_cyan_color 
rem arcd anaglyph_red_cyan_dubois 
rem agmg anaglyph_green_magenta_gray 
rem agmh anaglyph_green_magenta_half_color
rem agmc anaglyph_green_magenta_color 
rem agmd anaglyph_green_magenta_dubois 
rem aybg anaglyph_yellow_blue_gray 
rem aybh anaglyph_yellow_blue_half_color 
rem aybc anaglyph_yellow_blue_color 
rem aybd anaglyph_yellow_blue_dubois 
rem ml mono_left 
rme mr mono_right 
rem sbsl side_by_side_left_first 
rem sbsr side_by_side_right_first 
rem sbs2l side_by_side_half_width_left_first 
rem sbs2r side_by_side_half_width_right_first 
rem abl above_below_left_first 
rem abr above_below_right_first 
rem ab2l above_below_half_height_left_first 
rem ab2r above_below_half_height_right_first 
rem irl interleave_rows_left_first 
rem irr interleave_rows_right_first
set stereo_in=ab2l
set stereo_out=ml
"%mplayer%\mplayer\mplayer.exe" -vf stereo3d=%stereo_in%:%stereo_out% -fs "%~s1"
