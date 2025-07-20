# AutoGodotBoy

A script to easily convert .gb and .gbc games to other platforms.
Uses the Godot game engine in tandem with the GodotBoy extension made by GreenFox.

## All you need to do

Place the script in an empty folder next to the game rom like so.

![2files](./assets/2025-7-20%2019-31-9.png)  
Now double click the `autogodotboy.bat` script.

## The scripts installs the following:
- Godot 4.3 (inside the godot folder)
- Godot 4.3 export templates (places into %APPDATA%\Godot\export_templates\4.3.stable\)
- GodotBoy template project (gbc-exe-template)
- sed ([open source tool for text editing](https://github.com/mbuilov/sed-windows))


## After the script finishes, you should see something like this:

![morefiles](./assets/2025-7-20%2019-33-34.png)

In the `build` folder you will find the exports for Windows, Linux.x64, Linux.arm64 and Web.  
You can continue working inside `gbc-exe-template` folder as with a normal Godot project.  
<ins>***If you rename the folder, the script will stop working.***</ins>

To compile again, delete the `build` folder and run the script again.  
You may put a different rom there at this point too.   
**Note:** only 1 rom at a time.
