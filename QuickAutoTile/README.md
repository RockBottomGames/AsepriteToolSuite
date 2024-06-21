# Godot Quick Auto Tile

* This tool is to help make creating auto tile terrains easier
* To use:
    * Start by opening the Autotile Dialog:
        ![menu option for auto tile dialog](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileMenuOption.png?raw=true)
        ![opened auto tile dialog](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileActionDialogNewSprite.png?raw=true)
* It is then recommended to change the tilemap mode to Manual: Modify existent tiles
    ![tilemap mode manual](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileTileModeRecommended.png?raw=true)
    * Once in this mode you can freely draw and all matching cells will update.
        ![what it should look like after initializing](https://github.com/RockBottomGames/AsepriteToolSuite/blob/main/QuickAutoTile/readme_images/QuickAutoTileWhatItShouldLookLike.png?raw=true)
        * It is recommended to select all and cut the guide and then paste it on another layer and make it transparent to help guide where to draw
        * It is also recommended to show the grid while you work
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