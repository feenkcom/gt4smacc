Class {
	#name : #GtSmaCCDirective,
	#superclass : #GtSmaCCGrammarItem,
	#category : #'GT4SmaCC-Development-UI-Model'
}

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
