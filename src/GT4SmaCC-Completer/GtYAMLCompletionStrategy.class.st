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

{ #category : #accessing }
GtYAMLCompletionStrategy >> completeNode: node at: positionInteger [
	| current itemToComplete nodeToComplete parents index keyValueNode listItemNode |
	itemToComplete := node.
	node isErrorNode
		ifTrue: [ node
				nodesDo: [ :each |  ]
				andTokensDo: [ :each | each stopPosition = positionInteger ifTrue: [ itemToComplete := each ] ]
				includeErrors: true ].
	itemToComplete stopPosition = positionInteger
		ifTrue: [ nodeToComplete := node ]
		ifFalse: [ ast
				withAllNodesOfType: YAMLMappingNode
				do: [ :each | 
					(each key stopPosition <= positionInteger
						and: [ keyValueNode isNil
								or: [ keyValueNode key stopPosition < each key stopPosition ] ])
						ifTrue: [ keyValueNode := each ] ].
			ast
				withAllNodesOfType: YAMLListItemNode
				do: [ :each | 
					each minus startPosition < positionInteger
						ifTrue: [ (keyValueNode isNil
								or: [ each minus startPosition > keyValueNode key stopPosition ])
								ifTrue: [ keyValueNode := nil.
									(listItemNode isNil
										or: [ listItemNode minus startPosition < each minus startPosition ])
										ifTrue: [ listItemNode := each ] ] ] ].
			keyValueNode
				ifNil: [ nodeToComplete := listItemNode
							ifNil: [ node topParent ]
							ifNotNil: [ listItemNode value
									ifNil: [ SmaCCParseNode new
											parent: listItemNode;
											yourself ]
									ifNotNil: [ nil ] ] ]
				ifNotNil: [ (self startOfLineWSCountAt: positionInteger)
						ifNil: [ keyValueNode value
								ifNil: [ itemToComplete := nil.
									nodeToComplete := SmaCCParseNode new
											parent: keyValueNode;
											yourself ] ]
						ifNotNil: [ :count | 
							current := keyValueNode.
							[ current notNil
								and: [ (self startOfLineCharacterCountAt: current startPosition - 1) > count ] ]
								whileTrue: [ keyValueNode := current.
									current := current parentOfType: YAMLMappingNode ].
							current notNil ifTrue: [ keyValueNode := current ].
							nodeToComplete := (self
									startOfLineCharacterCountAt: keyValueNode startPosition - 1) < count
									ifTrue: [ SmaCCParseNode new
											parent: keyValueNode;
											yourself ]
									ifFalse: [ keyValueNode ] ] ] ].
	nodeToComplete
		ifNotNil: [ current := completer.
			parents := nodeToComplete allParents reversed.
			index := parents detectIndex: [ :each | each isErrorNode ] ifNone: [ 0 ].
			index > 1
				ifTrue: [ index := index - 1.
					(index > 1
						and: [ ((parents at: index) isKindOf: YAMLMappingNode)
								and: [ (parents at: index) colon isNil ] ])
						ifTrue: [ index := index - 1 ] ]
				ifFalse: [ index := parents size ].
			1 to: index do: [ :i | current := current findCompleterFor: (parents at: i) ].
			^ current
				complete: ((itemToComplete isNil
						or: [ positionInteger = 0
								or: [ (node topParent completeSource at: positionInteger) isSeparator ] ])
						ifTrue: [ '' ]
						ifFalse: [ itemToComplete source ])
				at: positionInteger ].
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
		name: lookup;
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
	completer := GtYAMLCompleter forJSONSchema: anObject
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

{ #category : #accessing }
GtYAMLCompletionStrategy >> startOfLineCharacterCountAt: anInteger [
	| source index count |
	source := ast topParent completeSource.
	index := anInteger.
	count := 0.
	[ index > 0 and: [ (String crlf includes: (source at: index)) not ] ]
		whileTrue: [ index := index - 1.
			count := count + 1 ].
	^ count
]

{ #category : #accessing }
GtYAMLCompletionStrategy >> startOfLineWSCountAt: anInteger [
	| source index count char |
	source := ast topParent completeSource.
	index := anInteger.
	count := 0.
	[ index > 0
		and: [ (char := source at: index) isSeparator
				and: [ (String crlf includes: char) not ] ] ]
		whileTrue: [ index := index - 1.
			count := count + 1 ].
	^ (index <= 0 or: [ String crlf includes: char ]) ifTrue: [ count ]
]

{ #category : #initialization }
GtYAMLCompletionStrategy >> stringsIn: anObject [
	^ anObject isString
		ifTrue: [ (anObject includes: $,)
				ifTrue: [ anObject substrings: ',' ]
				ifFalse: [ {anObject} ] ]
		ifFalse: [ {anObject printString} ]
]
