Class {
	#name : #GtSmaCCGrammarVariableCoderElement,
	#superclass : #GtSmaCCListCoderElement,
	#instVars : [
		'editType'
	],
	#category : 'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCGrammarVariableCoderElement >> coderListElementClass [
	^ GtSmaCCVariableListElement
]

{ #category : #accessing }
GtSmaCCGrammarVariableCoderElement >> editType [
	^ editType
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> editTypes [
	^ #(single same all)
]

{ #category : #accessing }
GtSmaCCGrammarVariableCoderElement >> group [
	^ grammarCoder variableGroup
]

{ #category : #'initialize-release' }
GtSmaCCGrammarVariableCoderElement >> initialize [
	super initialize.
	editType := self editTypes first
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> toggleNextRenaming [
	| index |
	index := self editTypes indexOf: self editType.
	index := index + 1.
	index > self editTypes size
		ifTrue: [ index := 1 ].
	editType := self editTypes at: index
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> togglePreviousRenaming [
	| index |
	index := self editTypes indexOf: self editType.
	index := index - 1.
	index < 1
		ifTrue: [ index := self editTypes size ].
	editType := self editTypes at: index
]
