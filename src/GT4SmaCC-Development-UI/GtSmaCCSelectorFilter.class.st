Class {
	#name : #GtSmaCCSelectorFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'selector'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCSelectorFilter class >> filterDescriptorForSelector: aSelector [
	^ aSelector = #isScannerMethod
		ifTrue: [ self scannerFilterDescriptor ]
		ifFalse: [ | descriptor |
			descriptor := self parserFilterDescriptor.
			descriptor
				selectedItem: (descriptor items detect: [ :each | each itemValue = aSelector ]).
			descriptor ]
]

{ #category : #accessing }
GtSmaCCSelectorFilter class >> filterDescriptors [
	^ {self parserFilterDescriptor.
		self scannerFilterDescriptor}
]

{ #category : #accessing }
GtSmaCCSelectorFilter class >> parserFilterDescriptor [
	^ GtFilterShortListModel new
		creator: [ :each | self selector: each itemValue ];
		name: 'Reduce expression';
		order: 30;
		items: (GtFilterModelPluggableItem
				forCollection: #(hasASTExpression hasCodeExpression hasDefaultExpression)
				label: [ :each | (each asString allButFirst: 3) allButLast: 10 ]);
		selectFirstItem
]

{ #category : #accessing }
GtSmaCCSelectorFilter class >> scannerFilterDescriptor [
	^ GtFilterInvariableModel new
		name: 'Scanner methods';
		creator: [ self selector: #isScannerMethod ];
		order: 40
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
