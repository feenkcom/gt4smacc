Class {
	#name : #GtYAMLCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'completer',
		'ast'
	],
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #initialization }
GtYAMLCompletionStrategy >> buildCompleterFrom: anObject [
	| result |
	anObject isNil ifTrue: [ ^ GtYAMLEmptyCompleter instance ].
	anObject isDictionary
		ifTrue: [ result := GtYAMLMappingListCompleter new.
			anObject
				keysAndValuesDo: [ :key :value | 
					| item itemValue |
					itemValue := self buildCompleterFrom: value.
					(self stringsIn: key)
						do: [ :each | 
							item := GtYAMLMappingItemCompleter new.
							item name: each.
							item
								matchesAnything: ((each beginsWith: '<') and: [ each endsWith: '>' ]).
							item value: itemValue.
							result addItem: item ] ].
			^ result ].
	(anObject isString
		and: [ (anObject beginsWith: '<') and: [ anObject endsWith: '>?' ] ])
		ifTrue: [ ^ self completerForLookup: anObject allButLast ].
	(anObject isString or: [ anObject isKindOf: Number ])
		ifTrue: [ ^ GtYAMLValueCompleter new values: (self stringsIn: anObject) ].
	anObject isCollection
		ifTrue: [ ^ GtYAMLListCompleter new value: (self buildCompleterFrom: anObject anyOne) ].
	self error: 'Unknown object type'
]

{ #category : #initialization }
GtYAMLCompletionStrategy >> buildFromJSONSchema: anObject [
	| result type |
	anObject isNil ifTrue: [ ^ GtYAMLEmptyCompleter instance ].
	type := anObject type.
	type = 'boolean'
		ifTrue: [ ^ GtYAMLValueCompleter new values: #('true' 'false') ].
	type = 'string'
		ifTrue: [ ^ GtYAMLValueCompleter new
				values: (anObject enum ifNotNil: [ :v | v collect: #asString ] ifNil: [ #() ]) ].
	type = 'array'
		ifTrue: [ ^ GtYAMLListCompleter new
				value: (self buildFromJSONSchema: (anObject resolveSubSchema: anObject items)) ].
	type = 'object'
		ifTrue: [ result := GtYAMLMappingListCompleter new.
			(anObject properties ifNil: [ Dictionary new ])
				keysAndValuesDo: [ :key :each | 
					result
						addItem: (GtYAMLMappingItemCompleter new
								name: key;
								value: (self buildFromJSONSchema: (anObject resolveSubSchema: each));
								yourself) ].
			^ result ].
	type
		ifNil: [ ^ (anObject anyOf ifNil: [ #() ])
				inject: GtYAMLEmptyCompleter instance
				into: [ :sum :each | sum merge: (self buildFromJSONSchema: (anObject resolveSubSchema: each)) ] ].
	^ GtYAMLEmptyCompleter instance
]

{ #category : #accessing }
GtYAMLCompletionStrategy >> completeNode: node at: positionInteger [
	| current |
	node stopPosition = positionInteger
		ifTrue: [ | parents index |
			current := completer.
			parents := node allParents reversed.
			index := parents detectIndex: [ :each | each isErrorNode ] ifNone: [ 0 ].
			index > 1
				ifTrue: [ index := index - 1.
					(index > 1
						and: [ ((parents at: index) isKindOf: YAMLMappingNode)
								and: [ (parents at: index) colon isNil ] ])
						ifTrue: [ index := index - 1 ] ]
				ifFalse: [ index := parents size ].
			1 to: index do: [ :i | current := current findCompleterFor: (parents at: i) ].
			^ current complete: node source at: positionInteger ].
	^ #()
]

{ #category : #accessing }
GtYAMLCompletionStrategy >> completer [
	^ completer
]

{ #category : #accessing }
GtYAMLCompletionStrategy >> completer: anObject [
	completer := anObject
]

{ #category : #initialization }
GtYAMLCompletionStrategy >> completerForLookup: lookup [
	^ GtYAMLBlockCompleter new
		block: [ :string :pos | 
			self
				findCompletionsOf: string
				at: pos
				withValuesFrom: lookup ]
]

{ #category : #accessing }
GtYAMLCompletionStrategy >> completionResultFor: aText at: positionInteger requested: aBoolean [
	| results |
	[ ast := YAMLParser parseWithErrors: aText asString.
	results := (ast nodeAt: positionInteger)
			ifNil: [ #() ]
			ifNotNil: [ :node | self completeNode: node at: positionInteger ] ]
		ensure: [ ast := nil ].
	^ GtStreamedCompletionResult onStream: results asAsyncStream
]

{ #category : #private }
GtYAMLCompletionStrategy >> findCompletionsOf: aString at: positionInteger withValuesFrom: nameString [
	^ (self potentialValuesOf: aString forLookup: nameString) withoutDuplicates
		collect: [ :each | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: each withSearch: aString)
				completion: (each allButFirst: aString size)
				position: positionInteger
				from: positionInteger - aString size + 1 ]
]

{ #category : #testing }
GtYAMLCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]

{ #category : #initialization }
GtYAMLCompletionStrategy >> loadCompleterFrom: aString [
	completer := self buildCompleterFrom: (YAMLParser parse: aString) object
]

{ #category : #initialization }
GtYAMLCompletionStrategy >> loadCompleterFromJSONSchema: anObject [
	completer := self buildFromJSONSchema: anObject
]

{ #category : #private }
GtYAMLCompletionStrategy >> lookupValuesForPath: aCollection [
	| items |
	items := ast documents.
	aCollection
		do: [ :each | 
			items := items
					flatCollect: [ :node | 
						each
							lookupNodesIn: ((node isKindOf: YAMLMappingNode) ifTrue: [ node value ] ifFalse: [ node ]) ] ].
	^ (items select: [ :each | each isKindOf: YAMLMappingNode ])
		collect: [ :each | each keyObject asString ]
]

{ #category : #private }
GtYAMLCompletionStrategy >> pathsTo: nameString [
	| allPaths |
	allPaths := OrderedCollection new.
	completer
		pathTo: nameString
		current: OrderedCollection new
		do: [ :current | allPaths add: current copy ].
	^ allPaths
]

{ #category : #private }
GtYAMLCompletionStrategy >> potentialValuesOf: aString forLookup: nameString [
	^ ((self pathsTo: nameString)
		collect: [ :each | self lookupValuesForPath: each ]) flatten asAsyncStream
		select: [ :each | each beginsWith: aString ]
]

{ #category : #initialization }
GtYAMLCompletionStrategy >> stringsIn: anObject [
	^ anObject isString
		ifTrue: [ (anObject includes: $,)
				ifTrue: [ anObject substrings: ',' ]
				ifFalse: [ {anObject} ] ]
		ifFalse: [ {anObject printString} ]
]
