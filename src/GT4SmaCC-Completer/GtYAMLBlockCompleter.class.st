Class {
	#name : #GtYAMLBlockCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'block',
		'name'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLBlockCompleter >> block [
	^ block
]

{ #category : #accessing }
GtYAMLBlockCompleter >> block: anObject [
	block := anObject
]

{ #category : #accessing }
GtYAMLBlockCompleter >> complete: aString at: positionInteger [
	^ block value: aString value: positionInteger
]

{ #category : #merging }
GtYAMLBlockCompleter >> merge: aCompleter [
	^ aCompleter mergeFromBlock: self
]

{ #category : #accessing }
GtYAMLBlockCompleter >> name [
	^ name
]

{ #category : #accessing }
GtYAMLBlockCompleter >> name: anObject [
	name := anObject
]

{ #category : #converting }
GtYAMLBlockCompleter >> yamlOn: stream indent: anInteger [
	name ifNil: [ ^ self ].
	stream << name << '?'
]
