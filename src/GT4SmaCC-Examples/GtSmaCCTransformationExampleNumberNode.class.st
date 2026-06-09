Class {
	#name : #GtSmaCCTransformationExampleNumberNode,
	#superclass : #GtSmaCCTransformationExampleLiteralNode,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleNumberNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitNumber: self
]
