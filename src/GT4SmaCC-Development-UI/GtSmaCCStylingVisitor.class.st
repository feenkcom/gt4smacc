Class {
	#name : #GtSmaCCStylingVisitor,
	#superclass : #SmaCCDefinitionNodeVisitor,
	#instVars : [
		'styler'
	],
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #styling }
GtSmaCCStylingVisitor >> styleNode: aNode using: aStyler [
	styler := aStyler.
	self accept: aNode
]

{ #category : #accessing }
GtSmaCCStylingVisitor >> text [
	^ styler text
]
