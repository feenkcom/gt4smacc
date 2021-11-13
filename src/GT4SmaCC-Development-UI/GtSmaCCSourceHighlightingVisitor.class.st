Class {
	#name : #GtSmaCCSourceHighlightingVisitor,
	#superclass : #GtSmaCCHighlightingVisitor,
	#instVars : [
		'pattern'
	],
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'instance creation' }
GtSmaCCSourceHighlightingVisitor class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #accessing }
GtSmaCCSourceHighlightingVisitor >> pattern: aString [
	pattern := aString asLowercase
]

{ #category : #styling }
GtSmaCCSourceHighlightingVisitor >> styleNode: aNode using: aStyler [
	| string index |
	styler := aStyler.
	string := self text asString asLowercase.
	index := 1.
	[ index := string indexOfSubCollection: pattern startingAt: index.
	index > 0 ]
		whileTrue: [ self highlightFrom: index to: index + pattern size - 1.
			index := index + pattern size ]
]
