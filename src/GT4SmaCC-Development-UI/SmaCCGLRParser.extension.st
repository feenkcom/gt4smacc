Extension { #name : #SmaCCGLRParser }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCGLRParser class >> ambiguousAnalysis [
	| analysis parser |
	analysis := GtSmaCCAmbiguousAnalysis new parserClass: self.
	parser := self new.
	parser scanner: parser class scannerClass new.
	(parser shortestPathsFrom: 1)
		keysAndValuesDo: [ :state :stack | 
			1
				to: self symbolNames size
				do: [ :id | 
					| actions |
					actions := OrderedCollection new.
					parser
						addActionsForState: state
						symbol: id
						to: actions.
					actions size > 1
						ifTrue: [ analysis
								addDuplicatesFrom: (parser
										stateStack: (OrderedCollection withAll: stack);
										currentToken: (SmaCCToken
												value: ''
												start: 0
												ids: {id});
										yourself) ] ] ].
	^ analysis
]

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
