Class {
	#name : #GtSmaCCSyntaxStylingVisitor,
	#superclass : #GtSmaCCStylingVisitor,
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #private }
GtSmaCCSyntaxStylingVisitor >> formatCharacterMethod: aToken [
	| name |
	name := (aToken source copyFrom: 2 to: aToken source size - 1)
		asSymbol.
	(Character includesSelector: name)
		ifFalse: [ ^ self ].
	self formatMethod: (Character lookupSelector: name) for: aToken
]

{ #category : #private }
GtSmaCCSyntaxStylingVisitor >> formatInlineDefinition: aNode [
	^ false
]

{ #category : #private }
GtSmaCCSyntaxStylingVisitor >> formatMethod: aCompiledMethod for: aToken [
	| stStyler |
	stStyler := BrRBTextStyler new.
	stStyler classOrMetaClass: aCompiledMethod methodClass.
	self text
		attributes:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ (GtMethodCoder forMethod: aCompiledMethod)
								expanded: true;
								asElement ] ])}
		from: aToken stopPosition
		to: aToken stopPosition
]

{ #category : #private }
GtSmaCCSyntaxStylingVisitor >> formatTokenMethod: aToken [
	| name class |
	name := (aToken source copyFrom: 2 to: aToken source size - 1)
		asSymbol.
	class := styler scannerClass whichClassIncludesSelector: name.
	class isNil
		ifTrue: [ ^ self ].
	(class includesBehavior: SmaCCScanner)
		ifFalse: [ ^ self ].
	self formatMethod: (class lookupSelector: name) for: aToken
]

{ #category : #private }
GtSmaCCSyntaxStylingVisitor >> style: anItem with: aSymbol [
	GtSmaCCStyler
		perform: aSymbol
		with: (self text from: anItem startPosition to: anItem stopPosition)
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitClassProductionExpression: aClassProductionExpression [
	self style: aClassProductionExpression with: #formatCode:.
	super visitClassProductionExpression: aClassProductionExpression
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitCodeProductionExpression: aCodeProductionExpression [
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
GtSmaCCSyntaxStylingVisitor >> visitDirective: aDirective [
	self style: aDirective directiveStartToken with: #formatDirectiveKeyword:.
	self style: aDirective directiveNameToken with: #formatDirectiveKeyword:.
	self style: aDirective with: #formatDirective:.
	super visitDirective: aDirective
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitGrammarDefinition: aGrammarDefinition [
	super visitGrammarDefinition: aGrammarDefinition.
	aGrammarDefinition comments
		do: [ :each | 
			GtSmaCCStyler
				formatComment: (self text from: each first to: each last) ]
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitKeywordSymbol: aKeywordSymbol [
	self style: aKeywordSymbol name with: #formatKeyword:.
	super visitKeywordSymbol: aKeywordSymbol
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitProductionRule: aProductionRule [
	self style: aProductionRule name with: #formatProductionDefinition:.
	super visitProductionRule: aProductionRule
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitProductionSymbol: aProductionSymbol [
	self style: aProductionSymbol name with: #formatProduction:.
	self formatInlineDefinition: aProductionSymbol.
	super visitProductionSymbol: aProductionSymbol
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitRepeatRegex: aRepeatRegex [
	self style: aRepeatRegex count with: #formatRepeat:.
	super visitRepeatRegex: aRepeatRegex
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitSymbol: aSymbol [
	aSymbol variableNameToken notNil
		ifTrue: [ self style: aSymbol variableNameToken with: #formatVariableName: ].
	super visitSymbol: aSymbol
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitTokenRegex: aTokenRegex [
	self style: aTokenRegex with: #formatToken:.
	(self formatInlineDefinition: aTokenRegex)
		ifFalse: [ self formatCharacterMethod: aTokenRegex ].
	super visitTokenRegex: aTokenRegex
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitTokenRule: aTokenRule [
	self style: aTokenRule name with: #formatTokenDefinition:.
	self formatTokenMethod: aTokenRule name.
	super visitTokenRule: aTokenRule
]

{ #category : #visiting }
GtSmaCCSyntaxStylingVisitor >> visitTokenSymbol: aTokenSymbol [
	self style: aTokenSymbol name with: #formatToken:.
	self formatInlineDefinition: aTokenSymbol.
	super visitTokenSymbol: aTokenSymbol
]
