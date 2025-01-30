Class {
	#name : #GtSmaCCCoderListElement,
	#superclass : #GtSmaCCDefinitionListElement,
	#instVars : [
		'filterModel'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #filtering }
GtSmaCCCoderListElement >> addBadgeFilter: aSymbol [
	(self includesBadge: aSymbol) ifTrue: [ ^ self ].
	filterModel
		addFilterModel: (GtSmaCCSelectorFilter filterDescriptorForSelector: aSymbol).
	self updateFilters
]

{ #category : #ui }
GtSmaCCCoderListElement >> addItemLookTo: dataSource [
	dataSource lookBlock: [ GtSmaCCBadgesAptitude new definitionList: self ]
]

{ #category : #ui }
GtSmaCCCoderListElement >> filterElement [
	filterModel
		ifNil: [ filterModel := GtFilterItemsModel new
					items: {GtSmaCCSourcePatternFilter filterDescriptor};
					availableFiltersBuilder: GtSmaCCDefinitionsFilter.
			filterModel weak
				when: GtFiltersModelAnnouncement
				send: #updateFilters
				to: self ].
	^ filterModel asFiltersElement
]

{ #category : #private }
GtSmaCCCoderListElement >> filterErrors [
	filterModel addFilterModel: GtSmaCCDefinitionErrorFilter filterDescriptor
]

{ #category : #filtering }
GtSmaCCCoderListElement >> findFilterForSelector: aSymbol [
	| filter |
	filter := GtSmaCCSelectorFilter filterDescriptorForSelector: aSymbol.
	^ filterModel items
		detect: [ :each | 
			each = filter
				and: [ (each isKindOf: GtFilterSelectableItemModel) not
						or: [ each selectedItem = filter selectedItem ] ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtSmaCCCoderListElement >> group: aDefinitionGroupResult [
	super
		group: (GtSmaCCNoFilter new applyInScope: aDefinitionGroupResult)
]

{ #category : #testing }
GtSmaCCCoderListElement >> includesBadge: aSymbol [
	^ (self findFilterForSelector: aSymbol) notNil
]

{ #category : #filtering }
GtSmaCCCoderListElement >> removeBadgeFilter: aSymbol [
	| model |
	model := self findFilterForSelector: aSymbol.
	model ifNil: [ ^ self ].
	filterModel removeFilterModel: model.
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
	editor := BrTextEditorModel new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self updateFilters ];
		when: BrTextEditorDeletedEvent do: [ :event | self updateFilters ].
	element := BrEditorElement new.
	element
		addAptitude: (BrGlamorousWithLabelTooltipAptitude new text: 'Search Grammar').
	element editor: editor.
	element border: (BlBorder paint: self theme editor borderColor width: 1).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		margin: (BlInsets
				top: 10
				left: 0
				bottom: 0
				right: 0).
	element padding: (BlInsets all: 3).
	^ element
]

{ #category : #filtering }
GtSmaCCCoderListElement >> toggleBadgeFilter: aSymbol [
	^ (self includesBadge: aSymbol)
		ifTrue: [ self removeBadgeFilter: aSymbol ]
		ifFalse: [ self addBadgeFilter: aSymbol ]
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
				aptitude: BrGlamorousButtonLabelAptitude + BrGlamorousToggleBackgroundAptitude;
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
	filter := (filterModel items collect: #asSearchFilter)
			inject: GtSmaCCNoFilter new
			into: [ :sum :each | sum & each ].
	group filter: filter.
	self updateList
]
