# sine animator plugin
roblox animating plugin, by @heathyboobs

# INFO
hi, thanks for using my plugin. i put it on github because i wanted it to be obscure, acting kinda like a filter for newbies. :P also i may or may not have put it on github just so i wouldn't have to "scriptify" the gui interface i built. this isn't the most innovative animator, but i wanted to make my own to use for my own stuff. also the plugin.lua file is messy messy code. i'll put setup instructions and tutorial stuff below in this file. if you have any suggestions or bug fixes or whatever them let me know on twitter @heathyboobs.

# SETUP
first of all, you're going to need to put the "sine animator" folder into your roblox plugins folder. you can either open roblox studio, go to the PLUGINS tab and click the "Plugins Folder" button, or you can navigate to AppData\Local\Roblox\Plugins. then just drag the "sine animator" folder into the plugins folder. then, once you have the plugin loaded and roblox studio launched, right click on the "StarterGui" folder in the explorer and select "Insert from File..." and open the "interface.rbxm" file. once inserted, click the "sine animator" button in the PLUGINS tab. once you click it, the sine animator gui will disappear from the StarterGui folder and be stored in the hidden CoreGui service. you will to re-insert the interface.rbxm file every time you relaunch the place in studio.

# USER GUIDE
at the bottom right of the screen, there should be a tab that says "sine animator" with a "close" and "max" button. click "max" to open the animator window. to animate a part, click "new", select one part, and click the box that reads "no part set". you will now be able to animate the part you set. you can also rename the wave object with the textbox at the top of the property window. there will be two sets of XYZ coordinate numbers at the bottom. the left one is the position XYZ, and the second one is the rotation XYZ. to change the coordinates, plcae your cursor over one of the values, hold the left ctrl key and scroll up or down to increase or decrease the value you have your mouse over. for more precise and smaller increments, hold left shift instead of left ctrl. to watch the part move with these vectors in realtime, click the "preview" button. click it again to return the parts to their original position. you will not be able to move set parts while previewing.
the frequency property is the speed of part movement oscillation, in hertz.
the amplitude property multiplies the position movement vector.
the y offset (raise) property slides the part across the movement vectors.
the x offset property offsets the time position of the wave (with multiplication of pi).
you can also create multiple waves for one part for more complex movement. that should be it. happy animating!

heather @heathyboobs
