Class {
	#name : #GtSmaCCStylingVisitor,
	#superclass : #SmaCCDefinitionNodeVisitor,
	#instVars : [
		'text',
		'styler',
		'completions'
	],
	#category : #'GT-SmaCC-Development-UI'
}

{ #category : #accessing }
GtSmaCCStylingVisitor >> completions [
	^ completions
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatCharacterRegex: aText [
	aText
		attributes:
			{(BrTextHoverAttribute new
				textAttributes: {(BlTextBackgroundAttribute new paint: (Color gray alpha: 0.2))};
				leaveTextAttributes: {(BlTextBackgroundAttribute new paint: Color transparent)})}
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatCode: aText [
	aText foreground: Color darkGray
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatComment: aText [
	aText foreground: Color lightGray
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatDirective: aText [
	aText foreground: Color veryDarkGray
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatDirectiveKeyword: aText [
	aText bold
]

{ #category : #private }
GtSmaCCStylingVisitor >> formatInlineDefinition: aNode [
	| name definition grammar |
	name := aNode name source.
	grammar := styler originalGrammar ifNil: [ aNode topParent ].
	definition := grammar definitionNamed: name.
	definition isNil
		ifTrue: [ ^ self ].
	text
		attributes:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ self textEditorOn: definition source usingStyler: (GtSmaCCStyler for: styler scannerClass grammar: grammar) ] ])}
		from: aNode name stopPosition
		to: aNode name stopPosition
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatKeyword: aText [
	aText foreground: Color magenta
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatProduction: aText [
	aText foreground: Color purple
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatProductionDefinition: aText [
	aText bold.
	self formatProduction: aText
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatRepeat: aText [
	aText
		foreground: Color black;
		bold
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatToken: aText [
	aText foreground: Color blue
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatTokenDefinition: aText [
	aText bold.
	self formatToken: aText
]

{ #category : #private }
GtSmaCCStylingVisitor >> formatTokenMethod: aToken [
	| name class stStyler |
	name := (aToken source copyFrom: 2 to: aToken source size - 1) asSymbol.
	class := styler scannerClass whichClassIncludesSelector: name.
	class isNil
		ifTrue: [ ^ self ].
	(class includesBehavior: SmaCCScanner)
		ifFalse: [ ^ self ].
	stStyler := BrRBTextStyler new.
	stStyler classOrMetaClass: class.
	text
		attributes:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ self textEditorOn: (class lookupSelector: name) sourceCode usingStyler: stStyler ] ])}
		from: aToken stopPosition
		to: aToken stopPosition
]

{ #category : #'private-formatting' }
GtSmaCCStylingVisitor >> formatVariableName: aText [
	aText foreground: Color gray
]

{ #category : #'initialize-release' }
GtSmaCCStylingVisitor >> initialize [
	super initialize.
	completions := GtPrefixTree
		withAll:
			#('%annotate_tokens;' '%attributes' '%excludes' '%glr;' '%hierarchy' '%id' '%ignorecase;' '%ignore_variables' '%left' '%nonassoc' '%prefix' '%right' '%root' '%scopes' '%start' '%suffix' '%states')
]

{ #category : #private }
GtSmaCCStylingVisitor >> style: anItem with: aSymbol [
	self perform: aSymbol with: (text from: anItem startPosition to: anItem stopPosition)
]

{ #category : #accessing }
GtSmaCCStylingVisitor >> styler [
	^ styler
]

{ #category : #accessing }
GtSmaCCStylingVisitor >> styler: smaccStyler [
	styler := smaccStyler
]

{ #category : #accessing }
GtSmaCCStylingVisitor >> text [
	^ text
]

{ #category : #accessing }
GtSmaCCStylingVisitor >> text: anObject [
	text := anObject
]

{ #category : #private }
GtSmaCCStylingVisitor >> textEditorOn: aString usingStyler: aStyler [
	| editor editorElement innerText |
	innerText := aString asRopedText.
	editor := BrTextEditor new.
	aStyler notNil
		ifTrue: [ editor styler: aStyler ].
	editor text: innerText.
	editorElement := BrEditorElement new.
	editorElement editor: editor.
	editorElement
		constraintsDo: [ :c | 
			c textFlow pushLine.
			c horizontal matchParent.
			c vertical fitContent ];
		background: Color white;
		border: (BlBorder paint: Color veryLightGray width: 1);
		margin:
			(BlInsets
				top: 0
				right: 10
				bottom: 10
				left: 10).
	^ editorElement
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitClassProductionExpression: aClassProductionExpression [
	self style: aClassProductionExpression with: #formatCode:.
	super visitClassProductionExpression: aClassProductionExpression
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitCodeProductionExpression: aCodeProductionExpression [
	| codeText |
	codeText := self text from: aCodeProductionExpression code startPosition + 1 to: aCodeProductionExpression code stopPosition - 1.
	BrRBTextStyler new
		classOrMetaClass: SmaCCParser;
		workspace: Dictionary new;
		style: codeText.
	(self text from: aCodeProductionExpression code startPosition to: aCodeProductionExpression code stopPosition)
		italic;
		fontSize: 12.
	(self text from: aCodeProductionExpression code startPosition + 1 to: aCodeProductionExpression code stopPosition - 1)
		attributes: {(GtCompletionStrategyAttribute new strategy: (GtSmaCCExpressionCompletionStrategy onToken: aCodeProductionExpression code))}.
	super visitCodeProductionExpression: aCodeProductionExpression
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitDirective: aDirective [
	self style: aDirective directiveStartToken with: #formatDirectiveKeyword:.
	self style: aDirective directiveNameToken with: #formatDirectiveKeyword:.
	self style: aDirective with: #formatDirective:.
	super visitDirective: aDirective
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitGrammarDefinition: aGrammarDefinition [
	super visitGrammarDefinition: aGrammarDefinition.
	aGrammarDefinition comments do: [ :each | self formatComment: (text from: each first to: each last) ]
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitKeywordSymbol: aKeywordSymbol [
	self style: aKeywordSymbol name with: #formatKeyword:.
	super visitKeywordSymbol: aKeywordSymbol
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitProductionRule: aProductionRule [
	completions add: aProductionRule name source.
	self style: aProductionRule name with: #formatProductionDefinition:.
	super visitProductionRule: aProductionRule
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitProductionSymbol: aProductionSymbol [
	self style: aProductionSymbol name with: #formatProduction:.
	self formatInlineDefinition: aProductionSymbol.
	super visitProductionSymbol: aProductionSymbol
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitRepeatRegex: aRepeatRegex [
	self style: aRepeatRegex count with: #formatRepeat:.
	super visitRepeatRegex: aRepeatRegex
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitSymbol: aSymbol [
	completions add: aSymbol name source.
	aSymbol variableNameToken notNil
		ifTrue: [ self style: aSymbol variableNameToken with: #formatVariableName:.
			completions add: aSymbol name source , ' ' , aSymbol variableNameToken value.
			completions add: aSymbol variableNameToken value ].
	super visitSymbol: aSymbol
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitTokenRegex: aTokenRegex [
	completions add: aTokenRegex name source.
	self style: aTokenRegex with: #formatTokenDefinition:.
	super visitTokenRegex: aTokenRegex
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitTokenRule: aTokenRule [
	completions add: aTokenRule name source.
	self style: aTokenRule name with: #formatTokenDefinition:.
	self formatTokenMethod: aTokenRule name.
	super visitTokenRule: aTokenRule
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitTokenSymbol: aTokenSymbol [
	self style: aTokenSymbol name with: #formatToken:.
	self formatInlineDefinition: aTokenSymbol.
	super visitTokenSymbol: aTokenSymbol
]
