Class {
	#name : #GtSmaCCParentQuery,
	#superclass : #GtSmaCCASTQuery,
	#instVars : [
		'parentType',
		'query',
		'caseSensitive'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #applying }
GtSmaCCParentQuery >> applyOn: aNode [
	^ (query applyOn: aNode) ifNotNil: [ :node | self findParent: node ]
]

{ #category : #accessing }
GtSmaCCParentQuery >> caseSensitive [
	^ caseSensitive
]

{ #category : #accessing }
GtSmaCCParentQuery >> caseSensitive: aString [
	caseSensitive := aString
]

{ #category : #private }
GtSmaCCParentQuery >> findParent: aNode [
	| node |
	node := aNode.
	[ node notNil ]
		whileTrue: [ (node class name
				findString: parentType
				startingAt: 1
				caseSensitive: self caseSensitive) > 0
				ifTrue: [ ^ node ].
			node := node parent ].
	^ nil
]

{ #category : #accessing }
GtSmaCCParentQuery >> parentType [
	^ parentType
]

{ #category : #accessing }
GtSmaCCParentQuery >> parentType: aString [
	parentType := aString
]

{ #category : #accessing }
GtSmaCCParentQuery >> query [
	^ query
]

{ #category : #accessing }
GtSmaCCParentQuery >> query: aASTQuery [
	query := aASTQuery
]
