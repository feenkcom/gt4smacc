Class {
	#name : #GtSmaCCAmbiguousShiftAction,
	#superclass : #GtSmaCCAmbiguousAction,
	#instVars : [
		'tokenId'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #comparing }
GtSmaCCAmbiguousShiftAction >> = anObject [
	^ self class = anObject class and: [ self tokenId = anObject tokenId ]
]

{ #category : #accessing }
GtSmaCCAmbiguousShiftAction >> actionName [
	^ 'Shift ' , (self symbolNameFor: tokenId)
]

{ #category : #comparing }
GtSmaCCAmbiguousShiftAction >> hash [
	^ self class hash hashMultiply bitXor: self tokenId hash
]

{ #category : #accessing }
GtSmaCCAmbiguousShiftAction >> tokenId [
	^ tokenId
]

{ #category : #accessing }
GtSmaCCAmbiguousShiftAction >> tokenId: anObject [
	tokenId := anObject
]
