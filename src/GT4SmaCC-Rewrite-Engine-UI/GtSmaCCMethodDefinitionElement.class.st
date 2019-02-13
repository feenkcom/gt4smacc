Class {
	#name : #GtSmaCCMethodDefinitionElement,
	#superclass : #BrExpander,
	#instVars : [
		'methodDefinition'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCMethodDefinitionElement class >> methodDefinition: aSmaCCRewriteMethodDefinition [
	^ self new
		methodDefinition: aSmaCCRewriteMethodDefinition;
		yourself
]

{ #category : #accessing }
GtSmaCCMethodDefinitionElement >> methodDefinition [
	^ methodDefinition
]

{ #category : #accessing }
GtSmaCCMethodDefinitionElement >> methodDefinition: aSmaCCRewriteMethodDefinition [
	methodDefinition := aSmaCCRewriteMethodDefinition
]
