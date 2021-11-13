Class {
	#name : #GtSmaCCCoderElementHolder,
	#superclass : #BlInfiniteHolder,
	#category : 'GT4SmaCC-Development-UI-Coders'
}

{ #category : #accessing }
GtSmaCCCoderElementHolder >> coderElement: anElement [
	anElement removeFromParent.
	self initializeWith: anElement
]
