Class {
	#name : #GtSmaCCDefinitionGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#instVars : [
		'coderMap',
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCDefinitionGroupResult class >> onCoder: aGrammarCoder [
	^ self new
		grammarCoder: aGrammarCoder;
		yourself
]

{ #category : #elements }
GtSmaCCDefinitionGroupResult >> asElement [
	^ GtSmaCCDefinitionListElement new
		group: self;
		yourself
]

{ #category : #accessing }
GtSmaCCDefinitionGroupResult >> coderFor: aGrammarItem [
	^ (coderMap ifNil: [ coderMap := IdentityDictionary new ])
		at: aGrammarItem
		ifAbsentPut: [ GtSmaCCCoder on: aGrammarItem in: self grammarCoder ]
]

{ #category : #accessing }
GtSmaCCDefinitionGroupResult >> coders [
	| coders |
	coders := OrderedCollection new.
	self
		do:
			[ :each | (self coderFor: each) ifNotNil: [ :coder | coders add: coder ] ].
	^ coders
]

{ #category : #accessing }
GtSmaCCDefinitionGroupResult >> grammarCoder [
	^ grammarCoder ifNil: [ scope grammarCoder ]
]

{ #category : #'initialize-release' }
GtSmaCCDefinitionGroupResult >> grammarCoder: aGrammarCoder [
	grammarCoder := aGrammarCoder
]

{ #category : #ui }
GtSmaCCDefinitionGroupResult >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 0;
		stencil: [ self ]
]

{ #category : #enumerating }
GtSmaCCDefinitionGroupResult >> itemsDo: aBlock [
	self do: aBlock
]
