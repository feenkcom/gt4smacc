Class {
	#name : #GtSmaCCCoder,
	#superclass : #Object,
	#instVars : [
		'owner',
		'source',
		'ast',
		'expanded',
		'collapsedEditor',
		'sourceEditor'
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

{ #category : #elements }
GtSmaCCCoder >> asElement [
	^ GtSmaCCCoderElement onCoder: self
]

{ #category : #'initialize-release' }
GtSmaCCCoder >> ast: aNode [
	ast := aNode.
	source := aNode source
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

{ #category : #ui }
GtSmaCCCoder >> newCollapsedEditor [
	^ BrTextEditor new
		text: self definitionName asRopedText;
		yourself
]

{ #category : #ui }
GtSmaCCCoder >> newSourceEditor [
	| text |
	text := source asRopedText.
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

{ #category : #ui }
GtSmaCCCoder >> sourceEditor [
	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]
