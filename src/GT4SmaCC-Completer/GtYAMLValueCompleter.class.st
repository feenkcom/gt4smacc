Class {
	#name : #GtYAMLValueCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'values'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLValueCompleter >> complete: aString at: positionInteger [
	^ (values select: [ :each | each beginsWith: aString ])
		collect: [ :each | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: each withSearch: aString)
				completion: (each allButFirst: aString size)
				position: positionInteger
				from: positionInteger - aString size + 1 ]
]

{ #category : #merging }
GtYAMLValueCompleter >> merge: aCompleter [
	^ aCompleter mergeFromValue: self
]

{ #category : #merging }
GtYAMLValueCompleter >> mergeFromValue: aCompleter [
	| vals |
	vals := Set withAll: values.
	vals addAll: aCompleter values.
	^ self class new values: vals asSortedCollection
]

{ #category : #accessing }
GtYAMLValueCompleter >> values [
	^ values
]

{ #category : #accessing }
GtYAMLValueCompleter >> values: stringCollection [
	values := stringCollection
]

{ #category : #converting }
GtYAMLValueCompleter >> yamlOn: stream indent: anInteger [
	stream << (',' join: values)
]
