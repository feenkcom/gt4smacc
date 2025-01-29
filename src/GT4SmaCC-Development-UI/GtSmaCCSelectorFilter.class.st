Class {
	#name : #GtSmaCCSelectorFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'selector'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCSelectorFilter class >> filterDescriptor [
	^ GtFilterShortListModel new
		creator: [ :each | self selector: each itemValue ];
		named: 'Reduce expression';
		order: 30;
		items: (GtFilterModelPluggableItem
				forCollection: #(hasASTExpression hasCodeExpression hasDefaultExpression)
				label: [ :each | (each asString allButFirst: 3) allButLast: 10 ]);
		selectFirstItem
]

{ #category : #'instance creation' }
GtSmaCCSelectorFilter class >> selector: aString [
	^ self new
		selector: aString;
		yourself
]

{ #category : #testing }
GtSmaCCSelectorFilter >> matches: anObject [
	^ [ anObject perform: selector ] onDNU: selector do: [ :ex | false ]
]

{ #category : #accessing }
GtSmaCCSelectorFilter >> selector: aSymbol [
	selector := aSymbol
]
