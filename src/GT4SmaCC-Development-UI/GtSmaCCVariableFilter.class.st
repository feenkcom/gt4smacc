Class {
	#name : #GtSmaCCVariableFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCVariableFilter class >> availableFilters [
	^ {GtFilterTextModel new
			creator: [ :aString | GtSmaCCVariableNameFilter pattern: aString ];
			named: 'Name';
			order: 10}
]

{ #category : #accessing }
GtSmaCCVariableFilter >> resultType [
	^ GtSmaCCVariableGroupResult
]
