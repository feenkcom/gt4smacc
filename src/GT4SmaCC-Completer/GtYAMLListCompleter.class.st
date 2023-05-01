Class {
	#name : #GtYAMLListCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'value'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLListCompleter >> findCompleterFor: aYAMLNode [
	(aYAMLNode isKindOf: YAMLFlowListNode) ifTrue: [ ^ value ].
	^ (aYAMLNode isKindOf: YAMLListNode)
		ifTrue: [ self ]
		ifFalse: [ (aYAMLNode isKindOf: YAMLListItemNode)
				ifTrue: [ value ]
				ifFalse: [ GtYAMLEmptyCompleter instance ] ]
]

{ #category : #accessing }
GtYAMLListCompleter >> lookupNodesIn: aNode [
	(aNode isKindOf: YAMLListNode) ifFalse: [ ^ #() ].
	^ aNode items
]

{ #category : #accessing }
GtYAMLListCompleter >> pathTo: nameString current: aCollection do: aBlock [
	aCollection add: self.
	[ value
		pathTo: nameString
		current: aCollection
		do: aBlock ] ensure: [ aCollection removeLast ]
]

{ #category : #accessing }
GtYAMLListCompleter >> value [
	^ value
]

{ #category : #accessing }
GtYAMLListCompleter >> value: aCompleter [
	value := aCompleter
]
