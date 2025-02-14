Class {
	#name : #GtSmaCCTransformationRunFilter,
	#superclass : #GtSmaCCTransformationFilesFilter,
	#instVars : [
		'hasRun'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #accessing }
GtSmaCCTransformationRunFilter class >> filterDescriptor [
	^ GtFilterToggleModel new
		creator: [ :each | self new hasRun: each itemValue ];
		name: 'Ran?';
		order: 40;
		items: (GtFilterModelPluggableItem
				forCollection: #(true false)
				label: [ :each | each asString ]);
		selectFirstItem
]

{ #category : #accessing }
GtSmaCCTransformationRunFilter >> hasRun [
	^ hasRun
]

{ #category : #accessing }
GtSmaCCTransformationRunFilter >> hasRun: anObject [
	hasRun := anObject
]

{ #category : #testing }
GtSmaCCTransformationRunFilter >> matches: anObject [
	^ (toolkit hasRun: anObject) = hasRun
]
