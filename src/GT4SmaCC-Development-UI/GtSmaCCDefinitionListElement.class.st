Class {
	#name : #GtSmaCCDefinitionListElement,
	#superclass : #BlElement,
	#instVars : [
		'group',
		'listElement',
		'badgeTypes'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #filtering }
GtSmaCCDefinitionListElement >> addBadgeFilter: aSymbol [
	badgeTypes add: aSymbol.
	self updateFilters
]

{ #category : #filtering }
GtSmaCCDefinitionListElement >> badgeFilter [
	^ badgeTypes
		inject: GtSmaCCNoFilter new
		into: [ :sum :each | sum & (GtSmaCCSelectorFilter selector: each) ]
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
	self addChild: self filterElement as: #filter.
	self addChild: self listElement.
	self updateList
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> filterElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: self textSearchElement as: #textSearch.
	element addChild: self typeFilterElement as: #toggles.
	^ element
]

{ #category : #private }
GtSmaCCDefinitionListElement >> filterErrors [
	| filter |
	filter := GtSmaCCDefinitionErrorFilter new.
	group filter: filter.
	self updateList
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

{ #category : #testing }
GtSmaCCDefinitionListElement >> includesBadge: aSymbol [
	^ badgeTypes includes: aSymbol
]

{ #category : #'initialize-release' }
GtSmaCCDefinitionListElement >> initialize [
	super initialize.
	badgeTypes := Set new
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> listElement [
	^ listElement
		ifNil: [ | dataSource |
			dataSource := GtSmaCCGroupCoderDataSource new group: group.
			dataSource
				lookBlock: [ GtSmaCCBadgesLook new definitionList: self ].
			listElement := GtSmaCCGroupCoderInfiniteElement new
				dataSource: dataSource;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			listElement ]
]

{ #category : #filtering }
GtSmaCCDefinitionListElement >> removeBadgeFilter: aSymbol [
	badgeTypes remove: aSymbol ifAbsent: [  ].
	self updateFilters
]

{ #category : #filtering }
GtSmaCCDefinitionListElement >> ruleTypeFilter [
	^ (self
		childNamed: #toggles
		ifFound: [ :element | 
			| filter toggleRule |
			self ruleTypes
				with: element children
				do: [ :name :toggle | 
					toggle isActivated
						ifTrue: [ toggleRule := ('GtSmaCC' , name , 'Filter') asSymbol asClass new.
							filter := filter isNil
								ifTrue: [ toggleRule ]
								ifFalse: [ filter | toggleRule ] ] ].
			filter ]
		ifNone: [  ]) ifNil: [ GtSmaCCNoFilter new ]
]

{ #category : #private }
GtSmaCCDefinitionListElement >> ruleTypes [
	^ #('Production' 'Token' 'Directive')
]

{ #category : #filtering }
GtSmaCCDefinitionListElement >> searchFilter [
	| string |
	string := self
		childNamed: #textSearch
		ifFound: [ :element | element editor text asString ]
		ifNone: [ '' ].
	^ string isEmpty
		ifTrue: [ GtSmaCCNoFilter new ]
		ifFalse: [ GtSmaCCSourcePatternFilter pattern: string ]
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> textSearchElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self updateFilters ];
		when: BrTextEditorDeletedEvent do: [ :event | self updateFilters ].
	element := BrEditorElement new.
	element editor: editor.
	element
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		margin:
			(BlInsets
				top: 10
				left: 0
				bottom: 0
				right: 0).
	element padding: (BlInsets all: 3).
	^ element
]

{ #category : #ui }
GtSmaCCDefinitionListElement >> typeFilterElement [
	| toggles element |
	toggles := self ruleTypes
		collect: [ :each | 
			| toggle |
			toggle := BrToggle new
				layout: BlLinearLayout horizontal alignCenter;
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical exact: 16.
					c padding: (BlInsets all: 6) ];
				margin:
					(BlInsets
						top: 0
						left: 2
						bottom: 0
						right: 2);
				constraintsDo: [ :c | 
					c frame horizontal alignRight.
					c frame vertical alignTop ];
				label:
					(each asRopedText
						attributes:
							{(BlFontSizeAttribute size: 12).
							(BlFontFamilyAttribute named: 'Source Sans Pro')});
				look: GtCoderToggleLook;
				when: BrToggleActivatedEvent
					do: [ :anEvent | self updateFilters ];
				when: BrToggleDeactivatedEvent
					do: [ :anEvent | self updateFilters ] ].
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element margin: (BlInsets top: 10 bottom: 10).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChildren: toggles.
	^ element
]

{ #category : #private }
GtSmaCCDefinitionListElement >> updateFilters [
	| filter |
	filter := self searchFilter & self ruleTypeFilter & self badgeFilter.
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
