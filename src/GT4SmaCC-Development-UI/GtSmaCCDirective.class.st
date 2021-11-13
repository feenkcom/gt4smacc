Class {
	#name : #GtSmaCCDirective,
	#superclass : #GtSmaCCGrammarItem,
	#category : 'GT4SmaCC-Development-UI-Model'
}

{ #category : #accessing }
GtSmaCCDirective >> directiveName [
	| node |
	node := self ast isErrorNode
		ifTrue: [ self originalAST ]
		ifFalse: [ self ast ].
	node isNil
		ifTrue: [ ^ '' ].
	^ node directiveNameToken value
]

{ #category : #testing }
GtSmaCCDirective >> isCaseInsensitive [
	| tree |
	tree := self ast.
	^ (tree isKindOf: SmaCCFlagDirectiveNode)
		and: [ tree typeToken value = 'ignorecase' ]
]

{ #category : #testing }
GtSmaCCDirective >> isDirective [
	^ true
]

{ #category : #testing }
GtSmaCCDirective >> isGLR [
	| tree |
	tree := self ast.
	^ (tree isKindOf: SmaCCFlagDirectiveNode)
		and: [ tree typeToken value = 'glr' ]
]

{ #category : #testing }
GtSmaCCDirective >> isReferenced [
	^ true
]

{ #category : #testing }
GtSmaCCDirective >> isUnicode [
	| tree |
	tree := self ast.
	^ (tree isKindOf: SmaCCFlagDirectiveNode)
		and: [ tree typeToken value = 'unicode' ]
]

{ #category : #accessing }
GtSmaCCDirective >> name [
	^ nil
]

{ #category : #private }
GtSmaCCDirective >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForDirectiveLine
]
