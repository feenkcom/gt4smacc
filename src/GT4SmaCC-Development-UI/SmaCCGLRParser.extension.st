Extension { #name : #SmaCCGLRParser }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCGLRParser class >> analyzeAmbiguousParses: aString [
	| analysis anInteger aStream parser method |
	analysis := GtSmaCCAmbiguousAnalysis new parserClass: self.
	anInteger := self defaultStartingState.
	aStream := ReadStream on: aString.
	parser := self createParserOnStream: aStream startingAt: anInteger.
	parser
		infect: 'duplicateState
			#(12345) addDuplicatesFrom: self.
			^super duplicateState'.
	method := parser class >> #duplicateState.
	(method literalAt: 1) = #(12345)
		ifFalse: [ self error: 'Compiled method has different structure' ].
	method literalAt: 1 put: analysis.
	parser parse.
	^ analysis
]
