Class {
	#name : #GtSmaCCTransformedAttribute,
	#superclass : #BlTextUnderlineAttribute,
	#category : #'GT-SmaCC-Rewrite-Engine-UI'
}

{ #category : #'initialize-release' }
GtSmaCCTransformedAttribute >> initialize [
	super initialize.
	self paint: Color black.
	self width: 2.
	self beNotOverwritableByStyler
]
