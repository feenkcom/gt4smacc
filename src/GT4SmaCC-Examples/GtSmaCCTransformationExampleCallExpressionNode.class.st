Class {
	#name : #GtSmaCCTransformationExampleCallExpressionNode,
	#superclass : #GtSmaCCTransformationExampleExpressionNode,
	#instVars : [
		'function',
		'left',
		'args',
		'semicolons',
		'right'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitCallExpression: self
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> args [
	^ args
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> compositeTokenVariables [
	^ #(#semicolons #leftParens #rightParens)
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> function [
	^ function
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> function: aGtSmaCCTransformationExampleExpressionNode [
	self function notNil ifTrue: [ self function parent: nil ].
	function := aGtSmaCCTransformationExampleExpressionNode.
	self function notNil ifTrue: [ self function parent: self ]
]

{ #category : #'generated-initialize-release' }
GtSmaCCTransformationExampleCallExpressionNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	semicolons := OrderedCollection new: 2.
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> left [
	^ left
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> left: aSmaCCToken [
	left := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> nodeVariables [
	^ #(#function)
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> right [
	^ right
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> right: aSmaCCToken [
	right := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> semicolons [
	^ semicolons
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> semicolons: anOrderedCollection [
	semicolons := anOrderedCollection
]

{ #category : #generated }
GtSmaCCTransformationExampleCallExpressionNode >> tokenVariables [
	^ #(#left #right)
]
