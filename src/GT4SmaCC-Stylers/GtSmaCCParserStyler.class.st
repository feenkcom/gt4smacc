Class {
	#name : #GtSmaCCParserStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'stylerRules',
		'completions',
		'parserClass'
	],
	#category : #'GT4SmaCC-Stylers'
}

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
				tokenName: '";""'
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
				nodeClassName: #SmaCCError
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
				nodeClassName: #SmaCCError
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
				nodeClassName: #SmaCCError
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
				nodeClassName: #SmaCCError
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
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
	[ completions := GtPrefixTree new.
	text := aText.
	(parserClass parseWithErrors: aText asString)
		withAllNodesDo: [ :node | self styleNode: node ]
		andTokensDo: [ :token | self styleToken: token ]
		includesErrors: true ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
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
	completions add: aSmaCCToken value.
	stylerRules
		do: [ :each | 
			(each shouldApplyToToken: aSmaCCToken)
				ifTrue: [ ^ each applyTo: aSmaCCToken on: text ] ]
]

{ #category : #accessing }
GtSmaCCParserStyler >> stylerRules [
	^ stylerRules
]

{ #category : #accessing }
GtSmaCCParserStyler >> stylerRules: aCollection [
	stylerRules := aCollection.
	stylerRules do: [ :each | each initializeForParser: parserClass ]
]
