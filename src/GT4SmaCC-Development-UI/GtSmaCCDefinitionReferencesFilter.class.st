Class {
	#name : #GtSmaCCDefinitionReferencesFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'name'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCDefinitionReferencesFilter class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #accessing }
GtSmaCCDefinitionReferencesFilter >> highlighter [
	^ GtSmaCCReferencesHighlightingVisitor name: name
]

{ #category : #testing }
GtSmaCCDefinitionReferencesFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCCoder)
		ifFalse: [ ^ false ].
	anObject ast
		withAllNodesDo: [ :each | 
			((each isKindOf: SmaCCSymbolNode)
				or: [ each isKindOf: SmaCCTokenRegexNode ])
				ifTrue: [ each name source = name
						ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #accessing }
GtSmaCCDefinitionReferencesFilter >> name: aString [
	name := aString
]
