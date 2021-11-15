Class {
	#name : #GtSmaCCHighlightingVisitor,
	#superclass : #GtSmaCCStylingVisitor,
	#classVars : [
		'HighlightAttributes'
	],
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'class initialization' }
GtSmaCCHighlightingVisitor class >> initialize [
	HighlightAttributes := {(BlTextUnderlineAttribute new
		color: BrGlamorousColors textHighlightColor;
		thickness: 3)}
]

{ #category : #private }
GtSmaCCHighlightingVisitor >> highlight: aNodeOrToken [
	self
		highlightFrom: aNodeOrToken startPosition
		to: aNodeOrToken stopPosition
]

{ #category : #private }
GtSmaCCHighlightingVisitor >> highlightFrom: fromInteger to: toInteger [
	(self text from: fromInteger to: toInteger)
		attributes: HighlightAttributes
]
