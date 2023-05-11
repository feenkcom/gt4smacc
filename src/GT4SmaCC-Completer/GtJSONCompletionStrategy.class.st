Class {
	#name : #GtJSONCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'completer',
		'ast'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONCompletionStrategy >> completeNode: node at: positionInteger [
	node stopPosition = positionInteger
		ifTrue: [ ^ (completer findCompleterFor: node)
				complete: (self completionPrefixFor: node)
				at: positionInteger ].
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
GtJSONCompletionStrategy >> completionPrefixFor: node [
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
			ifNotNil: [ :node | self completeNode: node at: positionInteger ] ]
		ensure: [ ast := nil ].
	^ GtStreamedCompletionResult onStream: results asAsyncStream
]
