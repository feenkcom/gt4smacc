Class {
	#name : #GtYAMLMappingListCompleter,
	#superclass : #GtYAMLCompleter,
	#instVars : [
		'items'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLMappingListCompleter >> addItem: aMappingItemCompleter [
	items add: aMappingItemCompleter
]

{ #category : #accessing }
GtYAMLMappingListCompleter >> complete: aString at: positionInteger [
	^ (items
		select: [ :each | each matchesAnything not and: [ each name beginsWith: aString ] ])
		collect: [ :each | 
			| value |
			value := each name , ':'.
			GtInsertTextCompletionAction
				labeled: (self labelFor: value withSearch: aString)
				completion: (value allButFirst: aString size)
				position: positionInteger
				from: positionInteger - aString size + 1 ]
]

{ #category : #accessing }
GtYAMLMappingListCompleter >> findCompleterFor: aYAMLNode [
	((aYAMLNode isKindOf: YAMLFileNode)
		or: [ aYAMLNode isKindOf: YAMLMappingListNode ]) ifTrue: [ ^ self ].
	(aYAMLNode isKindOf: YAMLMappingNode)
		ifTrue: [ items do: [ :each | (each matches: aYAMLNode) ifTrue: [ ^ each value ] ] ].
	^ GtYAMLEmptyCompleter instance
]

{ #category : #initialization }
GtYAMLMappingListCompleter >> initialize [
	super initialize.
	items := OrderedCollection new
]

{ #category : #merging }
GtYAMLMappingListCompleter >> items [
	^ items
]

{ #category : #merging }
GtYAMLMappingListCompleter >> merge: aCompleter [
	^ aCompleter mergeFromMappingList: self
]

{ #category : #merging }
GtYAMLMappingListCompleter >> mergeFromMappingList: aCompleter [
	| result myGroups otherGroups otherValue |
	result := self class new.
	myGroups := items groupedBy: #name.
	otherGroups := aCompleter items groupedBy: #name.
	myGroups
		keysAndValuesDo: [ :key :myValue | 
			otherValue := otherGroups removeKey: key ifAbsent: [ #() ].
			result
				addItem: (GtYAMLMappingItemCompleter new
						name: key;
						value: (myValue , otherValue
								inject: GtYAMLEmptyCompleter instance
								into: [ :sum :each | sum merge: each value ]);
						yourself) ].
	otherGroups
		keysAndValuesDo: [ :key :value | 
			result
				addItem: (GtYAMLMappingItemCompleter new
						name: key;
						value: (value
								inject: GtYAMLEmptyCompleter instance
								into: [ :sum :each | sum merge: each value ]);
						yourself) ].
	^ result
]

{ #category : #accessing }
GtYAMLMappingListCompleter >> pathTo: nameString current: aCollection do: aBlock [
	items
		do: [ :each | 
			each
				pathTo: nameString
				current: aCollection
				do: aBlock ]
]

{ #category : #'as yet unclassified' }
GtYAMLMappingListCompleter >> yamlOn: stream indent: anInteger [
	items
		do: [ :each | 
			stream position > 0
				ifTrue: [ stream
						cr;
						next: anInteger * 2 put: $  ].
			each yamlOn: stream indent: anInteger ]
]
