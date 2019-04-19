Class {
	#name : #GtSmaCCGrammar,
	#superclass : #GtSmaCCModel,
	#instVars : [
		'parserClassName',
		'scannerClassName',
		'rules',
		'originalAST',
		'glr',
		'caseInsensitive',
		'unicode'
	],
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #'instance creation' }
GtSmaCCGrammar class >> forDefinition: aString [
	^ self new
		source: aString;
		yourself
]

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

{ #category : #private }
GtSmaCCGrammar >> caseInsensitiveDirective [
	^ rules
		detect: [ :each | each isDirective and: [ each isCaseInsensitive ] ]
		ifNone: [  ]
]

{ #category : #actions }
GtSmaCCGrammar >> compileParser [
	SmaCCGrammarCompiler new
		buildDefinition: self source;
		compileInto: scannerClassName andParser: parserClassName
]

{ #category : #private }
GtSmaCCGrammar >> firstIndex [
	rules
		do:
			[ :each | each originalAST ifNotNil: [ :tree | ^ tree startPosition ] ].
	^ 1
]

{ #category : #private }
GtSmaCCGrammar >> glrDirective [
	^ rules
		detect: [ :each | each isDirective and: [ each isGLR ] ]
		ifNone: [  ]
]

{ #category : #private }
GtSmaCCGrammar >> hasCaseInsensitiveDirective [
	^ self caseInsensitiveDirective notNil
]

{ #category : #private }
GtSmaCCGrammar >> hasGLRDirective [
	^ self glrDirective notNil
]

{ #category : #private }
GtSmaCCGrammar >> hasUnicodeDirective [
	^ self unicodeDirective notNil
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> initialize [
	super initialize.
	rules := OrderedCollection new.
	glr := false.
	caseInsensitive := false.
	unicode := false
]

{ #category : #testing }
GtSmaCCGrammar >> isCaseInsensitive [
	^ caseInsensitive
]

{ #category : #accessing }
GtSmaCCGrammar >> isCaseInsensitive: aBoolean [
	caseInsensitive := aBoolean
]

{ #category : #testing }
GtSmaCCGrammar >> isGLR [
	^ glr
]

{ #category : #accessing }
GtSmaCCGrammar >> isGLR: aBoolean [
	glr := aBoolean
]

{ #category : #testing }
GtSmaCCGrammar >> isModified [
	^ (rules anySatisfy: [ :each | each isModified ])
		or: [ glr ~= self hasGLRDirective
				or: [ unicode ~= self hasUnicodeDirective
						or: [ caseInsensitive ~= self hasCaseInsensitiveDirective ] ] ]
]

{ #category : #testing }
GtSmaCCGrammar >> isUnicode [
	^ unicode
]

{ #category : #accessing }
GtSmaCCGrammar >> isUnicode: aBoolean [
	unicode := aBoolean
]

{ #category : #testing }
GtSmaCCGrammar >> isValid [
	^ rules allSatisfy: [ :each | each isValid ]
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
	originalAST rules do: [ :each | self addGrammarItem: each ].
	glr := self hasGLRDirective.
	unicode := self hasUnicodeDirective.
	caseInsensitive := self hasCaseInsensitiveDirective
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
	self
		updateFlag: 'ignorecase'
		to: caseInsensitive
		directive: self caseInsensitiveDirective
		in: newSource.
	self
		updateFlag: 'unicode'
		to: unicode
		directive: self unicodeDirective
		in: newSource.
	self
		updateFlag: 'glr'
		to: glr
		directive: self glrDirective
		in: newSource.
	rules do: [ :each | each updateSource: newSource ].
	^ newSource asString
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> source: aString [
	originalAST := SmaCCDefinitionParser parseWithErrors: aString.
	originalAST isNil
		ifTrue: [ ^ self ].
	originalAST rules do: [ :each | self addGrammarItem: each ]
]

{ #category : #private }
GtSmaCCGrammar >> unicodeDirective [
	^ rules
		detect: [ :each | each isDirective and: [ each isUnicode ] ]
		ifNone: [  ]
]

{ #category : #private }
GtSmaCCGrammar >> updateFlag: aString to: aBoolean directive: aRule in: aSmaCCString [
	aBoolean
		ifTrue: [ aRule isNil
				ifTrue: [ aSmaCCString
						insert: '%' , aString , ';' , String cr , String cr
						at: self firstIndex ] ]
		ifFalse: [ aRule notNil
				ifTrue: [ aSmaCCString
						deleteFrom: aRule originalAST startPosition
						to: aRule originalAST stopPosition ] ]
]
