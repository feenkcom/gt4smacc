Class {
	#name : #GtSmaCCCompletionStrategy,
	#superclass : #GtWeightedStringsCompletionStrategy,
	#instVars : [
		'enabled'
	],
	#category : #'GT4SmaCC-Development-UI-Completion'
}

{ #category : #accessing }
GtSmaCCCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	self isEnabled ifFalse: [ ^ #() asAsyncStream ].
	^ super completionActionStreamFor: aText at: positionInteger
]

{ #category : #activation }
GtSmaCCCompletionStrategy >> disable [
	enabled := false
]

{ #category : #activation }
GtSmaCCCompletionStrategy >> enable [
	enabled := true
]

{ #category : #'initialize-release' }
GtSmaCCCompletionStrategy >> initialize [
	super initialize.
	enabled := true
]

{ #category : #testing }
GtSmaCCCompletionStrategy >> isEnabled [
	^ enabled
]
