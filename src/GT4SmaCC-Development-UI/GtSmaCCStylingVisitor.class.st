Class {
	#name : #GtSmaCCStylingVisitor,
	#superclass : #GtSmaCCASTStyler,
	#traits : 'TSmaCCDefinitionNodeVisitor',
	#classTraits : 'TSmaCCDefinitionNodeVisitor classTrait',
	#instVars : [
		'styler'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #styling }
GtSmaCCStylingVisitor >> styleAST: aNode [
	self accept: aNode
]

{ #category : #styling }
GtSmaCCStylingVisitor >> styleNode: aNode using: aStyler [
	styler := aStyler.
	text := styler text.
	self styleAST: aNode
]

{ #category : #accessing }
GtSmaCCStylingVisitor >> text [
	^ text
]
