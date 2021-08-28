Class {
	#name : 'GtSmaCCVariableReferencesHighlightingVisitor',
	#superclass : 'GtSmaCCReferencesHighlightingVisitor',
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : 'visting' }
GtSmaCCVariableReferencesHighlightingVisitor >> visitSymbol: aSymbol [
	aSymbol variableNameToken notNil
		ifTrue: [ aSymbol variableNameToken source = name
				ifTrue: [ self highlight: aSymbol variableNameToken ] ].
	^ super visitSymbol: aSymbol
]
