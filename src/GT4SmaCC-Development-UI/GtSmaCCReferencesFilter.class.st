Class {
	#name : 'GtSmaCCReferencesFilter',
	#superclass : 'GtSmaCCDefinitionsFilter',
	#instVars : [
		'name'
	],
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : 'instance creation' }
GtSmaCCReferencesFilter class >> name: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : 'accessing' }
GtSmaCCReferencesFilter >> highlighter [
	^ self highlighterClass name: name
]

{ #category : 'accessing' }
GtSmaCCReferencesFilter >> highlighterClass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
GtSmaCCReferencesFilter >> name: aString [
	name := aString
]
