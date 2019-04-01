Class {
	#name : #GtSmaCCParserSimulator,
	#superclass : #GtSmaCCSimulator,
	#category : #'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #private }
GtSmaCCParserSimulator >> buildSimulator [
	simulator := SmaCCParserSimulator on: self grammar source.
	simulator setupFor: self ruleName
]

{ #category : #running }
GtSmaCCParserSimulator >> simulateOn: aString [
	[ | results |
	results := simulator simulateParse: aString.
	self
		announce: (GtSmaCCParserSimulationAccept input: aString results: results) ]
		on: SmaCCParserSimulationError
		do: [ :ex | 
			self
				announce:
					(ex isInputIncomplete
						ifTrue: [ GtSmaCCParserSimulationIncompleteInput
								input: aString
								stack: ex nodeStack ]
						ifFalse: [ GtSmaCCParserSimulationError
								input: aString
								stack: ex nodeStack
								token: ex token ]) ]
]

{ #category : #accessing }
GtSmaCCParserSimulator >> symbolNameFor: anInteger [
	anInteger = 0
		ifTrue: [ ^ nil ].
	^ (simulator symbolForId: anInteger) name
]
