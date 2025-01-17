Class {
	#name : #GtYAMLKeyMatchCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'keyCompleters',
		'defaultCompleter'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #'as yet unclassified' }
GtYAMLKeyMatchCompleter >> add: completer forKey: aString [
	keyCompleters at: aString put: completer
]

{ #category : #accessing }
GtYAMLKeyMatchCompleter >> defaultCompleter [
	^ defaultCompleter
]

{ #category : #accessing }
GtYAMLKeyMatchCompleter >> defaultCompleter: anObject [
	defaultCompleter := anObject
]

{ #category : #'as yet unclassified' }
GtYAMLKeyMatchCompleter >> findCompleterFor: aYAMLNode [
	(aYAMLNode isKindOf: YAMLMappingNode)
		ifTrue: [ keyCompleters at: aYAMLNode keyObject ifPresent: [ :each | ^ each ] ].
	^ self copy defaultCompleter: (defaultCompleter findCompleterFor: aYAMLNode)
]

{ #category : #'as yet unclassified' }
GtYAMLKeyMatchCompleter >> initialize [
	super initialize.
	keyCompleters := Dictionary new
]
