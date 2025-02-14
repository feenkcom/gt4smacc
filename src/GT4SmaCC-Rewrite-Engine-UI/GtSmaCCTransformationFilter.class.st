Class {
	#name : #GtSmaCCTransformationFilter,
	#superclass : #GtSmaCCTransformationTextFilter,
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #accessing }
GtSmaCCTransformationFilter class >> filterDescriptor [
	^ GtFilterTextModel new
		creator: [ :aString | self new text: aString ];
		named: 'Transformation';
		beDefault;
		order: 30
]

{ #category : #private }
GtSmaCCTransformationFilter >> stringFor: anObject [
	^ (toolkit errorTransformationFor: anObject) ifEmpty: [ nil ]
]
