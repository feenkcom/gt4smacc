Class {
	#name : #GtSmaCCTransformationExampleFileNode,
	#superclass : #GtSmaCCTransformationExampleProgramNode,
	#instVars : [
		'statements'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleFileNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitFile: self
]

{ #category : #generated }
GtSmaCCTransformationExampleFileNode >> compositeNodeVariables [
	^ #(#statements)
]

{ #category : #'generated-initialize-release' }
GtSmaCCTransformationExampleFileNode >> initialize [
	super initialize.
	statements := OrderedCollection new: 2.
]

{ #category : #generated }
GtSmaCCTransformationExampleFileNode >> statements [
	^ statements
]

{ #category : #generated }
GtSmaCCTransformationExampleFileNode >> statements: anOrderedCollection [
	self setParents: self statements to: nil.
	statements := anOrderedCollection.
	self setParents: self statements to: self
]
