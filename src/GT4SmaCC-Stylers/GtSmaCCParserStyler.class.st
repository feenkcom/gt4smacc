Class {
	#name : #GtSmaCCParserStyler,
	#superclass : #GtSmaCCASTStyler,
	#instVars : [
		'stylerRules'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #instances }
GtSmaCCParserStyler class >> clojureStyler: aParserClass [
	<smaccStyler: #ClojureParser priority: 50>
	| colors |
	colors := BrGlamorousColors distinctTenStrongColors allButFirst	"remove red"
		collect: [ :each | each twiceDarker ].
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #ClojureDiscardNode
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #ClojureMetadataNode
				styleBlock:
					[ :styler :node :text | (text from: node startPosition to: node metadata stopPosition) bold ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #ClojureStringNode
				styleBlock: [ :styler | styler foreground: Color blue muchDarker ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #ClojureLiteralNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #ClojureListNode
				styleBlock: [ :styler :node :text | 
					| color |
					color := colors at: (node listDepth - 1) \\ colors size + 1.
					(text from: node startPosition to: node startPosition)
						foreground: color.
					(text from: node stopPosition to: node stopPosition)
						foreground: color.
					(node expressions notEmpty
						and: [ node isQuoted not
								and: [ (node expressions first isKindOf: ClojureSymbolNode)
										and: [ node isDiscarded not ] ] ])
						ifTrue: [ (text
								from: node expressions first startPosition
								to: node expressions first stopPosition)
								foreground: Color purple ] ])}
]

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
GtSmaCCParserStyler class >> cssStyler: aParserClass [
	<smaccStyler: #CSSParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules: {GtSmaCCCommentStylerRule
					styleBlock: [ :styler | styler foreground: Color lightGray ].
				GtSmaCCTokenStylerRule
					tokenName: '";"'
					styleBlock: [ :styler | 
						styler
							foreground: Color black;
							bold ].
				GtSmaCCNodeStylerRule
					nodeClassName: #CSSValueNode
					styleBlock: [ :styler | styler foreground: Color blue ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #CSSDeclarationNode
					variableNames: #(name)
					styleBlock: [ :styler | styler foreground: Color purple ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #SmaCCErrorNode
					variableNames: #(dismissedTokens errorToken)
					styleBlock: [ :styler | styler foreground: Color red ]}
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

{ #category : #instances }
GtSmaCCParserStyler class >> graphQLStyler: aParserClass [
	<smaccStyler: #GraphQLParser priority: 50>
	| colors |
	colors := BrGlamorousColors distinctTenStrongColors allButFirst
			collect: [ :each | each twiceDarker ].	"remove red"
	^ (self forParser: aParserClass)
		stylerRules: {GtSmaCCCommentStylerRule
					styleBlock: [ :styler | styler foreground: Color lightGray ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #GraphQLFieldNode
					variableNames: #(name)
					styleBlock: [ :styler :token | token source = '__typename' ifTrue: [ styler foreground: Color lightGray ] ].
				GtSmaCCNodeStylerRule
					nodeClassName: #GraphQLLiteralNode
					styleBlock: [ :styler | styler foreground: Color blue ].
				GtSmaCCNodeStylerRule
					nodeClassName: #GraphQLTypeNode
					styleBlock: [ :styler | styler foreground: Color blue muchDarker ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #GraphQLArgumentNode
					variableNames: #(name)
					styleBlock: [ :styler | styler foreground: Color brown darker ].
				(GtSmaCCNodeVariableStylerRule
					nodeClassName: #GraphQLOperationDefinitionNode
					variableNames: #(name)
					styleBlock: [ :styler | styler foreground: Color cyan muchDarker ])
					continueOnMatch: true.
				GtSmaCCNodeStylerRule
					nodeClassName: #GraphQLVariableNode
					styleBlock: [ :styler | styler foreground: Color purple ].
				(GtSmaCCNodeVariableStylerRule
					nodeClassName: #GraphQLDirectiveNode
					variableNames: #(name atToken)
					styleBlock: [ :styler | styler foreground: Color green muchDarker ])
					continueOnMatch: true.
				GtSmaCCKeywordTokensStylerRule
					styleBlock: [ :styler | 
						styler
							bold;
							foreground: Color purple ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #SmaCCErrorNode
					variableNames: #(dismissedTokens errorToken)
					styleBlock: [ :styler | styler foreground: Color red ].
				GtSmaCCNodeStylerRule
					nodeClassName: #GraphQLProgramNode
					styleBlock: [ :styler :node :text | 
						(node respondsTo: #description)
							ifTrue: [ (text from: node description startPosition to: node description stopPosition)
									foreground: Color lightGray ].
						(node respondsTo: #leftParen)
							ifTrue: [ self
									highlightParentheses: text
									left: node leftParen
									right: node rightParen ].
						(node respondsTo: #leftBracket)
							ifTrue: [ self
									highlightParentheses: text
									left: node leftBracket
									right: node rightBracket ].
						(node respondsTo: #leftBrace)
							ifTrue: [ | color parents |
								self
									highlightParentheses: text
									left: node leftBrace
									right: node rightBrace.
								parents := node allParents
										select: [ :each | each respondsTo: #leftBrace ].
								color := colors at: parents size \\ colors size + 1.
								(text from: node leftBrace startPosition to: node leftBrace stopPosition)
									foreground: color.
								(text
									from: node rightBrace startPosition
									to: node rightBrace stopPosition) foreground: color ] ]}
]

{ #category : #view }
GtSmaCCParserStyler class >> gtStylerMethodsFor: aView [
	<gtView>
	^ aView list
		title: 'Stylers';
		items: [ (Pragma allNamed: #smaccStyler:priority: in: self class) collect: #method ];
		sendTool: [ :aMethod | GtMethodCoderTool compiledMethod: aMethod  ]
]

{ #category : #private }
GtSmaCCParserStyler class >> highlightParentheses: aText left: leftToken right: rightToken [
	| theParanthesesMarker cursorEnterAction cursorLeaveAction leftIndex rightIndex |
	(leftToken isNil or: [ rightToken isNil ]) ifTrue: [ ^ self ].
	leftIndex := leftToken startPosition.
	rightIndex := rightToken stopPosition.
	(leftIndex isNil or: [ rightIndex isNil or: [ leftIndex >= rightIndex ] ])
		ifTrue: [ ^ self ].
	theParanthesesMarker := BrTextInvisibleMarkerAttribute new.
	aText
		attribute: theParanthesesMarker
		from: leftIndex + 1
		to: rightIndex - 1.

	cursorEnterAction := [ :aTextEditor | 
		aTextEditor text
			findAttribute: theParanthesesMarker
			indicesDo: [ :aParanthesesStart :aParanthesesEnd | 
				aTextEditor text
					attribute: (GtPharoParenthesesHighlightAttribute
							paint: BrGlamorousColors neutralBackgroundColor)
					from: aParanthesesStart
					to: aParanthesesEnd ] ].

	cursorLeaveAction := [ :aTextEditor | 
		aTextEditor text
			findAttribute: theParanthesesMarker
			indicesDo: [ :aParanthesesStart :aParanthesesEnd | 
				(aTextEditor text from: aParanthesesStart to: aParanthesesEnd)
					clearAttributesOfClass: GtPharoParenthesesHighlightAttribute ] ].

	(aText from: leftIndex to: leftIndex)
		onCursorEnter: cursorEnterAction
		leave: cursorLeaveAction.

	(aText from: rightIndex - 1 to: rightIndex - 1)
		onCursorEnter: cursorEnterAction
		leave: cursorLeaveAction
]

{ #category : #accessing }
GtSmaCCParserStyler class >> itself [
	<gtExample>
	^ self
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
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> pythonStyler: aParserClass [
	<smaccStyler: #PythonParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules: {GtSmaCCKeywordTokensStylerRule
					styleBlock: [ :styler | 
						styler
							bold;
							foreground: Color purple ].
				GtSmaCCCommentStylerRule
					styleBlock: [ :styler | styler foreground: Color lightGray ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #PyVariableExpressionNode
					variableNames: #(nameToken)
					styleBlock: [ :styler | styler foreground: Color blue muchDarker ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #PyStringNode
					variableNames: #(parts)
					styleBlock: [ :styler | styler foreground: Color blue ].
				GtSmaCCNodeStylerRule
					nodeClassName: #PyNumberNode
					styleBlock: [ :styler | styler foreground: Color blue ].
				GtSmaCCNodeStylerRule
					nodeClassName: #PyDecoratorExpressionNode
					styleBlock: [ :styler | styler bold ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #SmaCCErrorNode
					variableNames: #(dismissedTokens errorToken)
					styleBlock: [ :styler | styler foreground: Color red ]}
]

{ #category : #instances }
GtSmaCCParserStyler class >> rubyStyler: aParserClass [
	<smaccStyler: #RubyParser priority: 50>
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
				nodeClassName: #RubyNumberNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #RubySymbolNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #RubyStringNode
				variableNames: #(parts)
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> rustStyler: aParserClass [
	<smaccStyler: #RustParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
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
				nodeClassName: #RustLiteralExpressionNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #RustAttributeNode
				styleBlock: [ :styler | styler foreground: Color green muchDarker ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #RustTypePathNode
				styleBlock: [ :styler | styler foreground: Color blue muchDarker ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #RustFunctionNode
				variableNames: #(name)
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

{ #category : #instances }
GtSmaCCParserStyler class >> teradataStyler: aParserClass [
	<smaccStyler: #TeradataParser priority: 50>
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
				nodeClassName: #TeradataLiteralExpressionNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> vbnetStyler: aParserClass [
	<smaccStyler: #VBNetParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules:
			{(GtSmaCCKeywordTokensStylerRule
				styleBlock: [ :styler | 
					styler
						bold;
						foreground: Color purple ]).
			(GtSmaCCCommentStylerRule
				styleBlock: [ :styler | styler foreground: Color lightGray ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #VBNetLiteralNode
				styleBlock: [ :styler | styler foreground: Color blue ]).
			(GtSmaCCNodeStylerRule
				nodeClassName: #VBNetAttributeBlockNode
				styleBlock: [ :styler | styler bold ]).
			(GtSmaCCNodeVariableStylerRule
				nodeClassName: #SmaCCErrorNode
				variableNames: #(dismissedTokens errorToken)
				styleBlock: [ :styler | styler foreground: Color red ])}
]

{ #category : #instances }
GtSmaCCParserStyler class >> yamlAliasExpanderStyler: aParserClass [
	<smaccStyler: #YAMLParser priority: 500>
	^ (self forParser: aParserClass)
		stylerRules: {GtSmaCCNodeStylerRule
					nodeClassName: #YAMLAliasNode
					styleBlock: [ :styler :node :text | 
						node anchorSourceInterval
							ifNotNil: [ :interval | 
								| source |
								source := interval last <= text size
										ifTrue: [ text copyFrom: interval first to: interval last ]
										ifFalse: [ node completeSource asString copyFrom: interval first to: interval last ].
								text
									attribute: (BrGlamorousTriangleExpanderTextAttribute new
											attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
													beAppend;
													stencil: [ | editor |
														editor := BrEditor new.
														(source
															anySatisfy: [ :each | each = Character cr or: [ each = Character lf ] ])
															ifTrue: [ editor hMatchParent.
																editor margin: (BlInsets left: 10 right: 10) ]
															ifFalse: [ editor hFitContent ].
														editor vFitContentLimited.
														editor padding: (BlInsets all: 5).
														editor background: Color white.
														editor
															aptitude: BrGlamorousCodeEditorAptitude new + BrShadowAptitude new.
														editor text: source asRopedText glamorousCodeFont ] ])
									from: node stopPosition
									to: node stopPosition ] ]}
]

{ #category : #instances }
GtSmaCCParserStyler class >> yamlStyler: aParserClass [
	<smaccStyler: #YAMLParser priority: 50>
	^ (self forParser: aParserClass)
		stylerRules: {GtSmaCCNodeStylerRule
					nodeClassName: #YAMLStringNode
					styleBlock: [ :styler :node | 
						((node parent isKindOf: YAMLMappingNode) and: [ node parent key == node ])
							ifFalse: [ styler foreground: Color blue ] ].
				GtSmaCCNodeStylerRule
					nodeClassName: #YAMLNumberNode
					styleBlock: [ :styler :node | 
						((node parent isKindOf: YAMLMappingNode) and: [ node parent key == node ])
							ifFalse: [ styler foreground: Color blue ] ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #YAMLMappingNode
					variableNames: #(key)
					styleBlock: [ :styler | styler foreground: Color purple ].
				GtSmaCCCommentStylerRule
					styleBlock: [ :styler | styler foreground: Color lightGray ].
				GtSmaCCNodeVariableStylerRule
					nodeClassName: #SmaCCErrorNode
					variableNames: #(dismissedTokens errorToken)
					styleBlock: [ :styler | styler foreground: Color red ]}
]

{ #category : #instances }
GtSmaCCParserStyler class >> yamlStylerWithAliasExpander: aParserClass [
	<smaccStyler: #YAMLParser priority: 49>
	^ GtCompositeSmaCCASTStyler new
		parserClass: YAMLParser;
		stylers: {self yamlStyler: aParserClass.
				self yamlAliasExpanderStyler: aParserClass}
]

{ #category : #accessing }
GtSmaCCParserStyler >> addStylerRule: aStylerRule [
	self stylerRules add: aStylerRule.
	aStylerRule initializeForParser: parserClass
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
				ifTrue: [ each applyTo: aSmaCCParseNode on: text.
					each continueOnMatch ifFalse: [ ^ self ] ] ]
]

{ #category : #private }
GtSmaCCParserStyler >> styleToken: aSmaCCToken [
	stylerRules
		do: [ :each | 
			(each shouldApplyToToken: aSmaCCToken)
				ifTrue: [ each applyTo: aSmaCCToken on: text.
					each continueOnMatch ifFalse: [ ^ self ] ] ]
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
