# E C H O B R E A K O U T

## Overview

This is a brick-break style game that @BDFife and @JimFingal built for MHDBOS2012.

The game takes a music file as an input and uses it to generate a field of bricks - when you break a brick it plays the corresponding portion of the song.

## Running the Game

If you are using a mac, you should be able to download the executable file from the downloads page on GitHub, or [here.](https://s3.amazonaws.com/BDFife-Public/EchoBreakout.zip)

You may need to right click the game and select “open” explicitly if your OS (Mountain Lion) requires signed code. 

You can run on any operating system (Windows, Linux or Mac) if you have the Löve2d engine already installed on your machine - just grab the .love file from the downloads page. You can find the Löve2d installers [here.](https://love2d.org)

## Building your own music

Right now, you can package your own music files for the game, but you need to have the [EchoNest Remix Library](http://echonest.github.com/remix/) running on your system already. 

To package a music file, you need to complete the following steps: 
* Use the script build_song.sh that’s included with the source with your favorite audio file. The generated lua and .mp3 fragments should be placed in the ./Music directory.
* Manually edit the manifest.lua file in the ./Music directory and replace one of the existing entries with your new song.
* Generate a new love file with the script ./build_ping.sh. If you’re on a mac and already have the Löve2d executable installed, it should just run! 

## Acknowledgments

ECHOBREAKOUT was built using [The EchoNest Remix Library](http://echonest.github.com/remix/) and [The Löve2d framework](Love2d.org). 

Default music for the application was provided by the [Free Music Archive](freemusicarchive.org), specifically, [Trouba by Steve Gunn](http://freemusicarchive.org/music/Soundeyet/On_A_Steady_Diet_of_Hash_Bread__Salt/) from the album Soundeyet, [Latin Jeta by Los Sundayers](http://freemusicarchive.org/music/Los_Sundayers/Eterno_Domingo/Los_Sundayers_-_04_-_Latin_Jeta) from the album Eterno Domingo, and [Monster on Campus by Halloween](http://freemusicarchive.org/music/Halloween/ST_1099/) from the album S/T. All distributed under [Creative Commons BY-NC-SA](http://creativecommons.org/licenses/by-nc-sa/3.0/).