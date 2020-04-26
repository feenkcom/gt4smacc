Class {
	#name : #GtSmaCCASTFilter,
	#superclass : #GTStringFilter,
	#instVars : [
		'queryObject'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #private }
GtSmaCCASTFilter >> doApplyFilterWithQuery [
	| unorderedMatchedItems |
	unorderedMatchedItems := IdentitySet new.
	self
		allItemsDo: [ :each | 
			self
				matchingNodesIn: each
				do: [ :node | 
					(unorderedMatchedItems includes: node)
						ifFalse: [ unorderedMatchedItems add: node.
							self addItem: node.
							unorderedMatchedItems size = self itemsLimit
								ifTrue: [ GTLimitArrived signal ] ] ] ].
	self
		filteredItems:
			(unorderedMatchedItems
				asSortedCollection: [ :a :b | 
					a startPosition < b startPosition
						or: [ a startPosition = b startPosition
								and: [ a stopPosition > b stopPosition ] ] ])
]

{ #category : #private }
GtSmaCCASTFilter >> matchingNodesIn: aNode do: aBlock [
	aNode
		allNodesDo: [ :node | (queryObject applyOn: node) ifNotNil: aBlock ]
]

{ #category : #accessing }
GtSmaCCASTFilter >> query: aString [
	super query: aString.
	queryObject := GtSmaCCASTQuery
		parse: query
		caseSensitive: self caseSensitive
]
