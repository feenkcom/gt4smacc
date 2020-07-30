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
GtSmaCCDefinitionListElement >> addItemLookTo: dataSource [
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		padding:
			(BlInsets
				top: 0
				left: 10
				bottom: 10
				right: 10).
	self margin: (BlInsets all: 0).
	self filterElement
		ifNotNil: [ :filter | self addChild: filter as: #filter ].
	self addChild: self listElement.
	self updateList
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> filterElement [
	^ nil
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> group [
	^ group
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> group: aDefinitionGroupResult [
	group := aDefinitionGroupResult.
	self buildElement
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> listElement [
	^ listElement
		ifNil: [ | dataSource |
			dataSource := GtSmaCCGroupCoderDataSource new group: group.
			self addItemLookTo: dataSource.
			listElement := GtSmaCCGroupCoderInfiniteElement new
				dataSource: dataSource;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			listElement ]
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateFilters [
	self updateList
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateList [
	| highlighter |
	highlighter := group highlighter.
	group coders do: [ :each | each highlighter: highlighter ].
	listElement dataSource updateCoders
]
