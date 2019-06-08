Class {
	#name : #GtSmaCCParserStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'stylerRules',
		'parserClass',
		'startingState'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #instances }
GtSmaCCParserStyler class >> cppStyler: aParserClass [
	<smaccStyler: #CPPParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCTokenStylerRule
				tokenName: '";"'
				styleBlock: [ :styler | 
					styler
						foreground: Color black;
						bold ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #CPPLiteralNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> csharpStyler: aParserClass [
	<smaccStyler: #CSharpParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCTokenStylerRule
				tokenName: '";"'
				styleBlock: [ :styler | 
					styler
						foreground: Color black;
						bold ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #CSLiteralExpressionNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #CSAttributeNode
				styleBlock: [ :styler | styler bold ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> delphiStyler: aParserClass [
	<smaccStyler: #DelphiParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCTokenStylerRule
				tokenName: '<semicolon>'
				styleBlock: [ :styler | 
					styler
						foreground: Color black;
						bold ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #DelphiLiteralExpressionNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #'instance creation' }
GtSmaCCParserStyler class >> forParser: aSmaCCParserClass [
	^ self new
		parserClass: aSmaCCParserClass;
		yourself
]

{ #category : #instances }
GtSmaCCParserStyler class >> javaStyler: aParserClass [
	<smaccStyler: #JavaParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCTokenStylerRule
				tokenName: '";"'
				styleBlock: [ :styler | 
					styler
						foreground: Color black;
						bold ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #JavaLiteralNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #JavaAnnotationNode
				styleBlock: [ :styler | styler bold ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> jsStyler: aParserClass [
	<smaccStyler: #JSParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCTokenStylerRule
				tokenName: '<semicolon>'
				styleBlock: [ :styler | 
					styler
						foreground: Color black;
						bold ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #JSLiteralNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #JSThisExpressionNode
				styleBlock: [ :styler | styler italic ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #JSArrayLiteralNode
				variableNames: #(expressions)
				styleBlock: [ :styler | styler italic ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> jsonStyler: aParserClass [
	<smaccStyler: #JSONParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCNodeStylerRule
				nodeClassName: #JSONLiteralNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #JSONMemberNode
				variableNames: #(name)
				styleBlock: [ :styler | styler foreground: Color purple ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #JSONObjectNode
				variableNames: #(leftBrace rightBrace commas)
				styleBlock: [ :styler | styler bold ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #JSONArrayNode
				variableNames: #(leftBracket rightBracket commas)
				styleBlock: [ :styler | styler bold ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> smaccStyler: aParserClass [
	"This is a generic styler that does a little formatting for any parser"

	<smaccStyler: #SmaCCParser priority: 1000>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #accessing }
GtSmaCCParserStyler >> addStylerRule: aStylerRule [
	self stylerRules add: aStylerRule.
	aStylerRule initializeForParser: parserClass
]

{ #category : #private }
GtSmaCCParserStyler >> ast [
	^ parserClass
		parseWithErrors: text asString
		startingAt: self startingState
]

{ #category : #accessing }
GtSmaCCParserStyler >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtSmaCCParserStyler >> parserClass: aSmaCCParserClass [
	parserClass := aSmaCCParserClass
]

{ #category : #private }
GtSmaCCParserStyler >> privateStyle: aText [
	[ text := aText.
	self styleAST: self ast ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]

{ #category : #accessing }
GtSmaCCParserStyler >> startingState [
	^ startingState ifNil: [ parserClass defaultStartingState ]
]

{ #category : #accessing }
GtSmaCCParserStyler >> startingState: anInteger [
	startingState := anInteger
]

{ #category : #styling }
GtSmaCCParserStyler >> style: aText using: anAST [
	text := aText.
	self styleAST: anAST.
	^ text
]

{ #category : #private }
GtSmaCCParserStyler >> styleAST: anAST [
	anAST
		withAllNodesDo: [ :node | self styleNode: node ]
		andTokensDo: [ :token | self styleToken: token ]
		includesErrors: true
]

{ #category : #private }
GtSmaCCParserStyler >> styleNode: aSmaCCParseNode [
	stylerRules
		do: [ :each | 
			(each shouldApplyToNode: aSmaCCParseNode)
				ifTrue: [ ^ each applyTo: aSmaCCParseNode on: text ] ]
]

{ #category : #private }
GtSmaCCParserStyler >> styleToken: aSmaCCToken [
	stylerRules
		do: [ :each | 
			(each shouldApplyToToken: aSmaCCToken)
				ifTrue: [ ^ each applyTo: aSmaCCToken on: text ] ]
]

{ #category : #accessing }
GtSmaCCParserStyler >> stylerRules [
	^ stylerRules ifNil: [ stylerRules := OrderedCollection new ]
]

{ #category : #accessing }
GtSmaCCParserStyler >> stylerRules: aCollection [
	stylerRules := aCollection asOrderedCollection.
	stylerRules do: [ :each | each initializeForParser: parserClass ]
]
