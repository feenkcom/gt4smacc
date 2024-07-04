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
	| cssColors colorBlock |
	cssColors := Dictionary
			newFromPairs: (#('AliceBlue' 'F0F8FF' 'AntiqueWhite' 'FAEBD7' 'Aqua' '00FFFF' 'Aquamarine' '7FFFD4' 'Azure' 'F0FFFF' 'Beige' 'F5F5DC' 'Bisque' 'FFE4C4' 'Black' '000000' 'BlanchedAlmond' 'FFEBCD' 'Blue' '0000FF' 'BlueViolet' '8A2BE2' 'Brown' 'A52A2A' 'BurlyWood' 'DEB887' 'CadetBlue' '5F9EA0' 'Chartreuse' '7FFF00' 'Chocolate' 'D2691E' 'Coral' 'FF7F50' 'CornflowerBlue' '6495ED' 'Cornsilk' 'FFF8DC' 'Crimson' 'DC143C' 'Cyan' '00FFFF' 'DarkBlue' '00008B' 'DarkCyan' '008B8B' 'DarkGoldenRod' 'B8860B' 'DarkGray' 'A9A9A9' 'DarkGreen' '006400' 'DarkKhaki' 'BDB76B' 'DarkMagenta' '8B008B' 'DarkOliveGreen' '556B2F' 'Darkorange' 'FF8C00' 'DarkOrchid' '9932CC' 'DarkRed' '8B0000' 'DarkSalmon' 'E9967A' 'DarkSeaGreen' '8FBC8F' 'DarkSlateBlue' '483D8B' 'DarkSlateGray' '2F4F4F' 'DarkTurquoise' '00CED1' 'DarkViolet' '9400D3' 'DeepPink' 'FF1493' 'DeepSkyBlue' '00BFFF' 'DimGray' '696969' 'DodgerBlue' '1E90FF' 'FireBrick' 'B22222' 'FloralWhite' 'FFFAF0' 'ForestGreen' '228B22' 'Fuchsia' 'FF00FF' 'Gainsboro' 'DCDCDC' 'GhostWhite' 'F8F8FF' 'Gold' 'FFD700' 'GoldenRod' 'DAA520' 'Gray' '808080' 'Green' '008000' 'GreenYellow' 'ADFF2F' 'HoneyDew' 'F0FFF0' 'HotPink' 'FF69B4' 'IndianRed' 'CD5C5C' 'Indigo' '4B0082' 'Ivory' 'FFFFF0' 'Khaki' 'F0E68C' 'Lavender' 'E6E6FA' 'LavenderBlush' 'FFF0F5' 'LawnGreen' '7CFC00' 'LemonChiffon' 'FFFACD' 'LightBlue' 'ADD8E6' 'LightCoral' 'F08080' 'LightCyan' 'E0FFFF' 'LightGoldenRodYellow' 'FAFAD2' 'LightGrey' 'D3D3D3' 'LightGreen' '90EE90' 'LightPink' 'FFB6C1' 'LightSalmon' 'FFA07A' 'LightSeaGreen' '20B2AA' 'LightSkyBlue' '87CEFA' 'LightSlateGray' '778899' 'LightSteelBlue' 'B0C4DE' 'LightYellow' 'FFFFE0' 'Lime' '00FF00' 'LimeGreen' '32CD32' 'Linen' 'FAF0E6' 'Magenta' 'FF00FF' 'Maroon' '800000' 'MediumAquaMarine' '66CDAA' 'MediumBlue' '0000CD' 'MediumOrchid' 'BA55D3' 'MediumPurple' '9370D8' 'MediumSeaGreen' '3CB371' 'MediumSlateBlue' '7B68EE' 'MediumSpringGreen' '00FA9A' 'MediumTurquoise' '48D1CC' 'MediumVioletRed' 'C71585' 'MidnightBlue' '191970' 'MintCream' 'F5FFFA' 'MistyRose' 'FFE4E1' 'Moccasin' 'FFE4B5' 'NavajoWhite' 'FFDEAD' 'Navy' '000080' 'OldLace' 'FDF5E6' 'Olive' '808000' 'OliveDrab' '6B8E23' 'Orange' 'FFA500' 'OrangeRed' 'FF4500' 'Orchid' 'DA70D6' 'PaleGoldenRod' 'EEE8AA' 'PaleGreen' '98FB98' 'PaleTurquoise' 'AFEEEE' 'PaleVioletRed' 'D87093' 'PapayaWhip' 'FFEFD5' 'PeachPuff' 'FFDAB9' 'Peru' 'CD853F' 'Pink' 'FFC0CB' 'Plum' 'DDA0DD' 'PowderBlue' 'B0E0E6' 'Purple' '800080' 'Red' 'FF0000' 'RosyBrown' 'BC8F8F' 'RoyalBlue' '4169E1' 'SaddleBrown' '8B4513' 'Salmon' 'FA8072' 'SandyBrown' 'F4A460' 'SeaGreen' '2E8B57' 'SeaShell' 'FFF5EE' 'Sienna' 'A0522D' 'Silver' 'C0C0C0' 'SkyBlue' '87CEEB' 'SlateBlue' '6A5ACD' 'SlateGray' '708090' 'Snow' 'FFFAFA' 'SpringGreen' '00FF7F' 'SteelBlue' '4682B4' 'Tan' 'D2B48C' 'Teal' '008080' 'Thistle' 'D8BFD8' 'Tomato' 'FF6347' 'Turquoise' '40E0D0' 'Violet' 'EE82EE' 'Wheat' 'F5DEB3' 'White' 'FFFFFF' 'WhiteSmoke' 'F5F5F5' 'Yellow' 'FFFF00' 'YellowGreen' '9ACD32')
					collect: #asUppercase).
	colorBlock := [ :colorValue :node :text | 
		[ | color |
		color := Color fromHexString: colorValue.
		text
			attribute: (BrTextAdornmentDynamicAttribute new
					beAppend;
					stencil: [ BlElement new
							size: 10 @ 10;
							background: color;
							addAptitude: (BrGlamorousWithDropdownAptitude
									handle: [ BlElement new
											size: 10 @ 10;
											background: color ]
									content: [ BlElement new
											size: 100 @ 100;
											background: color ]) ])
			from: node stopPosition
			to: node stopPosition ] on: Error do: [ :ex | ex return ] ].
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
					nodeClassName: #CSSIdentifierNode
					styleBlock: [ :styler :node :text | 
						cssColors
							at: node name source asUppercase
							ifPresent: [ :value | 
								((node parent isKindOf: CSSDeclarationNode)
									and: [ node parent values identityIncludes: node ])
									ifTrue: [ colorBlock
											value: value
											value: node
											value: text ] ] ].
				GtSmaCCNodeStylerRule
					nodeClassName: #CSSHashNode
					styleBlock: [ :styler :node :text | 
						| source |
						source := node name source.
						source notEmpty ifTrue: [ source := source allButFirst asUppercase ].
						source size = 3
							ifTrue: [ source := String
										streamContents: [ :stream | source do: [ :each | stream next: 2 put: each ] ] ].
						colorBlock
							value: source asUppercase
							value: node
							value: text ].
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
