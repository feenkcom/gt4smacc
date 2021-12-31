Class {
	#name : #GtSmaCCTransformedAttribute,
	#superclass : #BlTextDecorationAttribute,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'initialize-release' }
GtSmaCCTransformedAttribute >> initialize [
	super initialize.
	self color: Color black.
	self thickness: 2.
	self underline.
	self beNotOverwritableByStyler
]
