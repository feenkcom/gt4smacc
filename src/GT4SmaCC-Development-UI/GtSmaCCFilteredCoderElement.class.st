Class {
	#name : #GtSmaCCFilteredCoderElement,
	#superclass : #GtSmaCCListCoderElement,
	#instVars : [
		'group'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCFilteredCoderElement >> coderListElementClass [
	^ GtSmaCCCoderListElement
]

{ #category : #accessing }
GtSmaCCFilteredCoderElement >> group [
	^ group
]

{ #category : #accessing }
GtSmaCCFilteredCoderElement >> group: anObject [
	group := anObject
]
