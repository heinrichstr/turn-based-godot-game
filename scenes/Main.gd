extends Node2D


# Declare member variables here. Examples:
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

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Board/TileMap").connect("tilemapClick", self, "_on_tilemap_click_signal")


func _on_tilemap_click_signal(tileId, clicked_cell):
	print("signal received ", tileId, " ", clicked_cell)
	print("commander size: ", $Board.boardData[tileId].tile.commandersOnTile.size())
	if $Board.boardData[tileId].tile.commandersOnTile.size() > 0:
		playerState.clickActive = true
		$Board/ActiveTileMarker.position = ($Board.boardData[tileId].tile.coords * 64) + Vector2($Board.tileSize / 2, $Board.tileSize / 2)
		$Board/ActiveTileMarker.visible = true
	elif $Board.boardData[tileId].tile.commandersOnTile.size() == 0:
		playerState.clickActive = false
		if $Board.has_node("activeIndicator"):
			$Board/ActiveTileMarker.visible = false
	#set clickActive to true
	#set active tile to tileId
	#make node on tile to show active
	#check if commander on tile is owned
	#activate movement
