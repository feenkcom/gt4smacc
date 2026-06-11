Class {
	#name : #GtSmaCCTransformationExampleBlockNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'beginToken',
		'statements',
		'endToken'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitBlock: self
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> beginToken [
	^ beginToken
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> beginToken: aSmaCCToken [
	beginToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> compositeNodeVariables [
	^ #(#statements)
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> endToken [
	^ endToken
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> endToken: aSmaCCToken [
	endToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
GtSmaCCTransformationExampleBlockNode >> initialize [
	super initialize.
	statements := OrderedCollection new: 2.
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> statements [
	^ statements
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> statements: anOrderedCollection [
	self setParents: self statements to: nil.
	statements := anOrderedCollection.
	self setParents: self statements to: self
]

{ #category : #generated }
GtSmaCCTransformationExampleBlockNode >> tokenVariables [
	^ #(#beginToken #endToken)
]
