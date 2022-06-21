extends Node2D

onready var text_bubble = $ResizableSpeechBubble/RichTextLabel
onready var text_margin = $ResizableSpeechBubble
onready var font = text_bubble.get_font("normal_font")
onready var left_line =$LeftLine2D
onready var right_line = $RightLine2D2
onready var color_rect = $ResizableSpeechBubble/ColorRect

export var bubble_color : Color

## The line that the speech bubble will hold
## Only temporary as eventually this will be loaded from a file or otherwise loaded dynamically 
##Should be no more than 250 characters at the absolute most
export var speech : String = "Did you hear what happened at the castle?" #"oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooggers A more realistic long bit of text that i might actually use since its just going to be scrolling anyways despite my efforts to make it grow and now im just writing words"

func _ready():
	if not is_in_group("Speech_Bubbles"):
		add_to_group("Speech_Bubbles")
	set_box_color()
	text_bubble.bbcode_text = speech
	var string_size = font.get_wordwrap_string_size(speech, min(font.get_string_size(speech).x, 150)) #font.get_string_size(text_bubble.bbcode_text).x
	text_margin.rect_size = Vector2(string_size.x, string_size.y * 1.25)
	left_line.points[1].y = text_margin.rect_position.y + (text_margin.rect_size.y / 2)
	left_line.points[1].x = text_margin.rect_position.x
	right_line.points[1].y = text_margin.rect_position.y + text_margin.rect_size.y
	right_line.points[1].x = text_margin.rect_position.x + (text_margin.rect_size.x / 2)
	font.get_string_size(text_bubble.bbcode_text)
	
func set_box_color():
	left_line.default_color = bubble_color
	right_line.default_color = bubble_color
	color_rect.color = Color(bubble_color.r, bubble_color.g, bubble_color.b, 0.1)
	
