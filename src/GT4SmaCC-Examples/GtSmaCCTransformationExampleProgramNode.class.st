Class {
	#name : #GtSmaCCTransformationExampleProgramNode,
	#superclass : #SmaCCParseNode,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleProgramNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitProgram: self
]
