Class {
	#name : #GtJSONCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'completer',
		'ast',
		'node'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONCompletionStrategy >> completeNodeAt: positionInteger requested: aBoolean [
	node stopPosition = positionInteger
		ifTrue: [ ^ (completer findCompleterFor: node at: positionInteger)
				complete: (self completionPrefixAt: positionInteger)
				at: positionInteger
				hasQuote: false ].
	node isErrorNode
		ifTrue: [ (node dismissedTokens
				anySatisfy: [ :each | each stopPosition = positionInteger ])
				ifTrue: [ ^ (completer findCompleterFor: node at: positionInteger)
						complete: (self completionPrefixAt: positionInteger)
						at: positionInteger
						hasQuote: false ] ].
	(node stopPosition - 1 = positionInteger
		and: [ (node isKindOf: JSONStringNode)
				and: [ (node completeSource at: node stopPosition) = $" ] ])
		ifTrue: [ ^ (completer findCompleterFor: node at: positionInteger)
				complete: node value source allButLast
				at: positionInteger
				hasQuote: true ].
	((node isKindOf: JSONMemberNode)
		and: [ node name stopPosition - 1 = positionInteger ])
		ifTrue: [ ^ (completer findCompleterFor: node at: positionInteger)
				complete: node name source allButLast
				at: positionInteger
				hasQuote: true ].
	(aBoolean and: [ node isKindOf: JSONObjectNode ])
		ifTrue: [ ^ (completer findCompleterFor: node at: positionInteger)
				complete: ''
				at: positionInteger
				hasQuote: false ].
	^ #()
]

{ #category : #accessing }
GtJSONCompletionStrategy >> completer [
	^ completer
]

{ #category : #accessing }
GtJSONCompletionStrategy >> completer: aGtJSONCompleter [
	completer := aGtJSONCompleter
]

{ #category : #accessing }
GtJSONCompletionStrategy >> completionPrefixAt: anInteger [
	(node isErrorNode and: [ node dismissedTokens notEmpty ])
		ifTrue: [ ^ node completeSource asString
				copyFrom: node dismissedTokens first startPosition
				to: anInteger ].
	^ node source
]

{ #category : #accessing }
GtJSONCompletionStrategy >> completionResultFor: aText at: positionInteger requested: aBoolean [
	| results |
	[ ast := JSONParser parseWithErrors: aText asString.
	results := (ast nodeAt: positionInteger)
			ifNil: [ #() ]
			ifNotNil: [ :n | 
				node := n.
				self completeNodeAt: positionInteger requested: aBoolean ] ]
		ensure: [ ast := nil.
			node := nil ].
	^ GtStreamedCompletionResult onStream: results asAsyncStream
]
