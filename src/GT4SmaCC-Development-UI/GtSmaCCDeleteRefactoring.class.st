Class {
	#name : 'GtSmaCCDeleteRefactoring',
	#superclass : 'GtSmaCCTransformation',
	#instVars : [
		'rule'
	],
	#category : 'GT4SmaCC-Development-UI-Transformations'
}

{ #category : 'instance creation' }
GtSmaCCDeleteRefactoring class >> delete: aGrammarItem [
	^ self new
		rule: aGrammarItem;
		yourself
]

{ #category : 'execution' }
GtSmaCCDeleteRefactoring >> checkPreconditions [
	rule isReferenced
		ifTrue: [ self error: 'Rule is referenced' ]
]

{ #category : 'accessing' }
GtSmaCCDeleteRefactoring >> rule: aGrammarItem [
	rule := aGrammarItem.
	self grammar: aGrammarItem grammar
]

{ #category : 'execution' }
GtSmaCCDeleteRefactoring >> transform [
	rule delete
]
