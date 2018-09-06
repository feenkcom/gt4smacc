Class {
	#name : #FkSmaCCExpressionCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'codeCompletionStrategy',
		'token'
	],
	#category : #'GT-SmaCC-Development-UI'
}

{ #category : #'instance creation' }
FkSmaCCExpressionCompletionStrategy class >> onToken: aSmaCCToken [
	^ self new
		token: aSmaCCToken;
		yourself
]

{ #category : #accessing }
FkSmaCCExpressionCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxSize [
	| actions first last |
	first := positionInteger.
	[ first > 0
		and: [ (aText attributesAt: first) anySatisfy: [ :each | each class = GtCompletionStrategyAttribute and: [ each strategy == self ] ] ] ]
		whileTrue: [ first := first - 1 ].
	last := positionInteger.
	[ last <= aText size
		and: [ (aText attributesAt: last) anySatisfy: [ :each | each class = GtCompletionStrategyAttribute and: [ each strategy == self ] ] ] ]
		whileTrue: [ last := last + 1 ].
	actions := codeCompletionStrategy
		completionActionsFor: (aText from: first + 1 to: last - 1)
		at: positionInteger - first
		max: maxSize.
	actions do: [ :each | each translateBy: first ].
	^ actions
]

{ #category : #testing }
FkSmaCCExpressionCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]

{ #category : #'initialize-release' }
FkSmaCCExpressionCompletionStrategy >> initialize [
	super initialize.
	codeCompletionStrategy := GtPharoCompletionStrategy newForExpression.
	codeCompletionStrategy classOrMetaClass: SmaCCParser
]

{ #category : #accessing }
FkSmaCCExpressionCompletionStrategy >> token [
	^ token
]

{ #category : #accessing }
FkSmaCCExpressionCompletionStrategy >> token: aSmaCCToken [
	token := aSmaCCToken
]
