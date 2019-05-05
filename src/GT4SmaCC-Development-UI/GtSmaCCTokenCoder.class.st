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

{ #category : #accessing }
GtSmaCCTokenCoder >> badgeTypes [
	^ super badgeTypes , #(#('Method' isScannerMethod))
]

{ #category : #actions }
GtSmaCCTokenCoder >> viewTokenSimulator: anElement [
	| simulator |
	self isValid
		ifFalse: [ ^ self ].
	simulator := GtSmaCCTokenSimulator on: grammarItem.
	anElement phlow spawnObject: simulator
]
