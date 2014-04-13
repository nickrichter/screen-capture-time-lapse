Screen Capture Time-Lapse
-------------------------

This is a simple AppleScript applet that will take screen captures at a user specified interval and save them to a user specified folder.



### How it works

When launching the app it will detect how many displays you have connected. If the app detects that you have more than 1 display, it will ask what you want to capture. Due to the nature of Applescript dialog box button limitations, and the limitations of the `screencapture` terminal command, you will have two options.

1. Main Monitor Only
2. Capture All

You will then be prompted to enter the amount of time (in seconds) you want to wait between captures. The default is 60 seconds.

Finally, you will be asked where you would like to save the images to. When you choose a location, the app will begin running without further prompting.

__Caution:__ Keep in mind that this functions essentially the same way that any application will. It will stay open and run in the background until you quit. The shutter sound has been disabled so there will not be an audio cue that it is still running. If you see the app icon in your dock, it is running. If you forget to quit, you might find your hard drive quickly filling up.

The file naming convention is based on the date and time the screen is captured and formatted thusly:

* yyyymmdd-hhnnss.png
* y = year
* m = month
* d = day
* h = hours
* n = minutes
* s = seconds

If you have multiple displays connected, it will append "Monitor_#-" to the beginning, like so:

* Monitor_1-yyyymmdd-hhnnss.png
* Monitor_2-yyyymmdd-hhnnss.png
* And so on

This makes for a nice, image sequence friendly, set of files.



### Installation

There is no installation per se, but this is just a plain text file of the source code, and not executable. Since AppleScript's .scpt files are compiled, binary, files they are difficult to perform diffs on, and keep track of with version control. There are a couple options to get a compiled version of the script. The first is to simply open AppleScript Editor and paste the source code into a new file. Another is to open Terminal and do the following:

1. `cd` to the directory where you want the compiled script to live
2. type `osacompile -o myscript.scpt /path/to/my/screen-capture-time-lapse.applescript` and hit return

The `-o` flag is the filename you want for the output. If the output is not specified, the default a.scpt will be used. It's also worthwhile to note, that *the output will be placed where the osacompile command is run from*. For example, if your present working directory is your user home directory, a.scpt will be put in your home directory even if screen-capture-time-lapse.applescript is on your desktop. That is why the `cd` in step 1 is important.