Class {
	#name : #GtYAMLMappingItemCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'name',
		'value',
		'matchesAnything'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLMappingItemCompleter >> findCompleterFor: aYAMLNode [
	^ value
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> lookupNodesIn: aNode [
	(aNode isKindOf: YAMLMappingListNode) ifFalse: [ ^ #() ].
	^ self matchesAnything
		ifTrue: [ aNode mappings ]
		ifFalse: [ aNode mappings select: [ :each | each keyObject = name ] ]
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> matches: aYAMLNode [
	^ (aYAMLNode isKindOf: YAMLMappingNode)
		and: [ self matchesAnything or: [ name = aYAMLNode keyObject ] ]
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> matchesAnything [
	^ matchesAnything ifNil: [ false ]
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> matchesAnything: aBoolean [
	matchesAnything := aBoolean
]

{ #category : #merging }
GtYAMLMappingItemCompleter >> merge: aCompleter [
	^ aCompleter mergeFromMappingItem: self
]

{ #category : #merging }
GtYAMLMappingItemCompleter >> mergeFromMappingItem: aCompleter [
	name ~= aCompleter name ifTrue: [ ^ super mergeFromMappingItem: aCompleter ].
	^ self class new
		name: name;
		value: (value merge: aCompleter value)
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> name [
	^ name
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> name: aString [
	name := aString
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> pathTo: nameString current: aCollection do: aBlock [
	aCollection add: self.
	[ (self matchesAnything and: [ nameString = name ])
		ifTrue: [ aBlock value: aCollection ].
	value
		pathTo: nameString
		current: aCollection
		do: aBlock ] ensure: [ aCollection removeLast ]
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> value [
	^ value
]

{ #category : #accessing }
GtYAMLMappingItemCompleter >> value: anObject [
	value := anObject
]

{ #category : #converting }
GtYAMLMappingItemCompleter >> yamlOn: stream indent: anInteger [
	stream << name << ': '.
	value yamlOn: stream indent: anInteger + 1
]
