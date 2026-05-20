Class {
	#name : #GtSmaCCVariableListElement,
	#superclass : #GtSmaCCDefinitionListElement,
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #filtering }
GtSmaCCVariableListElement >> buildFilter [
	filterModel ifNil: [ ^ self defaultFilter ].
	^ filterModel items
		inject: self defaultFilter
		into: [ :sum :each | sum & each asSearchFilter ]
]

{ #category : #filtering }
GtSmaCCVariableListElement >> buildFilterModel [
	^ GtFilterItemsModel new
		items: {GtSmaCCVariableFilter availableFilters first};
		availableFiltersBuilder: GtSmaCCVariableFilter
]

{ #category : #accessing }
GtSmaCCVariableListElement >> noFilterClass [
	^ GtSmaCCNoVariableFilter
]
