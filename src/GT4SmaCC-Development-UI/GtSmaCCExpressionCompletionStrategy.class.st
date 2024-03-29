Class {
	#name : #GtSmaCCExpressionCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#instVars : [
		'codeCompletionStrategy',
		'token'
	],
	#category : #'GT4SmaCC-Development-UI-Completion'
}

{ #category : #'instance creation' }
GtSmaCCExpressionCompletionStrategy class >> onToken: aSmaCCToken [
	^ self new
		token: aSmaCCToken;
		yourself
]

{ #category : #accessing }
GtSmaCCExpressionCompletionStrategy >> completionActionStreamFor: aText at: positionInteger requested: aBoolean [
	| first last |
	first := positionInteger.
	[ first > 0
		and:
			[ (aText attributesAt: first)
				anySatisfy: [ :each | each class = GtCompletionStrategyAttribute and: [ each strategy == self ] ] ] ]
		whileTrue: [ first := first - 1 ].
	last := positionInteger.
	[ last <= aText size
		and:
			[ (aText attributesAt: last)
				anySatisfy: [ :each | each class = GtCompletionStrategyAttribute and: [ each strategy == self ] ] ] ]
		whileTrue: [ last := last + 1 ].
	^ (codeCompletionStrategy
		completionActionStreamFor: (aText from: first + 1 to: last - 1)
		at: positionInteger - first
		requested: aBoolean) relay: [ :each | each translateBy: first ]
]

{ #category : #testing }
GtSmaCCExpressionCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]

{ #category : #'initialize-release' }
GtSmaCCExpressionCompletionStrategy >> initialize [
	super initialize.
	codeCompletionStrategy := GtPharoCompletionStrategy newForExpression.
	codeCompletionStrategy classOrMetaClass: SmaCCParser
]

{ #category : #accessing }
GtSmaCCExpressionCompletionStrategy >> token [
	^ token
]

{ #category : #accessing }
GtSmaCCExpressionCompletionStrategy >> token: aSmaCCToken [
	token := aSmaCCToken
]
