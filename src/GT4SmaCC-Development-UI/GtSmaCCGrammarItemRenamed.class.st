Class {
	#name : #GtSmaCCGrammarItemRenamed,
	#superclass : #GtSmaCCGrammarItemChanged,
	#instVars : [
		'previousName',
		'newName'
	],
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #testing }
GtSmaCCGrammarItemRenamed >> isRename [
	^ true
]

{ #category : #accessing }
GtSmaCCGrammarItemRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtSmaCCGrammarItemRenamed >> newName: aString [
	newName := aString
]

{ #category : #accessing }
GtSmaCCGrammarItemRenamed >> previousName [
	^ previousName
]

{ #category : #accessing }
GtSmaCCGrammarItemRenamed >> previousName: aString [
	previousName := aString
]
