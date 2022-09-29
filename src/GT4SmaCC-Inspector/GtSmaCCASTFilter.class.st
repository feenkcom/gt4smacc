Class {
	#name : #GtSmaCCASTFilter,
	#superclass : #Object,
	#instVars : [
		'caseSensitive'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #private }
GtSmaCCASTFilter >> applyInScope: aStream context: aSpotterContext [
	| query |
	query := GtSmaCCASTQuery
			parse: aSpotterContext searchQuery
			caseSensitive: caseSensitive.
	^ ((aStream collect: [ :each | query applyOn: each ]) select: #notNil)
		withoutDuplicates useIdentityComparison
]

{ #category : #accessing }
GtSmaCCASTFilter >> caseSensitive: aBoolean [
	caseSensitive := aBoolean
]

{ #category : #initialization }
GtSmaCCASTFilter >> initialize [
	super initialize.
	caseSensitive := false
]
