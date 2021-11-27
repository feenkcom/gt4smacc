Class {
	#name : #GtSmaCCSearchGroupResult,
	#superclass : #Object,
	#instVars : [
		'items',
		'filter',
		'filtered',
		'scope'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'as yet unclassified' }
GtSmaCCSearchGroupResult class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithDefaultGroup
]

{ #category : #'as yet unclassified' }
GtSmaCCSearchGroupResult class >> mergeTypeWithDefaultGroup [
	"The common type between the default group and any other group is the other group."
	^ self
]

{ #category : #'as yet unclassified' }
GtSmaCCSearchGroupResult class >> mergeTypeWithGenericGroup [
	"The common type between a generic group and any other group is the other group."
	^ self
]

{ #category : #'as yet unclassified' }
GtSmaCCSearchGroupResult class >> mergeTypeWithTypedGroup: aGroupType [
	^ self
]

{ #category : #adding }
GtSmaCCSearchGroupResult >> add: anObject [
	self refreshItems.
	^ items add: anObject
]

{ #category : #enumerating }
GtSmaCCSearchGroupResult >> collect: aBlock [
	self refreshItems.
	^ items collect: aBlock
]

{ #category : #enumerating }
GtSmaCCSearchGroupResult >> do: aBlock [
	self refreshItems.
	^ items do: aBlock
]

{ #category : #accessing }
GtSmaCCSearchGroupResult >> filter [
	^ filter
]

{ #category : #accessing }
GtSmaCCSearchGroupResult >> filter: methodsFilter [
	filtered := false.
	items := OrderedCollection new.
	filter := methodsFilter
]

{ #category : #initialization }
GtSmaCCSearchGroupResult >> forFilter: aFilter scope: aSearchScope [
	filter := aFilter.
	scope := aSearchScope
]

{ #category : #enumerating }
GtSmaCCSearchGroupResult >> groupedBy: aBlockClosureOrSymbol [
	"Group the filteres items using the given block. The returned groups are just a copy based on 
	the current items at the time of the call. They are not updated if the filtered items change."
	self refreshItems.
	^ items groupedBy: aBlockClosureOrSymbol
]

{ #category : #ui }
GtSmaCCSearchGroupResult >> gtItemsFor: aView [
	<gtView>
	self refreshItems.
	^ aView list 
		title: 'Items' translated;
		priority: 10;
		items: [ items ifNil: [ #() ] ]
]

{ #category : #accessing }
GtSmaCCSearchGroupResult >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
GtSmaCCSearchGroupResult >> includes: aCollection [ 
	self refreshItems.
	^ items includes: aCollection
]

{ #category : #initialization }
GtSmaCCSearchGroupResult >> initialize [
	super initialize.
	filtered := false.
	items := OrderedCollection new.
]

{ #category : #testing }
GtSmaCCSearchGroupResult >> isEmpty [
	"Answer whether the receiver contains any elements."
	^ self size = 0
]

{ #category : #enumerating }
GtSmaCCSearchGroupResult >> itemsDo: aBlock [
	self do: aBlock
]

{ #category : #enumerating }
GtSmaCCSearchGroupResult >> refreshItems [
	| filteredItems |
	filtered
		ifTrue: [ ^ self ].
	filteredItems := OrderedCollection new.
	filter ifNotNil: [ 
		scope itemsDo: [ :anObject | 
			(filter matches: anObject) ifTrue: [
				filteredItems add: anObject ] ] ].
	items := filteredItems.
	filtered := true.
]

{ #category : #removing }
GtSmaCCSearchGroupResult >> remove: anItem ifAbsent: aBlock [
	self refreshItems.
	^ items remove: anItem ifAbsent: aBlock
]

{ #category : #accessing }
GtSmaCCSearchGroupResult >> scope [
	^ scope
]

{ #category : #accessing }
GtSmaCCSearchGroupResult >> scope: aSearchScope [
	scope := aSearchScope
]

{ #category : #accessing }
GtSmaCCSearchGroupResult >> size [
	self refreshItems.
	^ items size
]

{ #category : #private }
GtSmaCCSearchGroupResult >> species [
	self refreshItems.
	^ items class
]

{ #category : #enumerating }
GtSmaCCSearchGroupResult >> sumNumbers: aBlock [
	self refreshItems.
	^ items sumNumbers: aBlock
]
