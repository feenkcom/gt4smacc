Class {
	#name : #GtSmaCCInlineRefactoring,
	#superclass : #GtSmaCCTransformation,
	#instVars : [
		'symbolNode',
		'production',
		'rule'
	],
	#category : #'GT4SmaCC-Development-UI-Transformations'
}

{ #category : #'instance creation' }
GtSmaCCInlineRefactoring class >> inline: aProductionSymbolNode in: smaccProductionRule [
	^ self new
		symbolNode: aProductionSymbolNode;
		production: smaccProductionRule;
		yourself
]

{ #category : #execution }
GtSmaCCInlineRefactoring >> checkPreconditions [
	rule := grammar ruleNamed: symbolNode name value.
	rule isNil
		ifTrue: [ self error: 'Cannot find definition' ].
	symbolNode variableNameToken notNil
		ifTrue: [ rule hasOnlySingleItemProductions
				ifFalse: [ self error: 'Cannot inline symbol when it has a variable name' ] ].
	rule hasOnlyDefaultReduceExpressions
		ifFalse: [ self
				error:
					'Cannot inline definition when it defines an AST node or has a code expression' ]
]

{ #category : #execution }
GtSmaCCInlineRefactoring >> inlinedDefinitionWithVariableNamed: aString [
	| firstIsEmpty expression ast |
	ast := rule ast.
	(ast expressions size = 2
		and: [ (firstIsEmpty := ast expressions first isEmptyExpression)
				or: [ ast expressions last isEmptyExpression ] ])
		ifTrue: [ expression := firstIsEmpty
				ifTrue: [ ast expressions last ]
				ifFalse: [ ast expressions first ].
			^ expression terms size = 1
				ifTrue: [ expression source
						,
							(aString isNil
								ifTrue: [ '' ]
								ifFalse: [ ' ' , aString ]) , '?' ]
				ifFalse: [ '( ' , expression source
						,
							(aString isNil
								ifTrue: [ '' ]
								ifFalse: [ ' ' , aString ]) , ' )?' ] ].
	^ String
		streamContents: [ :stream | 
			| nonEmptyRules |
			nonEmptyRules := ast expressions
				reject: [ :each | each isEmptyExpression ].
			ast expressions size > 1
				ifTrue: [ stream nextPutAll: '( ' ].
			nonEmptyRules
				do: [ :each | 
					stream nextPutAll: each source.
					aString notNil
						ifTrue: [ stream
								space;
								nextPutAll: aString ] ]
				separatedBy: [ stream nextPutAll: ' | ' ].
			ast expressions size > 1
				ifTrue: [ stream nextPutAll: ' )' ].
			nonEmptyRules size ~= ast expressions size
				ifTrue: [ stream nextPut: $? ] ]
]

{ #category : #accessing }
GtSmaCCInlineRefactoring >> production: smaccProductionRule [
	production := smaccProductionRule.
	self grammar: production grammar
]

{ #category : #accessing }
GtSmaCCInlineRefactoring >> symbolNode: aProductionSymbolNode [
	symbolNode := aProductionSymbolNode
]

{ #category : #execution }
GtSmaCCInlineRefactoring >> transform [
	| inlineSource originalSource newSource |
	inlineSource := self
		inlinedDefinitionWithVariableNamed: (symbolNode variableNameToken ifNotNil: [ :token | token value ]).
	originalSource := production source.
	newSource := (originalSource first: symbolNode startPosition - 1)
		, inlineSource
		, (originalSource allButFirst: symbolNode stopPosition).
	production source: newSource
]
