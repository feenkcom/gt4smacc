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

{ #category : #merging }
GtYAMLListCompleter >> merge: aCompleter [
	^ aCompleter mergeFromList: self
]

{ #category : #merging }
GtYAMLListCompleter >> mergeFromList: aCompleter [
	^ self class new value: (value merge: aCompleter value)
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

{ #category : #converting }
GtYAMLListCompleter >> yamlOn: stream indent: anInteger [
	stream position > 0
		ifTrue: [ stream
				cr;
				next: anInteger * 2 put: $  ].
	stream << '- '.
	value yamlOn: stream indent: anInteger + 1
]
