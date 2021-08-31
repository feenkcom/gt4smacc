Class {
	#name : 'GtSmaCCCalculatorSlideshow',
	#superclass : 'GtSmaCCSlides',
	#category : 'GT4SmaCC-Documentation'
}

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> isValidNumberToken: aGrammar [
	| item simulator ruleName |
	ruleName := '<number>'.
	item := aGrammar ruleNamed: ruleName.
	item isNil ifTrue: [ ^ false ].
	aGrammar isValid ifFalse: [ ^ false ].
	simulator := self createTokenSimulatorFor: ruleName from: aGrammar.
	0
		to: 255
		do:
			[ :i | 
			| char |
			char := Character value: i.
			char isDigit
				ifTrue:
					[ (self runSimulator: simulator with: char asString) ifFalse: [ ^ false ].
					(self runSimulator: simulator with: '1.' , char asString) ifFalse: [ ^ false ].
					(self runSimulator: simulator with: '1.2' , char asString) ifFalse: [ ^ false ] ]
				ifFalse:
					[ (self runSimulator: simulator with: char asString) ifTrue: [ ^ false ].
					(self runSimulator: simulator with: '1.' , char asString) ifTrue: [ ^ false ].
					(self runSimulator: simulator with: '1.2' , char asString) ifTrue: [ ^ false ] ] ].
	(self runSimulator: simulator with: '1234567890') ifFalse: [ ^ false ].
	(self runSimulator: simulator with: '1234567890.0987654321') ifFalse: [ ^ false ].
	(self runSimulator: simulator with: '1.2.3') ifTrue: [ ^ false ].
	(self runSimulator: simulator with: '.1') ifTrue: [ ^ false ].
	^ true
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> isValidWhitespaceToken: aGrammar [
	| item simulator whitespace ruleName |
	ruleName := '<whitespace>'.
	item := aGrammar ruleNamed: ruleName.
	item isNil ifTrue: [ ^ false ].
	aGrammar isValid ifFalse: [ ^ false ].
	simulator := self createTokenSimulatorFor: ruleName from: aGrammar.
	whitespace := ' 	' , String crlf.
	0
		to: 255
		do:
			[ :i | 
			| char |
			char := Character value: i.
			(char isSeparator or: [ char asInteger = 11 ])
				ifFalse:
					[ (self runSimulator: simulator with: char asString) ifTrue: [ ^ false ].
					(self runSimulator: simulator with: whitespace , char asString) ifTrue: [ ^ false ].
					(self runSimulator: simulator with: whitespace , char asString , whitespace) ifTrue: [ ^ false ].
					(self runSimulator: simulator with: char asString , whitespace) ifTrue: [ ^ false ] ] ].
	(self runSimulator: simulator with: whitespace) ifFalse: [ ^ false ].
	^ true
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> numberTokenSlideElement [
	<gtExample>
	
	| element |
	element := self createParserCoderOn: GtSmaCCCalculatorParser.
	self
		setSource:
			'Expression
	: <number>
	;'
		in: element.
	(self grammarFrom: element)
		when: GtSmaCCGrammarItemChanged do: [ :annoucement | self updateNumberSlideToggles: element with: annoucement ];
		when: GtSmaCCGrammarRulesChanged do: [ :annoucement | self updateTargetsIn: element ].
	element
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action: [ (self findItem: 'Expression' in: element) ifNotNil: [ :each | each expand ] ]).
	^ element
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> numberTokenSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 21;
		newTextWithFormat: self numberTokenSlideText;
		element: [ self numberTokenSlideElement ];
		elementWeight: 0.6
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> numberTokenSlideText [
	^ ('In these slides we will be creating a simple calculator parser. We will start by creating a simple parser that parses a number that could potentially have whitespace around it.'
		asRopedText , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #number) + BrGlamorousCheckboxAptitude new ]})
		, ' Define a ' asRopedText , ('<number>' asRopedText glamorousExplanationFor: #numberToken)
		, ' token that accepts one or more digits followed by an optional decimal point and one or more digits.' asRopedText
		, String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #whitespace) + BrGlamorousCheckboxAptitude new ]})
		, ' Define a ' asRopedText , ('<whitespace>' asRopedText glamorousExplanationFor: #whitespaceToken)
		, ' token that accepts one or more whitespace characters (space, new line, etc.).' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> runSimulator: simulator with: aString [
	simulator
		matchesOn: aString
		do:
			[ :i :nodes | 
			nodes isNil ifTrue: [ ^ false ].
			i = aString size ifTrue: [ ^ nodes anySatisfy: [ :each | each isTokenRule ] ] ].
	^ false
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> updateNumberSlideToggles: anElement with: anAnnouncement [
	anAnnouncement item isTokenRule ifFalse: [ ^ self ].
	self validateNumber: anAnnouncement grammar in: anElement.
	self validateWhitespace: anAnnouncement grammar in: anElement.
	self updateTargetsIn: anElement
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> updateTargetsIn: anElement [
	anElement
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action:
						[ (self findItem: '<whitespace>' in: anElement)
								ifNil: [ anElement childNamed: #whitespaceToken ifFound: [ :element | element removeFromParent ] ]
								ifNotNil:
									[ :each | 
									each
										childNamed: #whitespaceToken
										ifFound: [ :e |  ]
										ifNone:
											[ each addChild: ((self yellowExplanationTargetCircleFor: #whitespaceToken) relocate: 2 @ 8) as: #whitespaceToken ] ].
							(self findItem: '<number>' in: anElement)
								ifNil: [ anElement childNamed: #numberToken ifFound: [ :element | element removeFromParent ] ]
								ifNotNil:
									[ :each | 
									each
										childNamed: #numberToken
										ifFound: [ :e |  ]
										ifNone: [ each addChild: ((self yellowExplanationTargetCircleFor: #numberToken) relocate: 2 @ 8) as: #numberToken ] ] ])
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> validateNumber: aGrammar in: anElement [
	anElement explainer firstExplanationHolderParent explainer
		updateValidatorTargetsOf: #number
		to: (self isValidNumberToken: aGrammar)
]

{ #category : 'number token slide' }
GtSmaCCCalculatorSlideshow >> validateWhitespace: aGrammar in: anElement [
	anElement explainer firstExplanationHolderParent explainer
		updateValidatorTargetsOf: #whitespace
		to: (self isValidWhitespaceToken: aGrammar)
]
