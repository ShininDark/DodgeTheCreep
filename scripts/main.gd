extends Node

@export var mob_scene: PackedScene
var score

func _ready() -> void:
	new_game()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")



func _on_mob_timer_timeout() -> void:
	#Create new instance of mob in scene
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation  #choosing random location in path
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position   #set mob position in random location
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	#randomness in direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#choose velocity for mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn mob by adding it to main scene
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
