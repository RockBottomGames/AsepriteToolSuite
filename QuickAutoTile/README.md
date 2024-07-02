# Quick Auto Tile - [Rock Bottom Games Aseprite Tool Suite](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/README.md)

If you like my tools please consider donating or supporting in other ways! [Patreon](https://www.patreon.com/rockbottomgames), [Ko-Fi](https://ko-fi.com/rockbottomgames), [YouTube](https://www.youtube.com/@RockBottomGamesLLC), and [Website](https://rockbottom.games)

## Short Description

Quick Auto Tile is the first tool under the RBGATS umbrella. I made it with the intention of speeding up my workflow.  I like to make the full autotile template for my tilesets in Godot, but a lot of the time it's a lot of copy pasting, and ensuring all the different pieces line up got annoying. So I reviewed all the tiles and noticed if you split the tiles in fourths you could reuse a lot of the drawing for a good base to build off of.

Below is a gif of how much less I need to draw to get the full Godot Auto Tile template filled out. If you allow the tilesets in Aseprite to flip X, Y, or D it will mirror the tiles on the x, y, or diagonal axes, and that can further decrease the required drawing.
    
![visualization of how much less drawing is required with quick auto tile](./readme_images/HowMuchLessDrawingVisualized-Large.gif)

## Installation:
It is recommend to install it from [rockbottomgames.itch.io](https://rockbottomgames.itch.io/rbg-aseprite-tool-suite)

*Or if you must:*

Installation instructions for [github.com/RockBottomGames/AsepriteToolSuite](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/README.md#installation-instructions-full-suite)

## Quick Auto Tile Dialog - Basic Usage:

* Start by opening the Autotile Dialog Under "View->Quick Auto Tile Actions Dialog" (Standalone) or "View->Rock Bottom Games Tool Suite->Quick Auto Tile Actions Dialog" (Suite):
    ![menu option for auto tile dialog](./readme_images/AsepriteMenu.png)
    * This should open a dialog, different tabs are hidden based on which sprite/layer you are currently viewing. To begin with it will likely look like this with only "New Sprite" tab available. The dialog is described in more detail below:

### New Sprite - Quick Auto Tile Dialog:
* This is typically the tab you will see first when you open Quick Auto Tile Diaolog:
![opened auto tile dialog](./readme_images/AsepriteDialog.png)
* Tilemap Layer Name - The new layer that will be created along with your new sprite that will be used for drawing your Quick Auto Tile.
* Half Tile Width/Half Tile Height - Since this app works in 1/4th tiles we use half tile width and height to build your tileset grid. Sorry, no full tilesets will ever result in odd numbers...
* Pause To Set Tilemap Allowed Flips Checkbox - When set to true this plugin will pause building the tilemap and provide you instructions on how to update the tileset's "Allowed Flips" section.
    * IMPORTANT: This is how we allow for even less drawing with mirrored x/y/diagonal axes. It's how we get the flips listed in this gif and more:
![visualization of how much less drawing is required with quick auto tile](./readme_images/HowMuchLessDrawingVisualized-Large.gif)
* Create Sprite Button - When clicked it will take the data above and build out a new sprite with a reference layer to help you know where to draw, a drawing layer to draw on, and the tileset already set up in the drawing layer so you're good to go, if you choose to it will also pause to give you a moment to change the tileset's "Allowed Flip" property.

### New Layer
* Once you have created a sprite through Quick Auto Tile the "New Layer" tab will appear when you have one of those sprites open.
![opened auto tile dialog on the new layer tab](./readme_images/AsepriteDialogNewLayerTab.png)
* Tilemap Layer Name - The new layer that will be created will try to name the layer this, if there is already a matching layer name it will Increment by 1 until it finds an unused name e.g. Drawing 2, Drawing 3, etc.
* Pause To Set Tilemap Allowed Flips Checkbox - When set to true this plugin will pause building the tilemap and provide you instructions on how to update the tileset's "Allowed Flips" section. Same as [above.](#new-sprite---quick-auto-tile-dialog)
* Warning - This warning describes how I optimized the program. We actually reuse the reference layer to build tilemaps after the first time it is drawn.  It's okay if you delete it or duplicate it, there's some error correcting by default, but if you want to be sure to create a clean new reference layer you can just select:
    * Force new reference layer checkbox - This will ensure a new clean reference layer is redrawn and all previous reference layers will be no longer noted as reference layers.
* Create New Autotile Layer Button (Create Layer) - Clicking this button will first do a couple checks for reference layers, create one if needed or if forced to, then it will create a new tilemap drawing layer with tilesets set up for you, if you choose to it will also pause to give you a moment to change the tileset's "Allowed Flip" property.

### Layer Actions
* Once you have created a sprite through Quick Auto Tile and you have selected either a drawing layer or a reference layer, the Layer Actions section will show up.  There is a separate section for Reference Layers and Drawing Layers:
#### Reference Layer Actions
* A reference layer actions section will look like this:
![opened auto tile dialog on the new layer tab](./readme_images/AsepriteDialogReferenceLayerActions.png)
* Reinitialize button - This will reset/redraw the currently selected reference layers and also make any duplicated reference layers no longer marked as reference layers.
#### Drawing Layer Actions
* A drawing layer actions section will look like this:
![opened auto tile dialog on the new layer tab](./readme_images/AsepriteDialogDrawingLayerActions.png)
* Pause To Set Tilemap Allowed Flips Checkbox - When set to true this plugin will pause building the tilemap and provide you instructions on how to update the tileset's "Allowed Flips" section. Same as [above.](#new-sprite---quick-auto-tile-dialog)
* Warning - This warning describes how I optimized the program. We actually reuse the reference layer to build tilemaps after the first time it is drawn.  It's okay if you delete it or duplicate it, there's some error correcting by default, but if you want to be sure to create a clean new reference layer you can just select:
    * Force new reference layer checkbox - This will ensure a new clean reference layer is redrawn and all previous reference layers will be no longer noted as reference layers.
* Reinitialize button - This will first check for and create a new reference layer if needed or forced to. Afterwards it will copy the layer to a temp layer before clearing it, rebuilding the tiles, if you chose to pause it will give you a moment to change the tileset "Allowed Flips" property, then when finished with all of that it will copy and paste your previous drawing from the temp layer back into the drawing layer and delete the temp layer.

## How it works

The way this plugin works is by building a tileset that is half the width and half the height of the expected result and filling out a tilemap layer for you in aseprite filled with empty tiles. When you draw inside those tiles it will automatically draw in all of the matching tiles and show you what the final result is for Godot's Template at the bottom. You can draw anywhere to ensure all tiles line up correctly.

Below is a gif visualizing how the quarter tiles are reused. It is not a visualization of how the plugin works, just there to help you see why I break the tiles into fourths.
    
![visualization of how much less drawing is required with quick auto tile](./readme_images/MatchingFourthsVisualized-Large.gif)

## Future Additions
* Coming soon - Create tileset export layer
    * This will just create a new tilemap layer based on an existing tilemap layer and copy the bottom portion of all frames to the new layer's frames
        * Then it will be up to you to export tileset.
* Coming eventually - Export Tilesets
    * If you want to export currently
        * you must make a new tilemap at 2 * half tile width and 2 * half tile height
        * then copy the bottom half to the top of a new layer
        * then export tileset and choose options like:
            * don't ignore empty tiles (that's why I put the top left corner as empty as aseprite puts empty tile there by default)
            * make the rows limited to 12 tiles (this will then match the layout)
            * Add any kind of other options you like, for example: extrude
    * I have no idea how to nicely do animations export for godot, good luck if that is what you want to do. (I will likely be able to make something programatically for that later)

## Support

Once again, thanks for coming to my page! If you'd like to support me feel free to visit: [Patreon](https://www.patreon.com/rockbottomgames), [Ko-Fi](https://ko-fi.com/rockbottomgames), [YouTube](https://www.youtube.com/@RockBottomGamesLLC), and [Website](https://rockbottom.games)
