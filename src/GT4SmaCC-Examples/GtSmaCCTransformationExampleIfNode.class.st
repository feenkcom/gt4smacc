Class {
	#name : #GtSmaCCTransformationExampleIfNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'ifToken',
		'condition',
		'thenToken',
		'then',
		'elseToken',
		'else'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitIf: self
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> condition [
	^ condition
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> condition: aGtSmaCCTransformationExampleExpressionNode [
	self condition notNil ifTrue: [ self condition parent: nil ].
	condition := aGtSmaCCTransformationExampleExpressionNode.
	self condition notNil ifTrue: [ self condition parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> else [
	^ else
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> else: aGtSmaCCTransformationExampleStatementNode [
	self else notNil ifTrue: [ self else parent: nil ].
	else := aGtSmaCCTransformationExampleStatementNode.
	self else notNil ifTrue: [ self else parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> elseToken [
	^ elseToken
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> elseToken: aSmaCCToken [
	elseToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> ifToken [
	^ ifToken
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> ifToken: aSmaCCToken [
	ifToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> nodeVariables [
	^ #(#condition #then #else)
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> then [
	^ then
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> then: aGtSmaCCTransformationExampleStatementNode [
	self then notNil ifTrue: [ self then parent: nil ].
	then := aGtSmaCCTransformationExampleStatementNode.
	self then notNil ifTrue: [ self then parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> thenToken [
	^ thenToken
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> thenToken: aSmaCCToken [
	thenToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleIfNode >> tokenVariables [
	^ #(#ifToken #thenToken #elseToken)
]
