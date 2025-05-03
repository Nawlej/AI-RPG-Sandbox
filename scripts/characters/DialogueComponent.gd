extends Node

@export var dialogue_lines: Array[String] = [
	"Hello, traveler.",
	"The road ahead is dangerous."
]

var current_line = 0

func start_dialogue():
	current_line = 0
	show_current_line()

func show_current_line():
	print(dialogue_lines[current_line])

func next():
	current_line += 1
	if current_line < dialogue_lines.size():
		show_current_line()
	else:
		end_dialogue()

func end_dialogue():
	print("End of conversation.")
