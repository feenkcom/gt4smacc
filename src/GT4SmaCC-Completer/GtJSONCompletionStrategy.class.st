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
GtJSONCompletionStrategy >> completeNodeAt: positionInteger [
	node stopPosition = positionInteger
		ifTrue: [ ^ (completer findCompleterFor: node)
				complete: self completionPrefix
				at: positionInteger
				hasQuote: false ].
	(node stopPosition - 1 = positionInteger
		and: [ (node isKindOf: JSONStringNode)
				and: [ (node completeSource at: node stopPosition) = $" ] ])
		ifTrue: [ ^ (completer findCompleterFor: node)
				complete: node value source allButLast
				at: positionInteger
				hasQuote: true ].
	((node isKindOf: JSONMemberNode)
		and: [ node name stopPosition - 1 = positionInteger ])
		ifTrue: [ ^ (completer findCompleterFor: node)
				complete: node name source allButLast
				at: positionInteger
				hasQuote: true ].
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
GtJSONCompletionStrategy >> completionPrefix [
	(node isErrorNode and: [ node dismissedTokens notEmpty ])
		ifTrue: [ ^ node completeSource asString
				copyFrom: node dismissedTokens first startPosition
				to: node dismissedTokens last stopPosition ].
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
				self completeNodeAt: positionInteger ] ]
		ensure: [ ast := nil.
			node := nil ].
	^ GtStreamedCompletionResult onStream: results asAsyncStream
]
