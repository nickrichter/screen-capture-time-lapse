(*
 * Screen Capture Time-Lapse
 * Version: 1.1
 
 * https://github.com/nickrichter/screen-capture-time-lapse
 *
 * Copyright 2012 Nick Richter
 * Released under the MIT license
 *
 * Date: 2014-04-11
 *)

-- Count the number of displays connected to the user's system
tell application "Image Events"
	launch
	-- Set a variable with the number of connected displays
	set count_displays to count displays
	quit
end tell

if count_displays > 1 then
	set displays_question to display dialog "You have more than one monitor connected. Do you want to capture all monitors, or just the main monitor?" buttons {"Main Monitor Only", "Capture All"} default button 2
	set capture_monitor to button returned of displays_question
	
	(* The capture_monitor variable will be used later, as a flag, in the do shell script command
	If the user selects Main Monitor Only, it will look something like this:
	screencapture -xm
	or
	screencapture -x
	If the user selects Capture All *)
	if capture_monitor = "Main Monitor Only" then
		set capture_monitor to "m"
	else
		set capture_monitor to ""
	end if
else
	set capture_monitor to ""
end if

-- Ask for image capture duration (in seconds)
set capture_interval to display dialog "Enter the time (in seconds) between captures.

Please Note: Unfortunately, due to a bug, you must force quit this app to stop it." default answer 60
set capture_interval to (text returned of result) as integer
-- Ask for a location to save images to
set save_location to choose folder with prompt "Choose a save location."
-- Format the chosen location so that we can more easily use it later
--set save_location to POSIX path of save_location
display dialog save_location

-- Start a loop that will take a screen capture
repeat
	-- get current date, set series of variables to specific parts of date string
	set {year:y, month:m, day:d, hours:h, minutes:n, seconds:s} to current date
	
	-- Here is where we do some formatting to make for a better, image sequence friendly file name later on.
	-- Create the date part of the file so that it looks like this YYYYMMDD.
	-- To do that we need to coax the string parts from "current date" into being numbers.
	-- You can do this simply by doing some math with it.
	-- This gives us 20120000
	set file_name_date to y * 10000
	-- This gives us a month with a leading zero.
	-- The result being 20120100
	set file_name_date to file_name_date + m * 100
	-- This adds the day with a leading zero.
	-- The result being 20120109
	set file_name_date to file_name_date + d * 1
	-- Turn that into a string so we can concatenate it later
	set file_name_date to file_name_date as string
	
	-- This is the same process as above, this time being applied to the time of day
	set file_name_time to h * 10000
	set file_name_time to file_name_time + n * 100
	set file_name_time to file_name_time + s * 1
	set file_name_time to file_name_time as string
	
	-- Set the file extension
	set file_name_ext to ".png"
	
	-- Take the file name part variables and create a nice file name.
	-- The result will look like 20120124-113452.png
	--set file_name to file_name_date & "-" & file_name_time & ".png"
	
	if capture_monitor = "m" then
		-- Set the variable file_name to the the full path to the file (used as a parameter in the shell script which is called later)
		set file_name to save_location & file_name_date & "-" & file_name_time & file_name_ext
	else
		-- Create a temporary variable to hold onto some file path info while we loop
		set tmp_name to ""
		-- Set an iterator to put in the file name prefix "Monitor_1", "Monitor_2", etc.
		set i to 0
		-- Set the variable file_name to the base file name.
		-- Will look like 20120124-113452.png
		set file_name to ""
		
		-- Start a loop that will iterate once for each connected display (determined above)
		repeat count_displays times
			set i to i + 1
			-- Set the variable tmp_name to a unique value for each monitor
			-- Will look like Monitor_1-20120124-113452.png
			set tmp_name to save_location & "Monitor_" & i & "-" & file_name_date & "-" & file_name_time & file_name_ext
			-- This is going to create a list of file names to put at the end of the shell script which fires later
			set file_name to file_name & " " & tmp_name
		end repeat
	end if
	
	-- Pause for user defined amount of time
	delay capture_interval
	-- Run the system screen capture shell script and put the file(s) in the user defined location (the -x flag kills the sound effects)
	do shell script "screencapture -x" & capture_monitor & " " & file_name
end repeat

on quit
	exit repeat
	continue quit
end quit