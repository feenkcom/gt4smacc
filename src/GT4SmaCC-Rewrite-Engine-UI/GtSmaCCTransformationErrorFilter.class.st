Class {
	#name : #GtSmaCCTransformationErrorFilter,
	#superclass : #GtSmaCCTransformationTextFilter,
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #accessing }
GtSmaCCTransformationErrorFilter class >> filterDescriptor [
	^ GtFilterTextModel new
		creator: [ :aString | self new text: aString ];
		named: 'Error';
		beDefault;
		order: 20
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationErrorFilter >> stringFor: anObject [
	^ (toolkit errorStringFor: anObject) ifEmpty: [ nil ]
]
