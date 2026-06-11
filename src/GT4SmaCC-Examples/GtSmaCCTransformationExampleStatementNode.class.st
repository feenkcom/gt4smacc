Class {
	#name : #GtSmaCCTransformationExampleStatementNode,
	#superclass : #GtSmaCCTransformationExampleProgramNode,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleStatementNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitStatement: self
]
