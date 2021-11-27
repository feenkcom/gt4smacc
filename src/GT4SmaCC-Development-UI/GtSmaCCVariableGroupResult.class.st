Class {
	#name : #GtSmaCCVariableGroupResult,
	#superclass : #GtSmaCCSearchTypedGroupResult,
	#instVars : [
		'coderMap',
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCVariableGroupResult class >> onCoder: aGrammarCoder [
	^ self new
		grammarCoder: aGrammarCoder;
		yourself
]

{ #category : #accessing }
GtSmaCCVariableGroupResult >> coderFor: aString [
	^ (coderMap ifNil: [ coderMap := Dictionary new ])
		at: aString
		ifAbsentPut: [ GtSmaCCVariableCoder for: aString in: self grammarCoder ]
]

{ #category : #accessing }
GtSmaCCVariableGroupResult >> coders [
	| coders |
	coders := OrderedCollection new.
	self
		do:
			[ :each | (self coderFor: each) ifNotNil: [ :coder | coders add: coder ] ].
	^ coders
]

{ #category : #accessing }
GtSmaCCVariableGroupResult >> grammarCoder [
	^ grammarCoder ifNil: [ scope grammarCoder ]
]

{ #category : #accessing }
GtSmaCCVariableGroupResult >> grammarCoder: aGrammarCoder [
	grammarCoder := aGrammarCoder
]

{ #category : #updating }
GtSmaCCVariableGroupResult >> updateItems: nameCollection [
	| names |
	names := nameCollection asSet.
	self refreshItems.
	items do: [ :each | names remove: each ifAbsent: [  ] ].
	names isEmpty
		ifTrue: [ ^ self ].
	items addAll: names.
	items sort
]
