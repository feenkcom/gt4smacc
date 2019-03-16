Class {
	#name : #GtSmaCCStylingVisitor,
	#superclass : #SmaCCDefinitionNodeVisitor,
	#instVars : [
		'text',
		'styler'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #private }
GtSmaCCStylingVisitor >> formatInlineDefinition: aNode [
	
]

{ #category : #private }
GtSmaCCStylingVisitor >> formatTokenMethod: aToken [
	| name class stStyler |
	name := (aToken source copyFrom: 2 to: aToken source size - 1)
		asSymbol.
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
						stencil: [ (GtMethodCoder forMethod: (class lookupSelector: name))
								expanded: true;
								asElement ] ])}
		from: aToken stopPosition
		to: aToken stopPosition
]

{ #category : #private }
GtSmaCCStylingVisitor >> style: anItem with: aSymbol [
	GtSmaCCStyler
		perform: aSymbol
		with: (text from: anItem startPosition to: anItem stopPosition)
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
	aGrammarDefinition comments
		do:
			[ :each | GtSmaCCStyler formatComment: (text from: each first to: each last) ]
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitKeywordSymbol: aKeywordSymbol [
	self style: aKeywordSymbol name with: #formatKeyword:.
	super visitKeywordSymbol: aKeywordSymbol
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitProductionRule: aProductionRule [
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
	aSymbol variableNameToken notNil
		ifTrue: [ self style: aSymbol variableNameToken with: #formatVariableName: ].
	super visitSymbol: aSymbol
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitTokenRegex: aTokenRegex [
	self style: aTokenRegex with: #formatTokenDefinition:.
	super visitTokenRegex: aTokenRegex
]

{ #category : #visiting }
GtSmaCCStylingVisitor >> visitTokenRule: aTokenRule [
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
