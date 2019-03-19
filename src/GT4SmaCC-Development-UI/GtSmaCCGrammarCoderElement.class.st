Class {
	#name : #GtSmaCCGrammarCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'grammarCoder',
		'coders'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCGrammarCoderElement class >> onCoder: aGrammarCoder [
	^ self new
		coder: aGrammarCoder;
		yourself
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		addChild:
			(GtSmaCCDefinitionListElement new
				coders: grammarCoder coders;
				yourself)
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoderElement >> coder: aGrammarCoder [
	grammarCoder := aGrammarCoder.
	self buildElement
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> listElement [
	| list |
	list := BrSimpleList new.
	list vFitContent.
	list stencil: [ :each :index | each asElement ].
	list items: (grammarCoder coders collect: #yourself).
	^ list asScrollableElement
]
