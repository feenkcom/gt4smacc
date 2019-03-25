Class {
	#name : #GtSmaCCGrammarStylingVisitor,
	#superclass : #GtSmaCCSyntaxStylingVisitor,
	#instVars : [
		'completions'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #accessing }
GtSmaCCGrammarStylingVisitor >> completions [
	^ completions
]

{ #category : #private }
GtSmaCCGrammarStylingVisitor >> formatInlineDefinition: aNode token: aToken [
	| name definition grammar |
	name := aToken source.
	grammar := styler originalGrammar ifNil: [ aNode topParent ].
	definition := grammar definitionNamed: name.
	definition isNil
		ifTrue: [ ^ false ].
	self text
		attributes:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ self
								textEditorOn: definition source
								usingStyler: (GtSmaCCGrammarStyler for: styler scannerClass grammar: grammar) ] ])}
		from: aToken stopPosition
		to: aToken stopPosition.
	^ true
]

{ #category : #'initialize-release' }
GtSmaCCGrammarStylingVisitor >> initialize [
	super initialize.
	completions := GtPrefixTree
		withAll:
			#('%annotate_tokens;' '%attributes' '%excludes' '%glr;' '%hierarchy' '%id' '%ignorecase;' '%ignore_variables' '%left' '%nonassoc' '%prefix' '%right' '%root' '%scopes' '%start' '%suffix' '%states')
]

{ #category : #private }
GtSmaCCGrammarStylingVisitor >> textEditorOn: aString usingStyler: aStyler [
	| editor editorElement innerText |
	innerText := aString asRopedText.
	innerText
		attributes: SmaCCParserGeneratorPresentation defaultTextAttributes.
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
GtSmaCCGrammarStylingVisitor >> visitProductionRule: aProductionRule [
	completions add: aProductionRule name source.
	super visitProductionRule: aProductionRule
]

{ #category : #visiting }
GtSmaCCGrammarStylingVisitor >> visitSymbol: aSymbol [
	completions add: aSymbol name source.
	aSymbol variableNameToken notNil
		ifTrue: [ completions
				add: aSymbol name source , ' ' , aSymbol variableNameToken value.
			completions add: aSymbol variableNameToken value ].
	super visitSymbol: aSymbol
]

{ #category : #visiting }
GtSmaCCGrammarStylingVisitor >> visitTokenRegex: aTokenRegex [
	completions add: aTokenRegex name source.
	super visitTokenRegex: aTokenRegex
]

{ #category : #visiting }
GtSmaCCGrammarStylingVisitor >> visitTokenRule: aTokenRule [
	completions add: aTokenRule name source.
	super visitTokenRule: aTokenRule
]
