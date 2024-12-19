Class {
	#name : #GtYAMLEmptyCompleter,
	#superclass : #GtYAMLCompleter,
	#classInstVars : [
		'instance'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLEmptyCompleter class >> instance [
	^ instance ifNil: [ instance := self new ]
]

{ #category : #accessing }
GtYAMLEmptyCompleter >> findCompleterFor: aYAMLNode [
	^ self
]

{ #category : #merging }
GtYAMLEmptyCompleter >> merge: aCompleter [
	^ aCompleter mergeFromEmpty: self
]
