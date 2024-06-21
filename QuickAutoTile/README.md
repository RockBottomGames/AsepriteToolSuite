# Godot Quick Auto Tile

* This tool is to help make creating auto tile terrains easier
* To use - Make a new sprite from the quick auto tile actions dialog
* It is then recommended to change the tilemap mode to Manual: Modify existent tiles
    * Once in this mode you can freely draw and all matching cells will update.
    * The top areas are the minimum requirement to fill out the whole set
    * The bottom area is the resulting tileset (I moved the empty square to be top left from godot's example sheet)
        * You can draw here too and all matching areas will update as long as you are in tilemap mode Manual: Modify existent tiles
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