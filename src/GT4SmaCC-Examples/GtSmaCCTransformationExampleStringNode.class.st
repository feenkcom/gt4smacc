Class {
	#name : #GtSmaCCTransformationExampleStringNode,
	#superclass : #GtSmaCCTransformationExampleLiteralNode,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleStringNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitString: self
]
