Class {
	#name : #GtSmaCCTransformationExampleFunctionNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'functionToken',
		'name',
		'left',
		'parameters',
		'semicolons',
		'right',
		'body'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitFunction: self
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> body [
	^ body
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> body: aGtSmaCCTransformationExampleBlockNode [
	self body notNil ifTrue: [ self body parent: nil ].
	body := aGtSmaCCTransformationExampleBlockNode.
	self body notNil ifTrue: [ self body parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> compositeNodeVariables [
	^ #(#parameters)
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> compositeTokenVariables [
	^ #(#semicolons)
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> functionToken [
	^ functionToken
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> functionToken: aSmaCCToken [
	functionToken := aSmaCCToken
]

{ #category : #'generated-initialize-release' }
GtSmaCCTransformationExampleFunctionNode >> initialize [
	super initialize.
	parameters := OrderedCollection new: 2.
	semicolons := OrderedCollection new: 2.
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> left [
	^ left
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> left: aSmaCCToken [
	left := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> name [
	^ name
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> nodeVariables [
	^ #(#body)
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> parameters [
	^ parameters
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> parameters: anOrderedCollection [
	self setParents: self parameters to: nil.
	parameters := anOrderedCollection.
	self setParents: self parameters to: self
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> right [
	^ right
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> right: aSmaCCToken [
	right := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> semicolons [
	^ semicolons
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> semicolons: anOrderedCollection [
	semicolons := anOrderedCollection
]

{ #category : #generated }
GtSmaCCTransformationExampleFunctionNode >> tokenVariables [
	^ #(#functionToken #name #left #right)
]
