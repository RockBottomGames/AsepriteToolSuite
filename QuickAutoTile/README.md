# Godot Quick Auto Tile

* This tool is to help make creating auto tile terrains easier

## Basic Usage:
* Start by opening the Autotile Dialog:
    ![menu option for auto tile dialog](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileMenuOption.png?raw=true)
    ![opened auto tile dialog](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileActionDialogNewSprite.png?raw=true)
* It is then recommended to keep the tilemap mode at Manual: Modify existent tiles
    ![tilemap mode manual](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileTileModeRecommended.png?raw=true)
    * While in this mode you can freely draw and all matching cells will update.
        ![what it should look like after initializing](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileWhatItShouldLookLike.png?raw=true)
        ![example of drawing on the tileset](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileTipsForDrawing.png?raw=true)
    * The top areas are the minimum requirement to fill out the whole set
        ![full drawing](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileAsepriteRef.png?raw=true)
    * The bottom area is the resulting tileset (I moved the empty square to be top left from godot's example sheet)
        * You can draw here too and all matching areas will update as long as you are in tilemap mode Manual: Modify existent tiles
        ![godot's template](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/Godot_Autotile_Template.jpg?raw=true)
* If you want even more simplification you can do the following:
    * Set tilemap mode to Auto: Modify and reuse existent tiles
    * Select All (Only from the initial drawing guide, changes made can break this process)
    * Cut
    * Open up tileset options popup for layer
        * Select allowed flips (x, y, and/or d)
        * This will allow it to match mirrored tiles and you can automatically make things symmetrical
        * Save these changes
        * Close tileset popup
    * Paste
    * Set tilemap mode back to Manual: Modify existent tiles
    * I would have made a command for this but the api doesn't let me have access to allowed flips x, y, or d
        * this is why this readme exists!

## New Layer
* If you have already created a sprite using the dialog and steps listed above, a new tab will appear in the actions dialog.
    ![full drawing](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileNewLayerpng?raw=true)
* This tab will let you create a new tilemap layer with the same guide on it (which is how the auto drawing works)

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