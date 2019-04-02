Class {
	#name : #GtSmaCCTokenCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #actions }
GtSmaCCTokenCoder >> actions [
	^ {(GtCoderAction new
		title: 'Simulate' translated;
		icon: BrGlamorousIcons debug;
		action: [ :button | self viewTokenSimulator: button ];
		yourself)}
]

{ #category : #actions }
GtSmaCCTokenCoder >> viewTokenSimulator: anElement [
	| simulator |
	simulator := GtSmaCCTokenSimulator on: grammarItem.
	anElement phlow spawnObject: simulator
]
