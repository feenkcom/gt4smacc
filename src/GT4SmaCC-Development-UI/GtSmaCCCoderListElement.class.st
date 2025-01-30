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
		addFilterModel: (GtSmaCCSelectorFilter filterDescriptorForSelector: aSymbol)
]

{ #category : #ui }
GtSmaCCCoderListElement >> addItemLookTo: dataSource [
	dataSource lookBlock: [ GtSmaCCBadgesAptitude new definitionList: self ]
]

{ #category : #private }
GtSmaCCCoderListElement >> buildFilter [
	| filter |
	filter := GtSmaCCNoFilter new.
	((filterModel items collect: #asSearchFilter) groupedBy: #class)
		keysAndValuesDo: [ :key :filters | 
			filter := filter
					& (filters
							reduce: (key defaultIsIntersection
									ifTrue: [ [ :a :b | a & b ] ]
									ifFalse: [ [ :a :b | a | b ] ])) ].
	^ filter
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
	filterModel removeFilterModel: model
]

{ #category : #filtering }
GtSmaCCCoderListElement >> toggleBadgeFilter: aSymbol [
	^ (self includesBadge: aSymbol)
		ifTrue: [ self removeBadgeFilter: aSymbol ]
		ifFalse: [ self addBadgeFilter: aSymbol ]
]

{ #category : #private }
GtSmaCCCoderListElement >> updateFilters [
	| filter |
	filter := self buildFilter.
	group filter: filter.
	self updateList
]
