Class {
	#name : #GtSmaCCPharoStyler,
	#superclass : #GtPharoStyler,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #private }
GtSmaCCPharoStyler >> style: aText using: anAST [
	^ self style: aText ast: anAST
]

{ #category : #visiting }
GtSmaCCPharoStyler >> visitNamedVariable: aNamedVariable [
	| isDeclaredVariable |
	self visitVariable: aNamedVariable.
	isDeclaredVariable := aNamedVariable isUndeclared not.
	isDeclaredVariable
		ifTrue: [ ^ self visitDeclaredVariable: aNamedVariable ].
	
	isDeclaredVariable := (SmaCCRewriteMatchContext classThatDefinesInstVarNamed: aNamedVariable variableName) notNil.
	isDeclaredVariable
		ifTrue: [ ^ self visitDeclaredVariable: aNamedVariable ].
	
	isDeclaredVariable := SmaCCRewriteMatchContext environment includesKey: aNamedVariable variableName.
	isDeclaredVariable
		ifTrue: [ ^ self visitDeclaredGlobalVariable: aNamedVariable ].

	self visitUndeclaredVariable: aNamedVariable
]
