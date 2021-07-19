extends Node
class_name ConferenceScript


var q1 = false
var q2 = false
var q3 = false

# `export` our variables and quick documentation about them on hover
var variables = [
	'q1',
	'q2',
	'q3',
]
var varTooltips = [
	'Asked Q1',
	'Asked Q2',
	'Asked Q3'
]

#====> FUNCTIONS
func asked(name):
	set(name, true)
	
	print("Changed " + name)


func asked_all():
	return q1 and q2 and q3


# `export` our functions and documentation about them! 
var functions = [
	'asked("question")',
	'asked_all()'
]

var functionDocs = [
	'Change the variable to remember the player asked the question.',
	'Check if all the questions were asked by the player.'
]
