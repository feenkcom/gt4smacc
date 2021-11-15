Class {
	#name : #GtSmaCCImplementorHighlightingVisitor,
	#superclass : #GtSmaCCHighlightingVisitor,
	#instVars : [
		'pattern'
	],
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'instance creation' }
GtSmaCCImplementorHighlightingVisitor class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #private }
GtSmaCCImplementorHighlightingVisitor >> highlightName: aToken [
	| name index |
	name := aToken source asLowercase.
	index := 0.
	[ (index := name indexOfSubCollection: pattern startingAt: index + 1)
		> 0 ]
		whileTrue: [ self
				highlightFrom: aToken startPosition + index - 1
				to: aToken startPosition + index + pattern size - 2 ]
]

{ #category : #accessing }
GtSmaCCImplementorHighlightingVisitor >> pattern [
	^ pattern
]

{ #category : #accessing }
GtSmaCCImplementorHighlightingVisitor >> pattern: aString [
	pattern := aString asLowercase
]

{ #category : #visiting }
GtSmaCCImplementorHighlightingVisitor >> visitProductionRule: aProductionRule [
	self highlightName: aProductionRule name.
	super visitProductionRule: aProductionRule
]

{ #category : #visiting }
GtSmaCCImplementorHighlightingVisitor >> visitTokenRule: aTokenRule [
	self highlightName: aTokenRule name.
	super visitTokenRule: aTokenRule
]
