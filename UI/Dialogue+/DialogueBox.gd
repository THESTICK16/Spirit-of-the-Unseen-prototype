extends CanvasLayer

onready var text_box := $DialogueTextBox # $OuterMargin/ColorRect/MarginContainer/RichTextLabel
onready var name_text_box := $NameTextBox
onready var tween := $OuterMargin/Tween
onready var continue_indicator := $OuterMargin/BackgroundColorRect/ContinueIndicator
onready var font = text_box.get_font("normal_font")
onready var name_background = $OuterMargin/BackgroundColorRect/VBoxContainer/NameBackgroundColorRect

## A temporary variable to hold the dialog for the given box
## To be deleted and replaced with a more advanced method of retrieval later
#export var temp_dialogue := [
#	"You are kind of a loser",
#	"No you",
#	"No... you...",
#	"thats a very unkind thing to say how could you be so cruel as to do that to a person. hidoi desu yo, kaichou no baka!!!",
#	"---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
#	]
#const TEMP_DIALOGUE_PATH := "/Users/ryorke16/Documents/Godot Projects/Spirit of the Unseen Prototype/Dialogue JSONs/TestDialogue.json"

## To be emitted once the dialogue is finished
signal dialogue_finished
## Emitted on a button press to transition to the next line of dialogue
signal next_button_pressed

## The path to the file containing the dialogue for this specific interaction
var dialogue_path := ""
## An array containg the strings of dialogue to display (one line per index)
#var dialogue
## If true, the text is fully displayed and pressing a button should move to the next line
var text_finished := false
## The dialogue to display if there is an error in loading the proper dialogue
var error_response := {0: "Whoops looks like the developer forgot to write any dialogue for me :("}
## The amount of time the tween will to take to fully display each line
var tween_time = 0.5
## The approximate maximum amount of characters that can fit in the text box per line
onready var max_chars = 250 #text_box.get_parent_area_size().x / 4 #250 #Just a guess. Fix this to proper amount!!!


func _ready():
	continue_indicator.hide()
#	call_deferred("load_dialogue")
#	load_dialogue()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("a") or Input.is_action_just_pressed("b"):
#		print(text_box.visible_characters) #FIXME
		if text_finished:
			emit_signal("next_button_pressed")
		elif tween.is_active():
			tween.seek(100)
			tween.emit_signal("tween_completed")
#			tween.stop_all()
#			text_box.percent_visible = 1
#			tween.emit_signal("tween_completed")

#func load_dialogue():
##	temp_dialogue = get_dialogue_from_JSON(dialogue_path)
#	temp_dialogue = temp_dialogue[0].get("conversation2")
#	temp_dialogue = _adjust_line_length(temp_dialogue) #temp_dialogue[0].get("conversation2"))
##	temp_dialogue = (temp_dialogue[0].get("conversation3")) #FIXME This line is for testing purposes
#	for line in temp_dialogue:
#		_next_line(line)
##		var line = row.get("text")
##		continue_indicator.hide()
##		text_finished = false
##		var tween_time = min(len(line) * 0.02, 5)
##		#if len(line) > max_chars:
##			#set the rest of the line on a separate line
##			#Make sure this is done in a separate method before starting the display
##		text_box.text = line
###		text_box.bbcode_text = line
##		text_box.percent_visible = 0
##		tween.interpolate_property(
##			text_box, "percent_visible", 
##			0, 1, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
##		)
##		tween.start()
##		yield(tween, "tween_completed")
##		continue_indicator.show()
##		text_finished = true
#
##		print("parent area size: " + str(text_box.get_parent_area_size())) #FIXME
##		print(text_box.get_total_character_count()) #FIXME
##		print("string size: " + str(font.get_string_size(line))) #FIXME
#
#		yield(self, "next_button_pressed")
##	hide()
#	call_deferred("_end_dialogue")
##	end_dialogue()

func new_dialogue(source):
	var dialogue : Dictionary
	if source is String and source.ends_with("json"):
		dialogue = _get_dialogue_from_json(source)
	elif source is Dictionary:
		dialogue = source
	elif source is Array:
#		var dict_from_array := {}
#		var key = 0
#		for line in source:
#			dict_from_array[key] = line
#			key += 1
		dialogue = _get_dialogue_from_array(source)#dict_from_array
	else:
		dialogue = error_response #{0: "Whoops looks like the developer forgot to write any dialogue for me :("}
	
	_start_dialogue(dialogue)
#	dialogue = adjust_line_length(dialogue)
	
func _start_dialogue(dialogue: Dictionary):
	for line in dialogue:
		_next_line(dialogue.get(line))
		yield(self, "next_button_pressed")

	call_deferred("_end_dialogue")

func _next_line(line: Dictionary):
	continue_indicator.hide()
	text_finished = false
	tween_time = 0.5 #min(len(line) * 0.02, 5)
	
	text_box.text = line.get("text")
	name_text_box.text = line.get("speaker_name")
	if name_text_box.text == "":
		name_background.hide()
	else:
		name_background.show()
#	text_box.bbcode_text = line

	text_box.percent_visible = 0
	
	tween.interpolate_property(
		text_box, "percent_visible", 
		0, 1, tween_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.start()
	
	yield(tween, "tween_completed")
	continue_indicator.show()
	text_finished = true
	
func _end_dialogue():
	emit_signal("dialogue_finished")
	queue_free()

func _get_dialogue_from_json(path: String) -> Dictionary:
#	return ["If you are seeing this you need to fix the get_dialogue method in the DialogueBox script"] #FIXME!!!
	var file := File.new()
	if not file.file_exists(path):
		return error_response
#		return ["Whoops, looks like the dev forgot to add my dialogue :("]
	else:
		file.open(path, File.READ)
		var json := file.get_as_text()

		var output = parse_json(json)
#		if typeof(output) == TYPE_ARRAY:
#			return output
		if typeof(output) == TYPE_DICTIONARY:
			return output
		else:
			return error_response #{0: "Whoops, looks like the dev forgot to add my dialogue :("}
#			return ["Whoops, looks like the dev forgot to add my dialogue :("]
	
func _adjust_line_length(lines : Array) -> Array:
	var new_lines = []
	for i in lines.size():
		var line = lines[i]
		if not typeof(line) == TYPE_STRING:
			line = str(line)
		if len(line) > max_chars:
			new_lines.append_array(_split_line(line, []))
		else:
			new_lines.append(line)
	return new_lines
	
## This recursive method separates a long string into an array of smaller strings
## Each string must be smaller than max_chars
## @param line the line to be split apart
## @param split_apart the array containing the lines after they have been split. Should be empty initially
func _split_line(line : String, split_apart : Array) -> Array: #this recursive method separates a long string into an array of strings that a
	if len(line) < max_chars:
		split_apart.append(line)
		return split_apart
	
	else:
		var delimeter ="."
		var sentences = line.split(".")
		if sentences.size() <= 1:
			sentences = line.split(" ") #FIXME adjust for this edge case of no periods being present
			delimeter = " "
			if sentences.size() <= 1:
				return split_apart
		var shortened_line := ""
#		var box_width = (text_box.rec #.get_parent_area_size().x - ($ColorRect/MarginContainer.rect_size.x - text_box.rect_size.x)) * 2) #(margin_left + margin_right)) * 2)
		
		print("box width: " + str(text_box.rect_size.x * 2)) #FIXME
		
		for sentence in sentences:
#			if font.get_string_size(shortened_line + sentence + ".").x < (2 * text_box.rect_size.x): #box_width:
			if len(shortened_line) + len(sentence + " ") < max_chars:
				shortened_line = shortened_line.insert(len(shortened_line), sentence + delimeter)
			else: 
				break
#		var shortened_line := line.substr(0, max_chars)
		split_apart.append(shortened_line)
		var remaining := line.substr(len(shortened_line))
		
		return _split_line(remaining, split_apart)
		
func _get_dialogue_from_array(dialogue_array : Array) -> Dictionary:
	var dict_from_array := {}
	var key = 0
	for line in dialogue_array:
		dict_from_array[key] = line
		key += 1
	return dict_from_array
	


#func test_alt_adjust_line_length(lines : Array) -> Array:
#	var new_lines = []
#	for i in lines.size():
#		var line = lines[i]
#		if not typeof(line) == TYPE_STRING:
#			line = str(line)
##		if len(line) > max_chars:
#		if font.get_string_size(line) < text_box.rect_size:
#			new_lines.append_array(test_alt_split_line(line, []))
#		else:
#			new_lines.append(line)
#	return new_lines
#
#func test_alt_split_line(line : String, split_apart : Array) -> Array:
##	if len(line) < max_chars:
#	if font.get_string_size(line) < text_box.rect_size:
#		split_apart.append(line)
#		return split_apart
#
#	else:
#		var delimeter ="."
#		var sentences = line.split(".")
#		if sentences.size() <= 1:
#			sentences = line.split(" ") #FIXME adjust for this edge case of no periods being present
#			delimeter = " "
#			if sentences.size() <= 1:
#				return split_apart
#		var shortened_line := ""
##		var box_width = (text_box.rec #.get_parent_area_size().x - ($ColorRect/MarginContainer.rect_size.x - text_box.rect_size.x)) * 2) #(margin_left + margin_right)) * 2)
#
#		print("box width: " + str(text_box.rect_size.x * 2)) #FIXME
#
#		for sentence in sentences:
##			if font.get_string_size(shortened_line + sentence + ".").x < (2 * text_box.rect_size.x): #box_width:
##			if len(shortened_line) + len(sentence + " ") < max_chars:
#			if font.get_string_size(shortened_line + sentence + delimeter) < text_box.rect_size:
#				shortened_line = shortened_line.insert(len(shortened_line), sentence + delimeter)
#			else: 
#				break
##		var shortened_line := line.substr(0, max_chars)
#		split_apart.append(shortened_line)
#		var remaining := line.substr(len(shortened_line))
#
#		return test_alt_split_line(remaining, split_apart)
