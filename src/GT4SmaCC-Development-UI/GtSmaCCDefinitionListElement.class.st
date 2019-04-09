Class {
	#name : #GtSmaCCDefinitionListElement,
	#superclass : #BlElement,
	#instVars : [
		'group',
		'listElement'
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
	self updateList
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

{ #category : #accessing }
GtSmaCCDefinitionListElement >> group [
	^ group
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> group: aDefinitionGroupResult [
	group := GtSmaCCNoFilter new applyInScope: aDefinitionGroupResult.
	self buildElement
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> listElement [
	^ listElement
		ifNil: [ | dataSource |
			dataSource := GtSmaCCGroupCoderDataSource new group: group.
			listElement := GtSmaCCGroupCoderInfiniteElement new
				dataSource: dataSource;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			listElement ]
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateFilter: aString [
	| filter |
	filter := aString isEmpty
		ifTrue: [ GtSmaCCNoFilter new ]
		ifFalse: [ GtSmaCCDefinitionImplementorPatternFilter pattern: aString ].
	group filter: filter.
	self updateList
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateList [
	| highlighter |
	highlighter := group highlighter.
	group coders do: [ :each | each highlighter: highlighter ].
	listElement dataSource updateCoders
]
