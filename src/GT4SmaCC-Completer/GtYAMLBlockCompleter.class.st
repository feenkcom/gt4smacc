Class {
	#name : #GtYAMLBlockCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'block'
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
