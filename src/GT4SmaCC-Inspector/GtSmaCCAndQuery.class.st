Class {
	#name : #GtSmaCCAndQuery,
	#superclass : #GtSmaCCASTQuery,
	#instVars : [
		'queries'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #applying }
GtSmaCCAndQuery >> applyOn: aNode [
	^ queries
		inject: nil
		into: [ :result :each | 
			| value |
			value := each applyOn: aNode.
			value isNil
				ifTrue: [ ^ nil ].
			result isNil
				ifTrue: [ value ]
				ifFalse: [ self findCommonParentBetween: result and: value ] ]
]

{ #category : #private }
GtSmaCCAndQuery >> findCommonParentBetween: firstNode and: secondNode [
	(firstNode isDescendantFrom: secondNode)
		ifTrue: [ ^ secondNode ].
	(secondNode isDescendantFrom: firstNode)
		ifTrue: [ ^ firstNode ].
	^ self
		findCommonParentBetween: firstNode parent
		and: secondNode parent
]

{ #category : #accessing }
GtSmaCCAndQuery >> queries [
	^ queries
]

{ #category : #accessing }
GtSmaCCAndQuery >> queries: aCollection [
	queries := aCollection
]
