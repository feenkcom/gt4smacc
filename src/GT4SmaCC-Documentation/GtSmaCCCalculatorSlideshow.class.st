Class {
	#name : #GtSmaCCCalculatorSlideshow,
	#superclass : #GtSmaCCSlides,
	#category : #'GT4SmaCC-Documentation'
}

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> addEvaluationStylerTo: aSmaCCCoderElement [
	| validationStyler editorElement |
	validationStyler := self evaluationValidationStyler.
	editorElement := aSmaCCCoderElement childNamed: #editor.
	editorElement installValidatorsFor: #(+ - * / parens).
	editorElement editor
		styler:
			((GtCompositeSmaCCASTStyler forParser: SmaCCDefinitionParser)
				stylers:
					{editorElement styler.
						validationStyler})
]

{ #category : #'expressions slide' }
GtSmaCCCalculatorSlideshow >> addExpressionStylerTo: aSmaCCCoderElement [
	| validationStyler editorElement |
	validationStyler := self expressionValidationStyler.
	editorElement := aSmaCCCoderElement childNamed: #editor.
	editorElement installValidatorsFor: #(operators parens).
	editorElement editor
		styler:
			((GtCompositeSmaCCASTStyler forParser: SmaCCDefinitionParser)
				stylers:
					{editorElement styler.
						validationStyler})
]

{ #category : #'directive slide' }
GtSmaCCCalculatorSlideshow >> directiveSlideElement [
	<gtExample>
	<return: #BlElement>
	| element |
	element := self createParserCoderOn: GtSmaCCCalculatorParser.
	self addCommonExplanationTargetsFor: element.
	self
		setSource: '<number>
	: \d+ (\. \d+)?
	;
<whitespace>
	: \s+
	;
Expression
	: <number> { ''1'' source asNumber }
	| Expression ''left'' "+" Expression ''right'' { left + right }
	| Expression ''left'' "-" Expression ''right'' { left - right }
	| Expression ''left'' "*" Expression ''right'' { left * right }
	| Expression ''left'' "/" Expression ''right'' { left / right }
	| Expression ''left'' "^" Expression ''right'' { left raisedTo: right }
	| "(" Expression ")" { ''2'' }
	;'
		in: element.
	(self grammarFrom: element)
		when: GtSmaCCGrammarAnnouncement
		do: [ :annoucement | self updateDirectiveSlideToggles: element with: annoucement ]
		for: self.
	^ element
]

{ #category : #'directive slide' }
GtSmaCCCalculatorSlideshow >> directiveSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 4;
		newTextWithFormat: self directiveSlideText;
		element: [ self directiveSlideElement ];
		elementWeight: 0.6
]

{ #category : #'directive slide' }
GtSmaCCCalculatorSlideshow >> directiveSlideText [
	^ ('In the previous slide we added code to evaluate the expressions. However, you may have noticed that sometimes the evaluation returned a value you were not expecting. For example, evaluating "2 * 3 + 4" returns 14 instead of 10. This happened since the grammar we defined was ambiguous and SmaCC didn''t know how to handle these ambiguities. In this slide we will '
		asRopedText , ('add' asRopedText glamorousExplanationFor: #addButton)
		,
			' directives to our grammar to handle the operator precedence. SmaCC handles precedence with precedence directives '
				asRopedText , ('%left' asRopedText glamorousExplanationFor: #leftDirective) , ', ' asRopedText
		, ('%right' asRopedText glamorousExplanationFor: #rightDirective)
		,
			', and %nonassoc. Each directive takes a list of tokens, and the order of the rules goes from the least to greatest precedence.'
				asRopedText , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #lowestPrecedence) + BrGlamorousCheckboxAptitude new ]})
		, ' Create left precedence rule for addition and subtraction.' asRopedText , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #middlePrecedence) + BrGlamorousCheckboxAptitude new ]})
		, ' Create left precedence rule for multiplication and division.' asRopedText , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #highestPrecedence) + BrGlamorousCheckboxAptitude new ]})
		, ' Create right precedence rule for power.' asRopedText , String cr asRopedText
		, 'After adding the directives, you can ' asRopedText , ('compile' asRopedText glamorousExplanationFor: #saveButton)
		, ' the parser and ' asRopedText , ('test' asRopedText glamorousExplanationFor: #TestTab) , ' it.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> evaluationSlideElement [
	<gtExample>
	<return: #BlElement>
	| element |
	element := self createParserCoderOn: GtSmaCCCalculatorParser.
	self addCommonExplanationTargetsFor: element.
	self
		setSource: '<number>
	: \d+ (\. \d+)?
	;
<whitespace>
	: \s+
	;
Expression
	: <number> { ''1'' source asNumber }
	| Expression "+" Expression
	| Expression "-" Expression
	| Expression "*" Expression
	| Expression "/" Expression
	| Expression ''left'' "^" Expression ''right'' { left raisedTo: right }
	| "(" Expression ")"
	;'
		in: element.
	element
		enqueueTask: (BlDelayedTaskAction new
				delay: 500 milliSeconds;
				action: [ (self findItem: 'Expression' in: element)
						ifNotNil: [ :each | 
							each expand.
							self addEvaluationStylerTo: each.
							each
								addChild: ((self yellowExplanationTargetCircleFor: #Expression) relocate: 2 @ 8) ] ]).
	^ element
]

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> evaluationSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 3;
		newTextWithFormat: self evaluationSlideText;
		element: [ self evaluationSlideElement ];
		elementWeight: 0.6
]

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> evaluationSlideText [
	^ ('In the previous slide we defined a parser that recognizes our expressions. In this slide we will add  ' asRopedText
		, ('code' asRopedText glamorousExplanationFor: #code) , ' to our ' asRopedText
		, ('Expression' asRopedText glamorousExplanationFor: #Expression) , ' production. The ' asRopedText
		, ('code' asRopedText glamorousExplanationFor: #code)
		,
			' is a Smalltalk expression surrounded by braces that is evaluated when the production rule is matched. It can reference parts of the production rule by '
				asRopedText , ('naming' asRopedText glamorousExplanationFor: #variable)
		, ' the production rule parts or by using a ' asRopedText
		, ('literal string' asRopedText glamorousExplanationFor: #literalReference)
		,
			' that contains the index of that part in the production rule. Finish the code by writing the code for these expressions:'
				asRopedText , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #+) + BrGlamorousCheckboxAptitude new ]})
		, ('Addition' asRopedText glamorousExplanationFor: #+) , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #-) + BrGlamorousCheckboxAptitude new ]})
		, ('Subtraction' asRopedText glamorousExplanationFor: #-) , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #*) + BrGlamorousCheckboxAptitude new ]})
		, ('Multiplication' asRopedText glamorousExplanationFor: #*) , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #/) + BrGlamorousCheckboxAptitude new ]})
		, ('Division' asRopedText glamorousExplanationFor: #/) , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #parens) + BrGlamorousCheckboxAptitude new ]})
		, ('Parenthesized expression' asRopedText glamorousExplanationFor: #parens) , String cr asRopedText
		, 'After adding the ' asRopedText , ('code' asRopedText glamorousExplanationFor: #code) , ', you can ' asRopedText
		, ('compile' asRopedText glamorousExplanationFor: #saveButton) , ' the parser and ' asRopedText
		, ('test' asRopedText glamorousExplanationFor: #TestTab) , ' it.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> evaluationValidationStyler [
	^ (GtSmaCCParserStyler forParser: SmaCCDefinitionParser)
		stylerRules:
			{GtSmaCCNodeStylerRule
					nodeClassName: #SmaCCCodeProductionExpressionNode
					styleBlock:
						[ :styler :node :text | 
						(text from: node code startPosition - 1 to: node code startPosition - 1)
							attributes: {GtYellowCircleExplanationTextAdornment forIdentifier: #code}.
						self styleCodeValidatorsFor: node inText: text ].
				GtSmaCCNodeStylerRule
					nodeClassName: #SmaCCSymbolNode
					styleBlock:
						[ :styler :node :text | 
						(node isKindOf: SmaCCKeywordSymbolNode)
							ifTrue:
								[ | name identifier |
								name := node name source.
								name size = 3
									ifTrue:
										[ identifier := name second = $( ifTrue: [ #parens ] ifFalse: [ name second asString asSymbol ].
										(text from: (node startPosition - 1 max: 1) to: (node startPosition - 1 max: 1))
											attributes: {GtYellowCircleExplanationTextAdornment forIdentifier: identifier} ] ].
						node variableNameToken notNil
							ifTrue:
								[ (text from: node variableNameToken startPosition - 1 to: node variableNameToken startPosition - 1)
									attributes: {GtYellowCircleExplanationTextAdornment forIdentifier: #variable} ] ]}
]

{ #category : #'expressions slide' }
GtSmaCCCalculatorSlideshow >> expressionValidationStyler [
	| binaryExpressions parenExpression |
	(SmaCCDefinitionParser
		parse:
			'Expression: Expression "-" Expression | Expression "*" Expression | Expression "/" Expression | Expression "^" Expression;'
		startingAt: SmaCCDefinitionParser startingStateForProductionRule) ifNotNil: [ :ast | binaryExpressions := ast expressions ].
	(SmaCCDefinitionParser
		parse: 'Expression: "(" Expression ")";'
		startingAt: SmaCCDefinitionParser startingStateForProductionRule)
		ifNotNil: [ :ast | parenExpression := ast expressions first ].
	^ (GtSmaCCParserStyler forParser: SmaCCDefinitionParser)
		stylerRules:
			{GtSmaCCNodeStylerRule
					nodeClassName: #SmaCCProductionRuleNode
					styleBlock:
						[ :styler :node :text | 
						| index |
						(binaryExpressions allSatisfy: [ :each | node expressions includes: each ])
							ifTrue:
								[ (text from: node startPosition to: node startPosition) attributes: {GtValidatorTextAttribute new model: #operators} ].
						(index := node expressions indexOf: parenExpression) > 0
							ifTrue:
								[ (text from: (node expressions at: index) startPosition to: (node expressions at: index) startPosition)
									attributes: {GtValidatorTextAttribute new model: #parens} ] ].
				GtSmaCCNodeStylerRule
					nodeClassName: #SmaCCKeywordSymbolNode
					styleBlock:
						[ :styler :node :text | 
						| name identifier |
						name := node name source.
						name size = 3
							ifTrue:
								[ identifier := ('()' includes: name second) ifTrue: [ #parens ] ifFalse: [ name second asString asSymbol ].
								(text from: (node startPosition - 1 max: 1) to: (node startPosition - 1 max: 1))
									attributes: {GtYellowCircleExplanationTextAdornment forIdentifier: identifier} ] ]}
]

{ #category : #'expressions slide' }
GtSmaCCCalculatorSlideshow >> expressionsSlideElement [
	<gtExample>
	<return: #BlElement>
	| element |
	element := self createParserCoderOn: GtSmaCCCalculatorParser.
	self
		setSource: '<number>
	: \d+ (\. \d+)?
	;
<whitespace>
	: \s+
	;
Expression
	: <number>
	| Expression "+" Expression
	;'
		in: element.
	element
		enqueueTask: (BlDelayedTaskAction new
				delay: 500 milliSeconds;
				action: [ (self findItem: 'Expression' in: element)
						ifNotNil: [ :each | 
							| bar |
							each expand.
							self addExpressionStylerTo: each.
							each
								addChild: ((self yellowExplanationTargetCircleFor: #Expression) relocate: 2 @ 8).
							bar := each childNamed: #actionBar.
							bar children first
								addChild: ((self yellowExplanationTargetCircleFor: #simulateButton) relocate: 2 @ 8) ] ]).
	^ element
]

{ #category : #'expressions slide' }
GtSmaCCCalculatorSlideshow >> expressionsSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 2;
		newTextWithFormat: self expressionsSlideText;
		element: [ self expressionsSlideElement ];
		elementWeight: 0.6
]

{ #category : #'expressions slide' }
GtSmaCCCalculatorSlideshow >> expressionsSlideText [
	^ ('In this slide we have the tokens defined and have started the ' asRopedText
		, ('Expression' asRopedText glamorousExplanationFor: #Expression) , ' definition. Currently, it only accepts ' asRopedText
		, ('addition' asRopedText glamorousExplanationFor: #+) , '.' asRopedText , String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #operators) + BrGlamorousCheckboxAptitude new ]})
		, ' Extend the ' asRopedText , ('Expression' asRopedText glamorousExplanationFor: #Expression)
		, ' production to add ' asRopedText , ('-' asRopedText glamorousExplanationFor: #-) , ', ' asRopedText
		, ('*' asRopedText glamorousExplanationFor: #*) , ', ' asRopedText , ('/' asRopedText glamorousExplanationFor: #/)
		, ', and ' asRopedText , ('^' asRopedText glamorousExplanationFor: #'^') , ' operators.' asRopedText
		, String cr asRopedText
		,
			(' ' asRopedText
				attributes:
					{BrTextAdornmentDynamicAttribute new
							stencil:
								[ (BrCheckbox new)
									disable;
									aptitude: (GtCheckedValidatorTargetAptitude new model: #parens) + BrGlamorousCheckboxAptitude new ]})
		, ' Add a ' asRopedText , ('parenthesized' asRopedText glamorousExplanationFor: #parens)
		, ' expression to the ' asRopedText , ('Expression' asRopedText glamorousExplanationFor: #Expression)
		, ' production.' asRopedText , String cr asRopedText , 'You can test the ' asRopedText
		, ('Expression' asRopedText glamorousExplanationFor: #Expression)
		, ' production without compiling by using the ' asRopedText
		, ('debug' asRopedText glamorousExplanationFor: #simulateButton) , ' button.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> isValidNumberToken: aGrammar [
	| item simulator ruleName |
	ruleName := '<number>'.
	item := aGrammar ruleNamed: ruleName.
	item isNil ifTrue: [ ^ false ].
	aGrammar isValid ifFalse: [ ^ false ].
	simulator := self createTokenSimulatorFor: ruleName from: aGrammar.
	simulator isNil ifTrue: [ ^ false ].
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

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> isValidWhitespaceToken: aGrammar [
	| item simulator whitespace ruleName |
	ruleName := '<whitespace>'.
	item := aGrammar ruleNamed: ruleName.
	item isNil ifTrue: [ ^ false ].
	aGrammar isValid ifFalse: [ ^ false ].
	simulator := self createTokenSimulatorFor: ruleName from: aGrammar.
	simulator isNil ifTrue: [ ^ false ].
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

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> numberTokenSlideElement [
	<gtExample>
	<return: #BlElement>
	| element |
	element := self createParserCoderOn: GtSmaCCCalculatorParser.
	self
		setSource: 'Expression
	: <number>
	;'
		in: element.
	(self grammarFrom: element)
		when: GtSmaCCGrammarItemChanged
			do: [ :annoucement | self updateNumberSlideToggles: element with: annoucement ];
		when: GtSmaCCGrammarRulesChanged
			do: [ :annoucement | self updateTokenTargetsIn: element ].
	element
		enqueueTask: (BlDelayedTaskAction new
				delay: 500 milliSeconds;
				action: [ (self findItem: 'Expression' in: element) ifNotNil: [ :each | each expand ] ]).
	^ element
]

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> numberTokenSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 1;
		newTextWithFormat: self numberTokenSlideText;
		element: [ self numberTokenSlideElement ];
		elementWeight: 0.6
]

{ #category : #'number token slide' }
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

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> runSimulator: simulator with: aString [
	simulator
		matchesOn: aString
		do:
			[ :i :nodes | 
			nodes isNil ifTrue: [ ^ false ].
			i = aString size ifTrue: [ ^ nodes anySatisfy: [ :each | each isTokenRule ] ] ].
	^ false
]

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> styleCodeValidatorsFor: node inText: text [
	| source ast |
	source := node code source copyFrom: 2 to: node code source size - 1.
	ast := RBParser parseExpression: source onError: [ :e :p | ^ self ].
	ast
		nodesDo:
			[ :each | 
			(each isLiteralNode
				and: [ each value isString and: [ each value isAllDigits and: [ each value asNumber between: 1 and: node terms size ] ] ])
				ifTrue:
					[ (text from: node code startPosition + each start - 1 to: node code startPosition + each start - 1)
						attributes: {GtYellowCircleExplanationTextAdornment forIdentifier: #literalReference} ] ].
	node terms size = 3 ifFalse: [ ^ self ].
	(ast isMessage and: [ ast isBinary ])
		ifTrue:
			[ (node terms first name source = 'Expression'
				and:
					[ node terms last name source = 'Expression'
						and:
							[ node terms second name source = ('"' , ast selector , '"')
								and:
									[ (self
										validate: ast receiver
										is: node terms first variableName
										or: '1')
										and:
											[ self
												validate: ast arguments first
												is: node terms last variableName
												or: '3' ] ] ] ])
				ifTrue:
					[ (text from: node startPosition to: node startPosition) attributes: {GtValidatorTextAttribute new model: ast selector} ] ].
	(ast isVariable or: [ ast isLiteralNode ])
		ifTrue:
			[ (node terms first name source = '"("'
				and:
					[ node terms last name source = '")"'
						and:
							[ node terms second name source = 'Expression'
								and:
									[ self
										validate: ast
										is: node terms second variableName
										or: '2' ] ] ])
				ifTrue:
					[ (text from: node startPosition to: node startPosition) attributes: {GtValidatorTextAttribute new model: #parens} ] ]
]

{ #category : #'directive slide' }
GtSmaCCCalculatorSlideshow >> updateDirectiveSlideToggles: anElement with: anAnnouncement [
	anElement
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action:
						[ | index |
							index := 1.
							(anElement explainer firstExplanationHolderParent explainer)
								updateValidatorTargetsOf: #lowestPrecedence to: false;
								updateValidatorTargetsOf: #middlePrecedence to: false;
								updateValidatorTargetsOf: #highestPrecedence to: false.
							(self directivesIn: anElement)
								do:
									[ :each | 
									| targetName |
									targetName := (each coder directiveName , 'Directive') asSymbol.
									each childNamed: #directiveTarget ifFound: [ :element | element removeFromParent ].
									each addChild: ((self yellowExplanationTargetCircleFor: targetName) relocate: 2 @ 8) as: #directiveTarget.
									index = 1
										ifTrue:
											[ each coder directiveName = 'left'
												ifTrue:
													[ (each coder grammarItem ast symbols collect: [ :node | node name source ]) asSortedCollection asArray = #('"+"' '"-"')
														ifTrue:
															[ anElement explainer firstExplanationHolderParent explainer updateValidatorTargetsOf: #lowestPrecedence to: true ] ] ].
									index = 2
										ifTrue:
											[ each coder directiveName = 'left'
												ifTrue:
													[ (each coder grammarItem ast symbols collect: [ :node | node name source ]) asSortedCollection asArray = #('"*"' '"/"')
														ifTrue:
															[ anElement explainer firstExplanationHolderParent explainer updateValidatorTargetsOf: #middlePrecedence to: true ] ] ].
									index = 3
										ifTrue:
											[ each coder directiveName = 'right'
												ifTrue:
													[ (each coder grammarItem ast symbols collect: [ :node | node name source ]) asArray = #('"^"')
														ifTrue:
															[ anElement explainer firstExplanationHolderParent explainer updateValidatorTargetsOf: #highestPrecedence to: true ] ] ].
									(#('left' 'right' 'nonassoc') includes: each coder directiveName) ifTrue: [ index := index + 1 ] ] ])
]

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> updateNumberSlideToggles: anElement with: anAnnouncement [
	anAnnouncement item isTokenRule ifFalse: [ ^ self ].
	self validateNumber: anAnnouncement grammar in: anElement.
	self validateWhitespace: anAnnouncement grammar in: anElement.
	self updateTokenTargetsIn: anElement
]

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> updateTokenTargetsIn: anElement [
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

{ #category : #'evaluation slide' }
GtSmaCCCalculatorSlideshow >> validate: node is: variableName or: literalValue [
	node isVariable ifTrue: [ ^ node name = variableName ].
	node isLiteralNode ifFalse: [ ^ false ].
	^ node value = literalValue
]

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> validateNumber: aGrammar in: anElement [
	anElement explainer firstExplanationHolderParent explainer
		updateValidatorTargetsOf: #number
		to: (self isValidNumberToken: aGrammar)
]

{ #category : #'number token slide' }
GtSmaCCCalculatorSlideshow >> validateWhitespace: aGrammar in: anElement [
	anElement explainer firstExplanationHolderParent explainer
		updateValidatorTargetsOf: #whitespace
		to: (self isValidWhitespaceToken: aGrammar)
]
