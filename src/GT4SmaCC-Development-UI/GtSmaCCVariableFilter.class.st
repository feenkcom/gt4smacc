Class {
	#name : #GtSmaCCVariableFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'as yet unclassified' }
GtSmaCCVariableFilter class >> availableFilters [
	^ {GtFilterTextModel new
			creator: [ :aString | GtSmaCCVariableNameFilter pattern: aString ];
			named: 'Name';
			order: 10}
]

{ #category : #'as yet unclassified' }
GtSmaCCVariableFilter >> resultType [
	^ GtSmaCCVariableGroupResult
]
