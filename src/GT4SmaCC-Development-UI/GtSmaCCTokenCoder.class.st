Class {
	#name : 'GtSmaCCTokenCoder',
	#superclass : 'GtSmaCCCoder',
	#category : 'GT4SmaCC-Development-UI-Coders'
}

{ #category : 'actions' }
GtSmaCCTokenCoder >> actions [
	^ {(GtCoderAction new
		title: 'Simulate' translated;
		icon: BrGlamorousVectorIcons debug;
		action: [ :button | self viewTokenSimulator: button ];
		yourself)}
]

{ #category : 'accessing' }
GtSmaCCTokenCoder >> badgeTypes [
	^ super badgeTypes , #(#('Method' isScannerMethod))
]

{ #category : 'accessing' }
GtSmaCCTokenCoder >> collapsedText [
	| text |
	text := self name asRopedText.
	GtSmaCCStyler formatTokenDefinition: text.
	^ text
]

{ #category : 'actions' }
GtSmaCCTokenCoder >> viewTokenSimulator: anElement [
	| simulator |
	self isValid
		ifFalse: [ ^ self ].
	simulator := GtSmaCCTokenSimulator on: grammarItem.
	anElement phlow spawnObject: simulator
]
