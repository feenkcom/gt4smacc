Trait {
	#name : #TGtSmaCCTransformationExampleProgramNodeVisitor,
	#traits : 'TSmaCCParseNodeVisitor',
	#classTraits : 'TSmaCCParseNodeVisitor classTrait',
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitAssignment: anAssignment [
	^ self visitStatement: anAssignment
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitBinaryExpression: aBinaryExpression [
	^ self visitExpression: aBinaryExpression
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitBlock: aBlock [
	^ self visitStatement: aBlock
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitCall: aCall [
	^ self visitStatement: aCall
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitCallExpression: aCallExpression [
	^ self visitExpression: aCallExpression
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitExpression: anExpression [
	^ self visitProgram: anExpression
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitFile: aFile [
	^ self visitProgram: aFile
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitFunction: aFunction [
	^ self visitStatement: aFunction
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitIf: anIf [
	^ self visitStatement: anIf
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitInput: anInput [
	^ self visitStatement: anInput
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitLiteral: aLiteral [
	^ self visitExpression: aLiteral
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitNumber: aNumber [
	^ self visitLiteral: aNumber
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitPrint: aPrint [
	^ self visitStatement: aPrint
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitProgram: aProgram [
	^ self visitSmaCCParseNode: aProgram
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitReturn: aReturn [
	^ self visitStatement: aReturn
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitStatement: aStatement [
	^ self visitProgram: aStatement
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitString: aString [
	^ self visitLiteral: aString
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitVariable: aVariable [
	^ self visitExpression: aVariable
]

{ #category : #generated }
TGtSmaCCTransformationExampleProgramNodeVisitor >> visitWhile: aWhile [
	^ self visitStatement: aWhile
]
