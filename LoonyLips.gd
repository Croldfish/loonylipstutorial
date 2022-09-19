extends Control

var player_words = []

onready var current_story

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText = $VBoxContainer/DisplayText

func _ready():
	pick_current_story()
	DisplayText.text = "welcom(E) to loony lips you give me words and i put it into a totally canon breaking bad spinoff lolz. "
	check_player_words_length()
	PlayerText.grab_focus()

func pick_current_story():
	var stories = get_from_json("storybook.json")
	randomize() 
	current_story = stories[randi() % stories.size()]


# warning-ignore:unused_argument
func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()

# warning-ignore:unused_argument
func _on_PlayerText_text_entered(new_text):
	add_to_player_words()

func get_from_json(filename):
	var file = File.new()
	file.open(filename, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data
	
func add_to_player_words():
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()

func is_story_done():
	return player_words.size() == current_story.prompts.size() 

func check_player_words_length():
	if is_story_done():
		end_game()
	else:
		prompt_player()
		
func tell_story():
	DisplayText.text = current_story.story % player_words
	

	
func prompt_player():
	DisplayText.text += "GIMME " + current_story.prompts[player_words.size()] + "PRETTY PLEASE?"

func end_game():
	PlayerText.queue_free()
	$VBoxContainer/HBoxContainer/Label.text = "Again!"
	tell_story()


