Class {
	#name : 'GtSmaCCInlineAllRefactoring',
	#superclass : 'GtSmaCCTransformation',
	#instVars : [
		'productionRule'
	],
	#category : 'GT4SmaCC-Development-UI-Transformations'
}

{ #category : 'instance creation' }
GtSmaCCInlineAllRefactoring class >> inlineAll: productionRule [
	^ self new
		productionRule: productionRule;
		yourself
]

{ #category : 'execution' }
GtSmaCCInlineAllRefactoring >> checkPreconditions [
	productionRule hasOnlyDefaultReduceExpressions
		ifFalse: [ self
				error:
					'Cannot inline definition when it defines an AST node or has a code expression' ]
]

{ #category : 'execution' }
GtSmaCCInlineAllRefactoring >> inlineAllIn: anItem [
	anItem isProductionRule
		ifFalse: [ ^ self ].
	anItem ast
		allNodesDo: [ :each | 
			((each isKindOf: SmaCCProductionSymbolNode)
				and: [ each name value = productionRule name ])
				ifTrue: [ [ (GtSmaCCInlineRefactoring inline: each in: anItem) execute.
					^ self inlineAllIn: anItem ]
						on: GtSmaCCTransformationError
						do: [ :ex | ex return ] ] ]
]

{ #category : 'initialize-release' }
GtSmaCCInlineAllRefactoring >> productionRule: aProductionRule [
	productionRule := aProductionRule.
	self grammar: aProductionRule grammar
]

{ #category : 'execution' }
GtSmaCCInlineAllRefactoring >> transform [
	self grammar rules
		do: [ :each | 
			each ~~ productionRule
				ifTrue: [ self inlineAllIn: each ] ]
]
