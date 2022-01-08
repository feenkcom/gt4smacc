Class {
	#name : #GtSmaCCTransformedAttribute,
	#superclass : #BlTextDecorationAttribute,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'initialize-release' }
GtSmaCCTransformedAttribute >> initialize [
	super initialize.
	self color: BrGlamorousColors textHighlightColor.
	self thickness: 3.
	self underline.
	self beNotOverwritableByStyler
]
