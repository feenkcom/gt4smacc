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

{ #category : #private }
GtSmaCCVariableGroupResult >> announceItemsChanged [
	self announcer
		announce: (GtSmaCCVariableGroupItemsChanged new groupResult: self)
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
	| names oldItems |
	names := nameCollection asSet.
	filtered := false.
	oldItems := items.
	self refreshItems.
	items do: [ :each | names remove: each ifAbsent: [  ] ].
	names isEmpty ifTrue: [ ^ self ].
	items addAll: names.
	items sort.
	oldItems ~= items ifTrue: [ self announceItemsChanged ]
]

{ #category : #private }
GtSmaCCVariableGroupResult >> updatedItemsFrom: anObject [
	self announceItemsChanged
]
