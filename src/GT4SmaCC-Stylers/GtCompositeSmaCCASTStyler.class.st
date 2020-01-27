Class {
	#name : #GtCompositeSmaCCASTStyler,
	#superclass : #GtSmaCCASTStyler,
	#instVars : [
		'stylers'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #private }
GtCompositeSmaCCASTStyler >> style: aText using: anAST [
	text := aText.
	self stylers do: [ :each | each style: aText using: anAST ].
	^ text
]

{ #category : #accessing }
GtCompositeSmaCCASTStyler >> stylers [
	^ stylers ifNil: [ #() ]
]

{ #category : #accessing }
GtCompositeSmaCCASTStyler >> stylers: aCollection [
	stylers := aCollection
]
