Class {
	#name : #GtSmaCCTransformationPathFilter,
	#superclass : #GtSmaCCTransformationTextFilter,
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #accessing }
GtSmaCCTransformationPathFilter class >> filterDescriptor [
	^ GtFilterTextModel new
		creator: [ :aString | self new text: aString ];
		named: 'Path string';
		beDefault;
		order: 20
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationPathFilter >> stringFor: anObject [
	^ anObject pathString
]
