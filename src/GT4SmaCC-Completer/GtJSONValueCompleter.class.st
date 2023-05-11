Class {
	#name : #GtJSONValueCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'values'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONValueCompleter >> addValue: aString [
	values add: aString
]

{ #category : #accessing }
GtJSONValueCompleter >> complete: aString at: positionInteger [
	^ (values select: [ :each | each beginsWith: aString ])
		collect: [ :each | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: each withSearch: aString)
				completion: (each allButFirst: aString size)
				position: positionInteger
				from: positionInteger - aString size + 1 ]
]

{ #category : #accessing }
GtJSONValueCompleter >> initialize [
	super initialize.
	values := OrderedCollection new
]
