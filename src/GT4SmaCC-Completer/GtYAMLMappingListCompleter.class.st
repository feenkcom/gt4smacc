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

{ #category : #accessing }
GtYAMLMappingListCompleter >> pathTo: nameString current: aCollection do: aBlock [
	items
		do: [ :each | 
			each
				pathTo: nameString
				current: aCollection
				do: aBlock ]
]
