Class {
	#name : #GtSmaCCDefinitionListElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'listElement',
		'filterModel',
		'originalGroup',
		'group'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCDefinitionListElement >> addItemLookTo: dataSource [
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> buildElement [
	self matchParent.
	self
		padding: (BlInsets
				top: 0
				left: 10
				bottom: 10
				right: 0).
	self margin: (BlInsets all: 0).
	self filterElement ifNotNil: [ :filter | self addChild: filter as: #filter ].
	self addChild: self listElement.
	self updateList
]

{ #category : #'as yet unclassified' }
GtSmaCCDefinitionListElement >> buildFilter [
	^ self subclassResponsibility
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> buildFilterModel [
	self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> defaultFilter [
	^ self userData at: #defaultFilter ifAbsent: [ self noFilterClass new ]
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> defaultFilter: aFilter [
	aFilter
		ifNil: [ self userData removeKey: #defaultFilter ifAbsent: [  ] ]
		ifNotNil: [ self userData at: #defaultFilter put: aFilter ].
	self enqueueTask: [ self updateFilters ] asBlTask
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> filter [
	^ self defaultFilter ifNil: [ GtSmaCCNoVariableFilter new ]
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> filterElement [
	filterModel
		ifNil: [ filterModel := self buildFilterModel.
			filterModel weak
				when: GtFiltersModelAnnouncement
				send: #updateFilters
				to: self ].
	^ filterModel asFiltersElement
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> group [
	^ group
]

{ #category : #accessing }
GtSmaCCDefinitionListElement >> group: aDefinitionGroupResult [
	group := self noFilterClass new applyInScope: aDefinitionGroupResult.
	aDefinitionGroupResult announcer weak
		when: GtSmaCCVariableGroupItemsChanged
		send: #updateFilters
		to: self.
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

{ #category : #accessing }
GtSmaCCDefinitionListElement >> noFilterClass [
	^ self subclassResponsibility
]

{ #category : #actions }
GtSmaCCDefinitionListElement >> scrollAndOpenItem: aString [
	1
		to: self group coders size
		do: [ :i | 
			(self group coders at: i) name = aString
				ifTrue: [ (self group coders at: i) expanded: true.
					self listElement scrollToPosition: i.
					self
						enqueueTask: (BlTaskAction new
								action: [ self
										allChildrenBreadthFirstDetect: [ :each | 
											(each isKindOf: GtSmaCCCoderElement)
												and: [ each coder = (self group coders at: i) ] ]
										ifFound: [ :each | each expand ] ]).
					^ true ] ].
	^ false
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateFilters [
	group ifNil: [ ^ self ].
	group filter: self buildFilter.
	self updateList
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateList [
	| highlighter |
	listElement ifNil: [ ^ self ].
	highlighter := group highlighter.
	group coders do: [ :each | each highlighter: highlighter ].
	listElement dataSource updateCoders
]
