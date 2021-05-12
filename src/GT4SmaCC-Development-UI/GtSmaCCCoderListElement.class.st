Class {
	#name : #GtSmaCCCoderListElement,
	#superclass : #GtSmaCCDefinitionListElement,
	#instVars : [
		'badgeTypes'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #filtering }
GtSmaCCCoderListElement >> addBadgeFilter: aSymbol [
	badgeTypes add: aSymbol.
	self updateFilters
]

{ #category : #ui }
GtSmaCCCoderListElement >> addItemLookTo: dataSource [
	dataSource lookBlock: [ GtSmaCCBadgesAptitude new definitionList: self ]
]

{ #category : #filtering }
GtSmaCCCoderListElement >> badgeFilter [
	^ badgeTypes
		inject: GtSmaCCNoFilter new
		into: [ :sum :each | sum & (GtSmaCCSelectorFilter selector: each) ]
]

{ #category : #ui }
GtSmaCCCoderListElement >> filterElement [
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
GtSmaCCCoderListElement >> filterErrors [
	| filter |
	filter := GtSmaCCDefinitionErrorFilter new.
	group filter: filter.
	self updateList
]

{ #category : #accessing }
GtSmaCCCoderListElement >> group: aDefinitionGroupResult [
	super
		group: (GtSmaCCNoFilter new applyInScope: aDefinitionGroupResult)
]

{ #category : #testing }
GtSmaCCCoderListElement >> includesBadge: aSymbol [
	^ badgeTypes includes: aSymbol
]

{ #category : #'initialize-release' }
GtSmaCCCoderListElement >> initialize [
	super initialize.
	badgeTypes := Set new
]

{ #category : #filtering }
GtSmaCCCoderListElement >> removeBadgeFilter: aSymbol [
	badgeTypes remove: aSymbol ifAbsent: [  ].
	self updateFilters
]

{ #category : #filtering }
GtSmaCCCoderListElement >> ruleTypeFilter [
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
GtSmaCCCoderListElement >> ruleTypes [
	^ #('Production' 'Token' 'Directive')
]

{ #category : #filtering }
GtSmaCCCoderListElement >> searchFilter [
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
GtSmaCCCoderListElement >> textSearchElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self updateFilters ];
		when: BrTextEditorDeletedEvent do: [ :event | self updateFilters ].
	element := BrEditorElement new.
	element editor: editor.
	element
		border: (BlBorder paint: self theme editor borderColor width: 1).
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
GtSmaCCCoderListElement >> typeFilterElement [
	| toggles element |
	toggles := self ruleTypes
		collect: [ :each | 
			BrToggle new
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
				aptitude: GtCoderToggleAptitude;
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
GtSmaCCCoderListElement >> updateFilters [
	| filter |
	filter := self searchFilter & self ruleTypeFilter & self badgeFilter.
	group filter: filter.
	self updateList
]
