Class {
	#name : #GtSmaCCTransformation,
	#superclass : #Object,
	#instVars : [
		'grammar'
	],
	#category : #'GT4SmaCC-Development-UI-Transformations'
}

{ #category : #execution }
GtSmaCCTransformation >> checkPreconditions [
	self subclassResponsibility
]

{ #category : #execution }
GtSmaCCTransformation >> error: aString [
	GtSmaCCTransformationError signal: aString
]

{ #category : #execution }
GtSmaCCTransformation >> execute [
	self checkPreconditions.
	self transform
]

{ #category : #accessing }
GtSmaCCTransformation >> grammar [
	^ grammar
]

{ #category : #accessing }
GtSmaCCTransformation >> grammar: gtSmaCCGrammar [
	grammar := gtSmaCCGrammar
]

{ #category : #execution }
GtSmaCCTransformation >> transform [
	self subclassResponsibility
]
