Class {
	#name : #GtYAMLKeyMatchCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'keyCompleters',
		'defaultCompleter'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #adding }
GtYAMLKeyMatchCompleter >> add: completer forKey: aString [
	keyCompleters at: aString put: completer
]

{ #category : #accessing }
GtYAMLKeyMatchCompleter >> complete: aString at: positionInteger [
	^ defaultCompleter complete: aString at: positionInteger
]

{ #category : #accessing }
GtYAMLKeyMatchCompleter >> defaultCompleter [
	^ defaultCompleter
]

{ #category : #accessing }
GtYAMLKeyMatchCompleter >> defaultCompleter: anObject [
	defaultCompleter := anObject
]

{ #category : #accessing }
GtYAMLKeyMatchCompleter >> findCompleterFor: aYAMLNode [
	(aYAMLNode isKindOf: YAMLMappingNode)
		ifTrue: [ keyCompleters at: aYAMLNode keyObject ifPresent: [ :each | ^ each ] ].
	^ self copy defaultCompleter: (defaultCompleter findCompleterFor: aYAMLNode)
]

{ #category : #initialization }
GtYAMLKeyMatchCompleter >> initialize [
	super initialize.
	keyCompleters := Dictionary new
]
