Class {
	#name : #GtSmaCCTransformationExampleWhileNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'whileToken',
		'condition',
		'doToken',
		'statement'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitWhile: self
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> condition [
	^ condition
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> condition: aGtSmaCCTransformationExampleExpressionNode [
	self condition notNil ifTrue: [ self condition parent: nil ].
	condition := aGtSmaCCTransformationExampleExpressionNode.
	self condition notNil ifTrue: [ self condition parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> doToken [
	^ doToken
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> doToken: aSmaCCToken [
	doToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> nodeVariables [
	^ #(#condition #statement)
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> statement [
	^ statement
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> statement: aGtSmaCCTransformationExampleStatementNode [
	self statement notNil ifTrue: [ self statement parent: nil ].
	statement := aGtSmaCCTransformationExampleStatementNode.
	self statement notNil ifTrue: [ self statement parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> tokenVariables [
	^ #(#whileToken #doToken)
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> whileToken [
	^ whileToken
]

{ #category : #generated }
GtSmaCCTransformationExampleWhileNode >> whileToken: aSmaCCToken [
	whileToken := aSmaCCToken
]
