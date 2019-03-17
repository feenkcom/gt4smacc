Class {
	#name : #GtSmaCCCoder,
	#superclass : #Object,
	#instVars : [
		'owner',
		'ast',
		'expanded',
		'collapsedEditor',
		'sourceEditor',
		'originalSource',
		'attributes'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCCoder class >> on: aNode in: aGrammarCoder [
	^ self new
		owner: aGrammarCoder;
		ast: aNode;
		yourself
]

{ #category : #actions }
GtSmaCCCoder >> actions [
	^ {(GtCoderAction new
		title: 'Inspect' translated;
		icon: BrGlamorousIcons playinspect;
		action: [ :button | self inspectFrom: button ];
		yourself)}
]

{ #category : #elements }
GtSmaCCCoder >> asElement [
	^ GtSmaCCCoderElement onCoder: self
]

{ #category : #'initialize-release' }
GtSmaCCCoder >> ast: aNode [
	ast := aNode.
	originalSource := aNode source
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol ifAbsentPut: aBlock [
	^ self attributes at: aSymbol ifAbsentPut: aBlock
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #ui }
GtSmaCCCoder >> collapsedEditor [
	^ collapsedEditor
		ifNil: [ collapsedEditor := self newCollapsedEditor ]
]

{ #category : #ui }
GtSmaCCCoder >> defaultTextAttributes [
	^ {(BlFontFamilyAttribute named: 'Source Code Pro')
		beNotOverwritableByStyler.
	BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 12) beNotOverwritableByStyler}
]

{ #category : #accessing }
GtSmaCCCoder >> definitionName [
	self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtSmaCCCoder >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #'initialize-release' }
GtSmaCCCoder >> initialize [
	super initialize.
	expanded := false
]

{ #category : #actions }
GtSmaCCCoder >> inspectFrom: anElement [
	anElement phlow spawnObject: self
]

{ #category : #testing }
GtSmaCCCoder >> isModified [
	^ self source ~= originalSource
]

{ #category : #testing }
GtSmaCCCoder >> isValid [
	^ [ SmaCCDefinitionParser
		parse: self source
		startingAt: self parserStartingState.
	true ]
		on: SmaCCParserError
		do: [ :ex | ex return: false ]
]

{ #category : #ui }
GtSmaCCCoder >> newCollapsedEditor [
	| text |
	text := self styledName.
	text attributes: self defaultTextAttributes.
	^ BrTextEditor new
		text: text readonly;
		yourself
]

{ #category : #ui }
GtSmaCCCoder >> newSourceEditor [
	| text |
	text := originalSource asRopedText.
	text attributes: self defaultTextAttributes.
	^ BrTextEditor new
		styler: self newStyler;
		text: text;
		yourself
]

{ #category : #ui }
GtSmaCCCoder >> newStyler [
	^ GtSmaCCStyler new
		grammarCoder: owner;
		yourself
]

{ #category : #'initialize-release' }
GtSmaCCCoder >> owner: aGrammarCoder [
	owner := aGrammarCoder
]

{ #category : #private }
GtSmaCCCoder >> parserStartingState [
	^ self subclassResponsibility
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> removeAttributeNamed: aSymbol [
	attributes isNil
		ifTrue: [ ^ self ].
	^ attributes removeKey: aSymbol ifAbsent: [  ]
]

{ #category : #accessing }
GtSmaCCCoder >> source [
	^ sourceEditor isNil
		ifTrue: [ originalSource ]
		ifFalse: [ sourceEditor text asString ]
]

{ #category : #ui }
GtSmaCCCoder >> sourceEditor [
	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #ui }
GtSmaCCCoder >> styledName [
	^ self definitionName asRopedText
]

{ #category : #source }
GtSmaCCCoder >> updateSource: aSmaCCString [
	self isModified
		ifFalse: [ ^ self ].
	ast isNil
		ifTrue: [ aSmaCCString append: String cr , self source ]
		ifFalse: [ aSmaCCString
				replaceFrom: ast startPosition
				to: ast stopPosition
				with: self source ]
]
