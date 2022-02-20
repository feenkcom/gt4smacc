Class {
	#name : #GtCompositeSmaCCASTStyler,
	#superclass : #GtSmaCCASTStyler,
	#instVars : [
		'stylers'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #private }
GtCompositeSmaCCASTStyler >> style: aText ast: anAST [
	self stylers do: [ :each | each style: aText ast: anAST ]
]

{ #category : #accessing }
GtCompositeSmaCCASTStyler >> stylers [
	^ stylers ifNil: [ #() ]
]

{ #category : #accessing }
GtCompositeSmaCCASTStyler >> stylers: aCollection [
	stylers := aCollection
]
