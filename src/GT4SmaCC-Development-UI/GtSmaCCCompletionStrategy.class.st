Class {
	#name : #GtSmaCCCompletionStrategy,
	#superclass : #GtWeightedStringsCompletionStrategy,
	#instVars : [
		'enabled'
	],
	#category : 'GT4SmaCC-Development-UI-Completion'
}

{ #category : #accessing }
GtSmaCCCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxSize [
	self isEnabled
		ifFalse: [ ^ #() ].
	^ super completionActionsFor: aText at: positionInteger max: maxSize
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
