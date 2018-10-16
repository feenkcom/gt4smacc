Class {
	#name : #FkSmaCCStylingVisitor,
	#superclass : #SmaCCDefinitionNodeVisitor,
	#instVars : [
		'text',
		'styler',
		'completions'
	],
	#category : #'GT-SmaCC-Development-UI'
}

{ #category : #accessing }
FkSmaCCStylingVisitor >> completions [
	^ completions
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatCharacterRegex: aText [
	aText
		attributes:
			{(BrTextHoverAttribute new
				textAttributes: {(BlTextBackgroundAttribute new paint: (Color gray alpha: 0.2))};
				leaveTextAttributes: {(BlTextBackgroundAttribute new paint: Color transparent)})}
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatCode: aText [
	aText foreground: Color darkGray
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatComment: aText [
	aText foreground: Color lightGray
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatDirective: aText [
	aText foreground: Color veryDarkGray
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatDirectiveKeyword: aText [
	aText bold
]

{ #category : #private }
FkSmaCCStylingVisitor >> formatInlineDefinition: aNode [
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
						stencil: [ self textEditorOn: definition source usingStyler: (FkSmaCCStyler for: styler scannerClass grammar: grammar) ] ])}
		from: aNode name stopPosition
		to: aNode name stopPosition
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatKeyword: aText [
	aText foreground: Color magenta
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatProduction: aText [
	aText foreground: Color purple
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatProductionDefinition: aText [
	aText bold.
	self formatProduction: aText
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatRepeat: aText [
	aText
		foreground: Color black;
		bold
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatToken: aText [
	aText foreground: Color blue
]

{ #category : #'private-formatting' }
FkSmaCCStylingVisitor >> formatTokenDefinition: aText [
	aText bold.
	self formatToken: aText
]

{ #category : #private }
FkSmaCCStylingVisitor >> formatTokenMethod: aToken [
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
FkSmaCCStylingVisitor >> formatVariableName: aText [
	aText foreground: Color gray
]

{ #category : #'initialize-release' }
FkSmaCCStylingVisitor >> initialize [
	super initialize.
	completions := GtPrefixTree
		withAll:
			#('%annotate_tokens;' '%attributes' '%excludes' '%glr;' '%hierarchy' '%id' '%ignorecase;' '%ignore_variables' '%left' '%nonassoc' '%prefix' '%right' '%root' '%scopes' '%start' '%suffix' '%states')
]

{ #category : #private }
FkSmaCCStylingVisitor >> style: anItem with: aSymbol [
	self perform: aSymbol with: (text from: anItem startPosition to: anItem stopPosition)
]

{ #category : #accessing }
FkSmaCCStylingVisitor >> styler [
	^ styler
]

{ #category : #accessing }
FkSmaCCStylingVisitor >> styler: smaccStyler [
	styler := smaccStyler
]

{ #category : #accessing }
FkSmaCCStylingVisitor >> text [
	^ text
]

{ #category : #accessing }
FkSmaCCStylingVisitor >> text: anObject [
	text := anObject
]

{ #category : #private }
FkSmaCCStylingVisitor >> textEditorOn: aString usingStyler: aStyler [
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
FkSmaCCStylingVisitor >> visitClassProductionExpression: aClassProductionExpression [
	self style: aClassProductionExpression with: #formatCode:.
	super visitClassProductionExpression: aClassProductionExpression
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitCodeProductionExpression: aCodeProductionExpression [
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
		attributes: {(GtCompletionStrategyAttribute new strategy: (FkSmaCCExpressionCompletionStrategy onToken: aCodeProductionExpression code))}.
	super visitCodeProductionExpression: aCodeProductionExpression
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitDirective: aDirective [
	self style: aDirective directiveStartToken with: #formatDirectiveKeyword:.
	self style: aDirective directiveNameToken with: #formatDirectiveKeyword:.
	self style: aDirective with: #formatDirective:.
	super visitDirective: aDirective
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitGrammarDefinition: aGrammarDefinition [
	super visitGrammarDefinition: aGrammarDefinition.
	aGrammarDefinition comments do: [ :each | self formatComment: (text from: each first to: each last) ]
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitKeywordSymbol: aKeywordSymbol [
	self style: aKeywordSymbol name with: #formatKeyword:.
	super visitKeywordSymbol: aKeywordSymbol
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitProductionRule: aProductionRule [
	completions add: aProductionRule name source.
	self style: aProductionRule name with: #formatProductionDefinition:.
	super visitProductionRule: aProductionRule
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitProductionSymbol: aProductionSymbol [
	self style: aProductionSymbol name with: #formatProduction:.
	self formatInlineDefinition: aProductionSymbol.
	super visitProductionSymbol: aProductionSymbol
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitRepeatRegex: aRepeatRegex [
	self style: aRepeatRegex count with: #formatRepeat:.
	super visitRepeatRegex: aRepeatRegex
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitSymbol: aSymbol [
	completions add: aSymbol name source.
	aSymbol variableNameToken notNil
		ifTrue: [ self style: aSymbol variableNameToken with: #formatVariableName:.
			completions add: aSymbol name source , ' ' , aSymbol variableNameToken value.
			completions add: aSymbol variableNameToken value ].
	super visitSymbol: aSymbol
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitTokenRegex: aTokenRegex [
	completions add: aTokenRegex name source.
	self style: aTokenRegex with: #formatTokenDefinition:.
	super visitTokenRegex: aTokenRegex
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitTokenRule: aTokenRule [
	completions add: aTokenRule name source.
	self style: aTokenRule name with: #formatTokenDefinition:.
	self formatTokenMethod: aTokenRule name.
	super visitTokenRule: aTokenRule
]

{ #category : #visiting }
FkSmaCCStylingVisitor >> visitTokenSymbol: aTokenSymbol [
	self style: aTokenSymbol name with: #formatToken:.
	self formatInlineDefinition: aTokenSymbol.
	super visitTokenSymbol: aTokenSymbol
]
