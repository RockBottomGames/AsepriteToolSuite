local TileUtils = dofile("./tiles.lua")
local colorIndices = {
    edge = 1,
    inner = 3,
}
local halfTileRefs = {
    --  ┌───┬───┐  ┌───┬───┐  ┌───┬───┐   ┌───┬───┐
    --  │   │   │  │   │   │  │   │▒▒▒│   │▒▒▒│   │
    --  │───┼───┤  │───┼───┤  │───┼───┤   │───┼───┤
    --  │   │▒▒▒│  │▒▒▒│   │  │   │   │   │   │   │
    --n:└───┴───┘x:└───┴───┘y:└───┴───┘xy:└───┴───┘
    edgeCorner = TileUtils.newHalfTile(
        {
            [3] = colorIndices.edge
        }
    ),

    --  ┌───┬───┐  ┌───┬───┐  ┌───┬───┐   ┌───┬───┐
    --  │   │   │  │▒▒▒│▒▒▒│  │   │▒▒▒│   │▒▒▒│   │
    --  │───┼───┤  │───┼───┤  │───┼───┤   │───┼───┤
    --  │▒▒▒│▒▒▒│  │   │   │  │   │▒▒▒│   │▒▒▒│   │
    --n:└───┴───┘y:└───┴───┘d:└───┴───┘dx:└───┴───┘
    edgeFlat = TileUtils.newHalfTile(
        {
            [3] = colorIndices.edge,
            [4] = colorIndices.edge
        }
    ),

    --  ┌───┬───┐  ┌───┬───┐  ┌───┬───┐   ┌───┬───┐
    --  │   │▒▒▒│  │▒▒▒│   │  │▒▒▒│▒▒▒│   │▒▒▒│▒▒▒│
    --  │───┼───┤  │───┼───┤  │───┼───┤   │───┼───┤
    --  │▒▒▒│▒▒▒│  │▒▒▒│▒▒▒│  │   │▒▒▒│   │▒▒▒│   │
    --n:└───┴───┘x:└───┴───┘y:└───┴───┘xy:└───┴───┘
    edgeJoint = TileUtils.newHalfTile(
        {
            [2] = colorIndices.edge,
            [3] = colorIndices.edge,
            [4] = colorIndices.edge
        }
    ),

    --  ┌───┬───┐  ┌───┬───┐  ┌───┬───┐   ┌───┬───┐
    --  │▒▒▒│▒▒▒│  │▒▒▒│▒▒▒│  │▒▒▒│▓▓▓│   │▓▓▓│▒▒▒│
    --  │───┼───┤  │───┼───┤  │───┼───┤   │───┼───┤
    --  │▒▒▒│▓▓▓│  │▓▓▓│▒▒▒│  │▒▒▒│▒▒▒│   │▒▒▒│▒▒▒│
    --n:└───┴───┘x:└───┴───┘y:└───┴───┘xy:└───┴───┘
    innerCorner = TileUtils.newHalfTile(
        {
            [1] = colorIndices.edge,
            [2] = colorIndices.edge,
            [3] = colorIndices.inner,
            [4] = colorIndices.edge
        }
    ),

    --  ┌───┬───┐  ┌───┬───┐  ┌───┬───┐   ┌───┬───┐
    --  │▒▒▒│▒▒▒│  │▓▓▓│▓▓▓│  │▒▒▒│▓▓▓│   │▓▓▓│▒▒▒│
    --  │───┼───┤  │───┼───┤  │───┼───┤   │───┼───┤
    --  │▓▓▓│▓▓▓│  │▒▒▒│▒▒▒│  │▒▒▒│▓▓▓│   │▓▓▓│▒▒▒│
    --n:└───┴───┘y:└───┴───┘d:└───┴───┘dx:└───┴───┘
    innerFlat = TileUtils.newHalfTile(
        {
            [1] = colorIndices.edge,
            [2] = colorIndices.edge,
            [3] = colorIndices.inner,
            [4] = colorIndices.inner
        }
    ),

    --  ┌───┬───┐  ┌───┬───┐  ┌───┬───┐   ┌───┬───┐
    --  │▒▒▒│▓▓▓│  │▓▓▓│▒▒▒│  │▓▓▓│▓▓▓│   │▓▓▓│▓▓▓│
    --  │───┼───┤  │───┼───┤  │───┼───┤   │───┼───┤
    --  │▓▓▓│▓▓▓│  │▓▓▓│▓▓▓│  │▒▒▒│▓▓▓│   │▓▓▓│▒▒▒│
    --n:└───┴───┘x:└───┴───┘y:└───┴───┘xy:└───┴───┘
    innerJoint = TileUtils.newHalfTile(
        {
            [1] = colorIndices.edge,
            [2] = colorIndices.inner,
            [3] = colorIndices.inner,
            [4] = colorIndices.inner
        }
    ),

    --  ┌───┬───┐
    --  │▓▓▓│▓▓▓│
    --  │───┼───┤
    --  │▓▓▓│▓▓▓│
    --n:└───┴───┘
    innerFull = TileUtils.newHalfTile(
        {
            [1] = colorIndices.inner,
            [2] = colorIndices.inner,
            [3] = colorIndices.inner,
            [4] = colorIndices.inner
        }
    ),
}

local tileRefs = {
    --  █        █
    --  █  ┌──┐  █
    --  █  └──┘  █
    --n:█        █
    edgeBox = TileUtils.newTile({
            [1] = halfTileRefs.edgeCorner,
            [2] = halfTileRefs.edgeCorner:flip({"x"}),
            [3] = halfTileRefs.edgeCorner:flip({"x", "y"}),
            [4] = halfTileRefs.edgeCorner:flip({"y"}),
    }),


    --  █        █  █        █  █        █   █  │  │  █
    --  █  ┌─────█  █─────┐  █  █  ┌──┐  █   █  │  │  █
    --  █  └─────█  █─────┘  █  █  │  │  █   █  └──┘  █
    --n:█        █x:█        █d:█  │  │  █dy:█        █
    edgeTip = TileUtils.newTile({
            [1] = halfTileRefs.edgeCorner,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.edgeFlat:flip({"y"}),
            [4] = halfTileRefs.edgeCorner:flip({"y"}),
    }),


    --  █        █  █  │  │  █
    --  █────────█  █  │  │  █
    --  █────────█  █  │  │  █
    --n:█        █d:█  │  │  █
    edgeFlat = TileUtils.newTile({
            [1] = halfTileRefs.edgeFlat,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.edgeFlat:flip({"y"}),
            [4] = halfTileRefs.edgeFlat:flip({"y"}),
    }),


    --  █        █  █▒▒▒▒▒▒▒▒█  █  │  ║▒▒█   █▒▒║  │  █
    --  █────────█  █════════█  █  │  ║▒▒█   █▒▒║  │  █
    --  █════════█  █────────█  █  │  ║▒▒█   █▒▒║  │  █
    --n:█▒▒▒▒▒▒▒▒█y:█        █d:█  │  ║▒▒█dx:█▒▒║  │  █
    innerFlat = TileUtils.newTile({
            [1] = halfTileRefs.edgeFlat,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.innerFlat,
            [4] = halfTileRefs.innerFlat,
    }),


    --  █        █  █        █  █  │  │  █   █  │  │  █
    --  █  ┌─────█  █─────┐  █  █  │  └──█   █──┘  │  █
    --  █  │  ┌──█  █──┐  │  █  █  └─────█   █─────┘  █
    --n:█  │  │  █x:█  │  │  █y:█        █xy:█        █
    edgeCorner = TileUtils.newTile({
            [1] = halfTileRefs.edgeCorner,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.edgeJoint:flip({"x","y"}),
            [4] = halfTileRefs.edgeFlat:flip({"d"}),
    }),


    --  █        █  █        █  █  │  ║▒▒█   █▒▒║  │  █
    --  █  ┌─────█  █─────┐  █  █  │  ╚══█   █══╝  │  █
    --  █  │  ╔══█  █══╗  │  █  █  └─────█   █─────┘  █
    --n:█  │  ║▒▒█x:█▒▒║  │  █y:█        █xy:█        █
    innerCorner = TileUtils.newTile({
            [1] = halfTileRefs.edgeCorner,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.innerCorner,
            [4] = halfTileRefs.edgeFlat:flip({"d"}),
    }),


    --  █▒▒▒▒▒▒▒▒█  █▒▒▒▒▒▒▒▒█  █▒▒║  │  █   █  │  ║▒▒█
    --  █▒▒╔═════█  █═════╗▒▒█  █▒▒║  └──█   █──┘  ║▒▒█
    --  █▒▒║  ┌──█  █──┐  ║▒▒█  █▒▒╚═════█   █═════╝▒▒█
    --n:█▒▒║  │  █x:█  │  ║▒▒█y:█▒▒▒▒▒▒▒▒█xy:█▒▒▒▒▒▒▒▒█
    innerJoint = TileUtils.newTile({
            [1] = halfTileRefs.innerJoint:flip({"x","y"}),
            [2] = halfTileRefs.innerFlat:flip({"y"}),
            [3] = halfTileRefs.edgeJoint:flip({"x","y"}),
            [4] = halfTileRefs.innerFlat:flip({"d","x"}),
    }),


    --  █        █  █  │  │  █  █  │  │  █   █  │  │  █
    --  █────────█  █──┘  └──█  █  │  └──█   █──┘  │  █
    --  █──┐  ┌──█  █────────█  █  │  ┌──█   █──┐  │  █
    --n:█  │  │  █y:█        █d:█  │  │  █dx:█  │  │  █
    edgeT = TileUtils.newTile({
            [1] = halfTileRefs.edgeFlat,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.edgeJoint:flip({"x","y"}),
            [4] = halfTileRefs.edgeJoint:flip({"y"}),
    }),


    --  █        █   █        █   █  │  ║▒▒█    █▒▒║  │  █
    --  █────────█   █────────█   █──┘  ╚══█    █══╝  └──█
    --  █──┐  ╔══█   █══╗  ┌──█   █────────█    █────────█
    --n:█  │  ║▒▒█ x:█▒▒║  │  █ y:█        █ xy:█        █
    --  ██████████████████████████████████████████████████
    --  █  │  │  █   █  │  │  █   █  │  ║▒▒█    █▒▒║  │  █ 
    --  █  │  └──█   █──┘  │  █   █  │  ╚══█    █══╝  │  █
    --  █  │  ╔══█   █══╗  │  █   █  │  ┌──█    █──┐  │  █
    --d:█  │  ║▒▒█dx:█▒▒║  │  █dy:█  │  │  █dxy:█  │  │  █
    edgeTOneInnerCorner = TileUtils.newTile({
            [1] = halfTileRefs.edgeFlat,
            [2] = halfTileRefs.edgeFlat,
            [3] = halfTileRefs.innerCorner,
            [4] = halfTileRefs.edgeJoint:flip({"y"}),
    }),


    --  █▒▒▒▒▒▒▒▒█  █  │  │  █  █▒▒║  │  █   █  │  ║▒▒█
    --  █════════█  █──┘  └──█  █▒▒║  └──█   █──┘  ║▒▒█
    --  █──┐  ┌──█  █════════█  █▒▒║  ┌──█   █──┐  ║▒▒█
    --n:█  │  │  █y:█▒▒▒▒▒▒▒▒█d:█▒▒║  │  █dx:█  │  ║▒▒█
    innerT = TileUtils.newTile({
            [1] = halfTileRefs.innerFlat:flip({"y"}),
            [2] = halfTileRefs.innerFlat:flip({"y"}),
            [3] = halfTileRefs.edgeJoint:flip({"x","y"}),
            [4] = halfTileRefs.edgeJoint:flip({"y"}),
    }),


    --  █  │  │  █
    --  █──┘  └──█
    --  █──┐  ┌──█
    --n:█  │  │  █
    edgePlus = TileUtils.newTile({
            [1] = halfTileRefs.edgeJoint,
            [2] = halfTileRefs.edgeJoint:flip({"x"}),
            [3] = halfTileRefs.edgeJoint:flip({"x","y"}),
            [4] = halfTileRefs.edgeJoint:flip({"y"}),
    }),


    --  █  │  │  █  █  │  │  █  █  │  ║▒▒█   █▒▒║  │  █
    --  █──┘  └──█  █──┘  └──█  █──┘  ╚══█   █══╝  └──█
    --  █──┐  ╔══█  █══╗  ┌──█  █──┐  ┌──█   █──┐  ┌──█
    --n:█  │  ║▒▒█x:█▒▒║  │  █y:█  │  │  █xy:█  │  │  █
    edgePlusOneInnerCorner = TileUtils.newTile({
            [1] = halfTileRefs.edgeJoint,
            [2] = halfTileRefs.edgeJoint:flip({"x"}),
            [3] = halfTileRefs.innerCorner,
            [4] = halfTileRefs.edgeJoint:flip({"y"}),
    }),


    --  █▒▒║  │  █  █  │  ║▒▒█
    --  █══╝  └──█  █──┘  ╚══█
    --  █──┐  ╔══█  █══╗  ┌──█
    --n:█  │  ║▒▒█x:█▒▒║  │  █
    edgePlusTwoInnerCorner = TileUtils.newTile({
            [1] = halfTileRefs.innerCorner:flip({"x", "y"}),
            [2] = halfTileRefs.edgeJoint:flip({"x"}),
            [3] = halfTileRefs.innerCorner,
            [4] = halfTileRefs.edgeJoint:flip({"y"}),
    }),


    --  █▒▒▒▒▒▒▒▒█
    --  █▒▒▒▒▒▒▒▒█
    --  █▒▒▒▒▒▒▒▒█
    --n:█▒▒▒▒▒▒▒▒█
    innerFull = TileUtils.newTile({
            [1] = halfTileRefs.innerFull,
            [2] = halfTileRefs.innerFull,
            [3] = halfTileRefs.innerFull,
            [4] = halfTileRefs.innerFull,
    }),
}

local DefaultTileMap = {
    tiles = {
        -------------------------------------------------------
        tileRefs.edgeBox:place(Rectangle{x=1, y=1}),
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        tileRefs.innerCorner:place(Rectangle{x=4, y=1}),
        tileRefs.innerFlat:place(Rectangle{x=6, y=1}),
        tileRefs.innerCorner:flip({"x"}):place(Rectangle{x=8, y=1}),
        
        tileRefs.innerFlat:flip({"d"}):place(Rectangle{x=4, y=3}),
        tileRefs.innerFull:place(Rectangle{x=6, y=3}),
        tileRefs.innerFlat:flip({"d","x"}):place(Rectangle{x=8, y=3}),
        
        tileRefs.innerCorner:flip({"y"}):place(Rectangle{x=4, y=5}),
        tileRefs.innerFlat:flip({"y"}):place(Rectangle{x=6, y=5}),
        tileRefs.innerCorner:flip({"x","y"}):place(Rectangle{x=8, y=5}),
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        tileRefs.edgeFlat:flip({"d"}):place(Rectangle{x=13, y=1}),
        
        tileRefs.edgeFlat:place(Rectangle{x=11, y=3}),
        tileRefs.edgePlus:place(Rectangle{x=13, y=3}),
        tileRefs.edgeFlat:place(Rectangle{x=15, y=3}),
        
        tileRefs.edgeFlat:flip({"d"}):place(Rectangle{x=13, y=5}),
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        tileRefs.innerJoint:flip({"x", "y"}):place(Rectangle{x=18, y=1}),
        tileRefs.innerFull:place(Rectangle{x=20, y=1}),
        tileRefs.innerJoint:flip({"y"}):place(Rectangle{x=22, y=1}),
        
        tileRefs.innerFull:place(Rectangle{x=18, y=3}),
        tileRefs.innerFull:place(Rectangle{x=20, y=3}),
        tileRefs.innerFull:place(Rectangle{x=22, y=3}),
        
        tileRefs.innerJoint:flip({"x"}):place(Rectangle{x=18, y=5}),
        tileRefs.innerFull:place(Rectangle{x=20, y=5}),
        tileRefs.innerJoint:place(Rectangle{x=22, y=5}),
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        tileRefs.edgeTip:place(Rectangle{x=2, y=8}),
        tileRefs.edgeFlat:place(Rectangle{x=4, y=8}),
        tileRefs.edgeTip:flip({"x"}):place(Rectangle{x=6, y=8}),

        tileRefs.edgeTip:flip({"d"}):place(Rectangle{x=0, y=10}),
        tileRefs.edgeCorner:place(Rectangle{x=2, y=10}),
        tileRefs.edgeT:place(Rectangle{x=4, y=10}),
        tileRefs.edgeCorner:flip({"x"}):place(Rectangle{x=6, y=10}),

        tileRefs.edgeFlat:flip({"d"}):place(Rectangle{x=0, y=12}),
        tileRefs.edgeT:flip({"d"}):place(Rectangle{x=2, y=12}),
        tileRefs.edgePlus:flip({"d","x","y"}):place(Rectangle{x=4, y=12}),
        tileRefs.edgeT:flip({"d","x"}):place(Rectangle{x=6, y=12}),
        
        tileRefs.edgeTip:flip({"d","y"}):place(Rectangle{x=0, y=14}),
        tileRefs.edgeCorner:flip({"y"}):place(Rectangle{x=2, y=14}),
        tileRefs.edgeT:flip({"y"}):place(Rectangle{x=4, y=14}),
        tileRefs.edgeCorner:flip({"x","y"}):place(Rectangle{x=6, y=14}),
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        tileRefs.edgePlusOneInnerCorner:flip({"x","y"}):place(Rectangle{x=8, y=8}),
        tileRefs.edgeTOneInnerCorner:place(Rectangle{x=10, y=8}),
        tileRefs.edgeTOneInnerCorner:flip({"x"}):place(Rectangle{x=12, y=8}),
        tileRefs.edgePlusOneInnerCorner:flip({"y"}):place(Rectangle{x=14, y=8}),

        tileRefs.edgeTOneInnerCorner:flip({"d"}):place(Rectangle{x=8, y=10}),
        tileRefs.innerJoint:flip({"x","y"}):place(Rectangle{x=10, y=10}),
        tileRefs.innerJoint:flip({"y"}):place(Rectangle{x=12, y=10}),
        tileRefs.edgeTOneInnerCorner:flip({"d","x"}):place(Rectangle{x=14, y=10}),

        tileRefs.edgeTOneInnerCorner:flip({"d", "y"}):place(Rectangle{x=8, y=12}),
        tileRefs.innerJoint:flip({"x"}):place(Rectangle{x=10, y=12}),
        tileRefs.innerJoint:place(Rectangle{x=12, y=12}),
        tileRefs.edgeTOneInnerCorner:flip({"d","x", "y"}):place(Rectangle{x=14, y=12}),
        
        tileRefs.edgePlusOneInnerCorner:flip({"x"}):place(Rectangle{x=8, y=14}),
        tileRefs.edgeTOneInnerCorner:flip({"y"}):place(Rectangle{x=10, y=14}),
        tileRefs.edgeTOneInnerCorner:flip({"x","y"}):place(Rectangle{x=12, y=14}),
        tileRefs.edgePlusOneInnerCorner:place(Rectangle{x=14, y=14}),
        -------------------------------------------------------
        --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
        -------------------------------------------------------
        tileRefs.innerCorner:place(Rectangle{x=16, y=8}),
        tileRefs.innerT:flip({"y"}):place(Rectangle{x=18, y=8}),
        tileRefs.innerFlat:place(Rectangle{x=20, y=8}),
        tileRefs.innerCorner:flip({"x"}):place(Rectangle{x=22, y=8}),

        tileRefs.innerFlat:flip({"d"}):place(Rectangle{x=16, y=10}),
        tileRefs.edgePlusTwoInnerCorner:flip({"x"}):place(Rectangle{x=18, y=10}),
        tileRefs.edgeBox:place(Rectangle{x=20, y=10}),
        tileRefs.innerT:flip({"d"}):place(Rectangle{x=22, y=10}),

        tileRefs.innerT:flip({"d","x"}):place(Rectangle{x=16, y=12}),
        tileRefs.innerFull:place(Rectangle{x=18, y=12}),
        tileRefs.edgePlusTwoInnerCorner:place(Rectangle{x=20, y=12}),
        tileRefs.innerFlat:flip({"d","x"}):place(Rectangle{x=22, y=12}),
        
        tileRefs.innerCorner:flip({"y"}):place(Rectangle{x=16, y=14}),
        tileRefs.innerFlat:flip({"y"}):place(Rectangle{x=18, y=14}),
        tileRefs.innerT:place(Rectangle{x=20, y=14}),
        tileRefs.innerCorner:flip({"x","y"}):place(Rectangle{x=22, y=14}),
        -------------------------------------------------------
    }
}

function DefaultTileMap:draw(halfTileWidth, halfTileHeight, layer)
    for _, tile in ipairs(self.tiles) do
        TileUtils:drawTile(tile, halfTileWidth, halfTileHeight, layer)
    end
end

return DefaultTileMap