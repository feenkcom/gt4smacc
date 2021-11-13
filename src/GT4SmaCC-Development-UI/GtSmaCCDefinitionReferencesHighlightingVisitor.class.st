Class {
	#name : #GtSmaCCDefinitionReferencesHighlightingVisitor,
	#superclass : #GtSmaCCReferencesHighlightingVisitor,
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #visiting }
GtSmaCCDefinitionReferencesHighlightingVisitor >> visitSymbol: aSymbol [
	aSymbol name source = name
		ifTrue: [ self highlight: aSymbol name ].
	^ super visitSymbol: aSymbol
]
