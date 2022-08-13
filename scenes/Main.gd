extends Node2D


var playerState = {
	"activeTile": -1, 
	"clickActive": false, 
	"selectedCommander": -1, 
	"navigation": {
		"active": false,
		"tileFrom": Vector2(0,0),
		"tileTo": Vector2(0,0)
		}
	}


func _ready():
	get_node("Board/TileMap").connect("tilemapClick", self, "_on_tilemap_click_signal")


func _on_tilemap_click_signal(tileId, clicked_cell):
	print("signal received ", tileId, " ", clicked_cell)
	print("commander size: ", $Board.boardData[tileId].tile.commandersOnTile.size())
	
	#set clickActive to true, place tile marker and set to visible if valid click, otherwise hide the node
	#set active tile to tileId
	if $Board.boardData[tileId].tile.commandersOnTile.size() > 0 && $Board.boardData[tileId].tile.commandersOnTile.find({"owner": 0}):
		playerState.clickActive = true
		$Board/ActiveTileMarker.position = ($Board.boardData[tileId].tile.coords * 64) + Vector2($Board.tileSize / 2, $Board.tileSize / 2)
		$Board/ActiveTileMarker.visible = true
		playerState.activeTile = tileId
		playerState.navigation.active = true
		#playerState.navigation.tileFrom = $Board.boardData[tileId].tile.coords
	elif $Board.boardData[tileId].tile.commandersOnTile.size() == 0:
		playerState.clickActive = false
		if $Board.has_node("activeIndicator"):
			$Board/ActiveTileMarker.visible = false
	
	
	
	#check if commander on tile is owned
	#activate movement
