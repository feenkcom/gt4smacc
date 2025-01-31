Class {
	#name : #GtSmaCCVariableListElement,
	#superclass : #GtSmaCCDefinitionListElement,
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #filtering }
GtSmaCCVariableListElement >> buildFilter [
	^ filterModel items
		inject: GtSmaCCNoVariableFilter new
		into: [ :sum :each | sum & each asSearchFilter ]
]

{ #category : #filtering }
GtSmaCCVariableListElement >> buildFilterModel [
	^ GtFilterItemsModel new
		items: {GtSmaCCVariableFilter availableFilters first};
		availableFiltersBuilder: GtSmaCCVariableFilter
]

{ #category : #accessing }
GtSmaCCVariableListElement >> group: aDefinitionGroupResult [
	super
		group: (GtSmaCCNoVariableFilter new applyInScope: aDefinitionGroupResult)
]
