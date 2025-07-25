Class {
	#name : #GtSmaCCDefinitionGroupResult,
	#superclass : #GtSmaCCSearchTypedGroupResult,
	#instVars : [
		'coderMap',
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCDefinitionGroupResult class >> onCoder: aGrammarCoder [
	^ self new
		grammarCoder: aGrammarCoder;
		yourself
]

{ #category : #elements }
GtSmaCCDefinitionGroupResult >> asElement [
	^ GtSmaCCFilteredCoderElement new
		group: self;
		coder: self grammarCoder;
		yourself
]

{ #category : #accessing }
GtSmaCCDefinitionGroupResult >> coderFor: aGrammarItem [
	aGrammarItem isDeleted
		ifTrue: [ ^ nil ].
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
GtSmaCCDefinitionGroupResult >> gtItemsFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 0;
		stencil: [ self ]
]

{ #category : #accessing }
GtSmaCCDefinitionGroupResult >> highlighter [
	filter notNil
		ifTrue: [ filter highlighter ifNotNil: [ :highlighter | ^ highlighter ] ].
	scope notNil
		ifTrue: [ ^ scope highlighter ].
	^ nil
]

{ #category : #updating }
GtSmaCCDefinitionGroupResult >> updateItemsFrom: aCollection [
	items := OrderedCollection withAll: aCollection.
	filtered := true
]
