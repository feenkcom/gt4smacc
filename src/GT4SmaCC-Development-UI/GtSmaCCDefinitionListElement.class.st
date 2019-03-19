Class {
	#name : #GtSmaCCDefinitionListElement,
	#superclass : #BlElement,
	#instVars : [
		'coders'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCDefinitionListElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self filterElement as: #filter.
	self addChild: self listElement.
	self updateFilter: ''
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> coders [
	^ coders
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> coders: aDefinitionGroupResult [
	coders := aDefinitionGroupResult.
	self buildElement
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> filterElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self updateFilter: editor text asString ];
		when: BrTextEditorDeletedEvent do: [ :event | self updateFilter: editor text asString ].
	element := BrEditorElement new.
	element editor: editor.
	element border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		margin:
			(BlInsets
				top: 10
				left: 10
				bottom: 0
				right: 10).
	element padding: (BlInsets all: 3).
	^ element
]

{ #category : #private }
GtSmaCCDefinitionListElement >> list [
	^ self childNamed: #list
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> listElement [
	| list scrollable |
	list := BrSimpleList new.
	list vFitContent.
	list stencil: [ :each :index | each asElement ].
	scrollable := BlScrollableElement new.
	scrollable
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	scrollable addChild: list as: #list.
	^ scrollable
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateFilter: aString [
	| filtered filter items highlighter |
	aString isEmpty
		ifTrue: [ filtered := coders.
			highlighter := nil ]
		ifFalse:
			[ filter := GtSmaCCDefinitionImplementorPatternFilter pattern: aString.
			filtered := filter applyInScope: coders.
			highlighter := filter highlighter ].
	items := OrderedCollection withAll: filtered.
	items do: [ :each | each highlighter: highlighter ].
	self list items: items
]
