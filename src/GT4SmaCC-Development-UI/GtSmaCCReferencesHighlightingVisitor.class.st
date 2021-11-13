Class {
	#name : #GtSmaCCReferencesHighlightingVisitor,
	#superclass : #GtSmaCCHighlightingVisitor,
	#instVars : [
		'name'
	],
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'instance creation' }
GtSmaCCReferencesHighlightingVisitor class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #'initialize-release' }
GtSmaCCReferencesHighlightingVisitor >> name: aString [
	name := aString
]
