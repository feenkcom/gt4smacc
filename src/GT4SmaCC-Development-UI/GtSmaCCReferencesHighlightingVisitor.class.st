Class {
	#name : #GtSmaCCReferencesHighlightingVisitor,
	#superclass : #GtSmaCCHighlightingVisitor,
	#instVars : [
		'name'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'instance creation' }
GtSmaCCReferencesHighlightingVisitor class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #visiting }
GtSmaCCReferencesHighlightingVisitor >> visitSymbol: aSymbol [
	aSymbol name source = name
		ifTrue: [ self highlight: aSymbol name ].
	^ super visitSymbol: aSymbol
]
