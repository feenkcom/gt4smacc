Class {
	#name : #GtSmaCCCompletionVisitor,
	#superclass : #SmaCCDefinitionNodeVisitor,
	#instVars : [
		'completions'
	],
	#category : #'GT4SmaCC-Development-UI-Completion'
}

{ #category : #accessing }
GtSmaCCCompletionVisitor >> completions [
	^ completions
]

{ #category : #accessing }
GtSmaCCCompletionVisitor >> completions: anObject [
	completions := anObject
]

{ #category : #generated }
GtSmaCCCompletionVisitor >> visitProductionRule: aProductionRule [
	completions add: aProductionRule name source.
	super visitProductionRule: aProductionRule
]

{ #category : #generated }
GtSmaCCCompletionVisitor >> visitSymbol: aSymbol [
	completions add: aSymbol name source.
	aSymbol variableNameToken notNil
		ifTrue: [ completions
				add: aSymbol name source , ' ' , aSymbol variableNameToken value.
			completions add: aSymbol variableNameToken value ].
	super visitSymbol: aSymbol
]

{ #category : #generated }
GtSmaCCCompletionVisitor >> visitTokenRegex: aTokenRegex [
	completions add: aTokenRegex name source.
	super visitTokenRegex: aTokenRegex
]

{ #category : #generated }
GtSmaCCCompletionVisitor >> visitTokenRule: aTokenRule [
	completions add: aTokenRule name source.
	super visitTokenRule: aTokenRule
]
