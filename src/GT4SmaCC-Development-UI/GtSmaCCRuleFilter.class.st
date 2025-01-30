Class {
	#name : #GtSmaCCRuleFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'ruleClass'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCRuleFilter class >> filterDescriptor [
	^ GtFilterShortListModel new
		creator: [ :each | self ruleClass: each itemValue ];
		named: 'Rule';
		order: 15;
		items: (GtFilterModelPluggableItem
				forCollection: {GtSmaCCProductionRule.
						GtSmaCCTokenRule.
						GtSmaCCDirective}
				label: [ :each | (each name asString removeSuffix: 'Rule') removePrefix: 'GtSmaCC' ]);
		selectFirstItem
]

{ #category : #'instance creation' }
GtSmaCCRuleFilter class >> ruleClass: aClass [
	^ self new ruleClass: aClass
]

{ #category : #'as yet unclassified' }
GtSmaCCRuleFilter >> matches: anObject [
	ruleClass ifNil: [ ^ true ].
	^ anObject isKindOf: ruleClass
]

{ #category : #accessing }
GtSmaCCRuleFilter >> ruleClass [
	^ ruleClass
]

{ #category : #accessing }
GtSmaCCRuleFilter >> ruleClass: anObject [
	ruleClass := anObject
]
