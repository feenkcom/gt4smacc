Class {
	#name : #GtSmaCCGrammar,
	#superclass : #GtSmaCCModel,
	#instVars : [
		'parserClassName',
		'scannerClassName',
		'rules',
		'originalAST'
	],
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #'instance creation' }
GtSmaCCGrammar class >> onParser: aClass [
	^ self new
		parserClass: aClass;
		yourself
]

{ #category : #private }
GtSmaCCGrammar >> addGrammarItem: aNode [
	| item |
	aNode isDirective
		ifTrue: [ item := GtSmaCCDirective on: self ast: aNode ].
	aNode isTokenRule
		ifTrue: [ item := GtSmaCCTokenRule on: self ast: aNode ].
	aNode isProductionRule
		ifTrue: [ item := GtSmaCCProductionRule on: self ast: aNode ].
	item isNil
		ifTrue: [ ^ self ].
	rules add: item.
	self announce: (GtSmaCCGrammarRulesChanged forGrammar: self)
]

{ #category : #accessing }
GtSmaCCGrammar >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtSmaCCGrammar >> ast [
	^ SmaCCDefinitionParser parseWithErrors: self source
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> initialize [
	super initialize.
	rules := OrderedCollection new
]

{ #category : #testing }
GtSmaCCGrammar >> isModified [
	^ rules anySatisfy: [ :each | each isModified ]
]

{ #category : #accessing }
GtSmaCCGrammar >> parserClass [
	^ Smalltalk at: parserClassName ifAbsent: [  ]
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> parserClass: aClass [
	parserClassName := aClass name.
	scannerClassName := [ aClass scannerClass name ]
		on: Error
		do: [ :ex | ex return ].
	originalAST := aClass definitionAST.
	originalAST isNil
		ifTrue: [ ^ self ].
	originalAST rules do: [ :each | self addGrammarItem: each ]
]

{ #category : #accessing }
GtSmaCCGrammar >> parserClassName [
	^ parserClassName
]

{ #category : #accessing }
GtSmaCCGrammar >> parserClassName: anObject [
	parserClassName := anObject
]

{ #category : #accessing }
GtSmaCCGrammar >> ruleNamed: aString [
	^ rules detect: [ :each | each name = aString ] ifNone: [  ]
]

{ #category : #accessing }
GtSmaCCGrammar >> rules [
	^ rules
]

{ #category : #accessing }
GtSmaCCGrammar >> rulesNamed: aString [
	^ rules select: [ :each | each name = aString ]
]

{ #category : #accessing }
GtSmaCCGrammar >> scannerClass [
	^ (scannerClassName notNil
		ifTrue: [ Smalltalk at: scannerClassName ])
		ifNil: [ self parserClass
				ifNotNil: [ :cls | 
					[ cls scannerClass ]
						on: Error
						do: [ :ex | ex return ] ] ]
]

{ #category : #accessing }
GtSmaCCGrammar >> scannerClassName [
	^ scannerClassName
]

{ #category : #accessing }
GtSmaCCGrammar >> scannerClassName: anObject [
	scannerClassName := anObject
]

{ #category : #accessing }
GtSmaCCGrammar >> source [
	| newSource |
	self isModified
		ifFalse: [ ^ originalAST completeSource asString ].
	newSource := originalAST completeSource copy.
	rules do: [ :each | each updateSource: newSource ].
	^ newSource asString
]
