Class {
	#name : 'GtSmaCCGrammarFilter',
	#superclass : 'GtSmaCCDefinitionsFilter',
	#instVars : [
		'grammarCoder'
	],
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : 'instance creation' }
GtSmaCCGrammarFilter class >> on: aGrammarCoder [
	^ self new
		grammarCoder: aGrammarCoder;
		yourself
]

{ #category : 'accessing' }
GtSmaCCGrammarFilter >> defaultFilterScope [
	^ self
]

{ #category : 'accessing' }
GtSmaCCGrammarFilter >> grammar [
	^ grammarCoder grammar
]

{ #category : 'accessing' }
GtSmaCCGrammarFilter >> grammarCoder [
	^ grammarCoder
]

{ #category : 'accessing' }
GtSmaCCGrammarFilter >> grammarCoder: aGrammarCoder [
	grammarCoder := aGrammarCoder
]

{ #category : 'accessing' }
GtSmaCCGrammarFilter >> itemsDo: aBlock [
	| classItemsDoBlock |
	aBlock value: self grammar.
	self grammar rules do: aBlock.
	classItemsDoBlock := [ :class | 
	aBlock
		value: class;
		value: class class.
	class methodsDo: aBlock.
	class class methodsDo: aBlock ].
	self grammar scannerClass ifNotNil: classItemsDoBlock.
	self grammar parserClass ifNotNil: classItemsDoBlock
]

{ #category : 'testing' }
GtSmaCCGrammarFilter >> matches: anObject [
	^ true
]
