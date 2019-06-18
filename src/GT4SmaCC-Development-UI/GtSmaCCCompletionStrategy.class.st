Class {
	#name : #GtSmaCCCompletionStrategy,
	#superclass : #GtWeightedStringsCompletionStrategy,
	#category : #'GT4SmaCC-Development-UI-Completion'
}

{ #category : #private }
GtSmaCCCompletionStrategy >> complete: label with: insertedText deleting: deleteSize at: positionInteger prefixSize: prefixSize [
	| insertionAction deleteAction |
	insertionAction := GtInsertTextCompletionAction
		labeled: label
		completion: insertedText
		position: positionInteger
		from: positionInteger - prefixSize + 1.
	deleteSize = 0
		ifTrue: [ ^ insertionAction ].
	deleteAction := GtDeleteTextCompletionAction labeled: label from: positionInteger + 1 to: positionInteger + deleteSize.
	^ (GtCompositeCompletionAction labeled: label)
		addAction: deleteAction;
		addAction: insertionAction;
		yourself
]

{ #category : #accessing }
GtSmaCCCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxSize [
	| prefix index |
	prefix := self completionPrefixAt: positionInteger in: aText.
	(prefix isNil or: [ prefix size < self minimumPrefixLength ])
		ifTrue: [ ^ #() ].
	(self hasCompletionEntryFor: prefix)
		ifFalse: [ ^ #() ].
	index := positionInteger.
	[ index < aText size and: [ (aText at: index) isSeparator not ] ]
		whileTrue: [ index := index + 1 ].
	^ (self first: maxSize startingWith: prefix)
		collect: [ :each | 
			self
				complete: each
				with: (each allButFirst: prefix size)
				deleting: (index - positionInteger - 1 max: 0)
				at: positionInteger
				prefixSize: prefix size ]
]
