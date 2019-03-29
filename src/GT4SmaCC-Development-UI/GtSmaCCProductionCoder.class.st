Class {
	#name : #GtSmaCCProductionCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #actions }
GtSmaCCProductionCoder >> actions [
	^ {(GtCoderAction new
		title: 'Simulate' translated;
		icon: BrGlamorousIcons debug;
		action: [ :button | self viewParserSimulator: button ];
		yourself)}
]

{ #category : #actions }
GtSmaCCProductionCoder >> viewParserSimulator: anElement [
	| simulator ui |
	simulator := GtSmaCCParserSimulator on: grammarItem.
	ui := GtSmaCCParserSimulatorElement onSimulator: simulator.
	anElement phlow spawnObject: ui
]
