Class {
	#name : #GtSmaCCGroupCoderInfiniteElement,
	#superclass : #BlInfiniteElement,
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #initialization }
GtSmaCCGroupCoderInfiniteElement >> defaultLayout [
	^ BlInfiniteLinearLayout vertical
]

{ #category : #initialization }
GtSmaCCGroupCoderInfiniteElement >> initialize [
	super initialize.
	self padding: (BlInsets right: 10)
]
