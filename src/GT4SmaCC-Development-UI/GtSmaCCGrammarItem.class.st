Class {
	#name : #GtSmaCCGrammarItem,
	#superclass : #GtSmaCCModel,
	#instVars : [
		'grammar',
		'originalAST',
		'source',
		'ast',
		'isDeleted'
	],
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #'instance creation' }
GtSmaCCGrammarItem class >> on: aGrammar ast: aNode [
	^ self new
		grammar: aGrammar;
		originalAST: aNode;
		yourself
]

{ #category : #'instance creation' }
GtSmaCCGrammarItem class >> on: aGrammar source: aString [
	^ self new
		grammar: aGrammar;
		source: aString;
		yourself
]

{ #category : #accessing }
GtSmaCCGrammarItem >> ast [
	^ ast
		ifNil: [ ast := SmaCCDefinitionParser
				parseWithErrors: source
				startingAt: self parserStartingState ]
]

{ #category : #actions }
GtSmaCCGrammarItem >> delete [
	isDeleted := true.
	self announce: (GtSmaCCGrammarItemChanged forItem: self)
]

{ #category : #accessing }
GtSmaCCGrammarItem >> grammar [
	^ grammar
]

{ #category : #'initialize-release' }
GtSmaCCGrammarItem >> grammar: aGrammar [
	grammar := aGrammar
]

{ #category : #'initialize-release' }
GtSmaCCGrammarItem >> initialize [
	super initialize.
	isDeleted := false
]

{ #category : #testing }
GtSmaCCGrammarItem >> isDeleted [
	^ isDeleted
]

{ #category : #testing }
GtSmaCCGrammarItem >> isModified [
	^ source ~= self originalSource or: [ isDeleted ]
]

{ #category : #testing }
GtSmaCCGrammarItem >> isReferenced [
	self grammar allReferencesTo: self name do: [ :node | ^ true ].
	^ false
]

{ #category : #testing }
GtSmaCCGrammarItem >> isValid [
	isDeleted
		ifTrue: [ ^ true ].
	^ [ SmaCCDefinitionParser
		parse: self source
		startingAt: self parserStartingState.
	true ]
		on: SmaCCParserError
		do: [ :ex |self halt. ex return: false ]
]

{ #category : #accessing }
GtSmaCCGrammarItem >> name [
	^ self ast
		ifNotNil: [ :node | 
			node isErrorNode
				ifTrue: [ self originalAST
						ifNotNil: [ :orig | 
							orig isErrorNode
								ifFalse: [ orig name source ] ] ]
				ifFalse: [ node name source ] ]
]

{ #category : #accessing }
GtSmaCCGrammarItem >> originalAST [
	^ originalAST
]

{ #category : #'initialize-release' }
GtSmaCCGrammarItem >> originalAST: aNode [
	originalAST := aNode.
	source := originalAST source
]

{ #category : #accessing }
GtSmaCCGrammarItem >> originalSource [
	^ originalAST isNil
		ifTrue: [ '' ]
		ifFalse: [ originalAST source ]
]

{ #category : #private }
GtSmaCCGrammarItem >> parserStartingState [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCGrammarItem >> source [
	^ source
]

{ #category : #accessing }
GtSmaCCGrammarItem >> source: aString [
	source = aString
		ifTrue: [ ^ self ].
	source := aString.
	ast := nil.
	self announce: (GtSmaCCGrammarItemChanged forItem: self)
]

{ #category : #private }
GtSmaCCGrammarItem >> updateSource: aSmaCCString at: anIndex [
	self isModified
		ifTrue: [ isDeleted
				ifTrue: [ originalAST isNil
						ifTrue: [ ^ anIndex ].
					aSmaCCString
						deleteWhitespaceAfterIndex: originalAST stopPosition;
						deleteFrom: originalAST startPosition
							to: originalAST stopPosition ]
				ifFalse: [ originalAST isNil
						ifTrue: [ | newSource |
							newSource := String cr , self source.
							^ (aSmaCCString
								insert: newSource
								at: (aSmaCCString nextIndex: anIndex)) + newSource size - 1 ]
						ifFalse: [ aSmaCCString
								replaceFrom: originalAST startPosition
								to: originalAST stopPosition
								with: self source ] ] ].
	^ originalAST stopPosition
]
