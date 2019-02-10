Class {
	#name : #GtSmaCCTokenStylerRule,
	#superclass : #GtSmaCCStylerRule,
	#instVars : [
		'tokenName',
		'id'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #'instance creation' }
GtSmaCCTokenStylerRule class >> tokenName: aString styleBlock: aBlock [
	^ (self styleBlock: aBlock)
		tokenName: aString;
		yourself
]

{ #category : #initialization }
GtSmaCCTokenStylerRule >> initializeForParser: parserClass [
	| parser |
	parser := parserClass basicNew.
	id := parser symbolNames indexOf: tokenName
]

{ #category : #asserting }
GtSmaCCTokenStylerRule >> shouldApplyToToken: aSmaCCToken [
	^ id = aSmaCCToken ids first
]

{ #category : #accessing }
GtSmaCCTokenStylerRule >> tokenName [
	^ tokenName
]

{ #category : #accessing }
GtSmaCCTokenStylerRule >> tokenName: aString [
	tokenName := aString
]
