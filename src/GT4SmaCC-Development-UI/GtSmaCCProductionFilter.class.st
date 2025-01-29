Class {
	#name : #GtSmaCCProductionFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCProductionFilter class >> filterDescriptor [
	^ GtFilterShortListModel new
		creator: [ :each | each itemValue new ];
		named: 'Type';
		order: 15;
		items: (GtFilterModelPluggableItem
				forCollection: {GtSmaCCProductionFilter.
						GtSmaCCTokenFilter.
						GtSmaCCDirectiveFilter}
				label: [ :each | (each name asString allButFirst: 7) allButLast: 6 ]);
		selectFirstItem
]

{ #category : #testing }
GtSmaCCProductionFilter >> matches: anObject [
	^ anObject isKindOf: GtSmaCCProductionRule
]
