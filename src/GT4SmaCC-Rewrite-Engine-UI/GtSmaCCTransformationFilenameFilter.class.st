Class {
	#name : #GtSmaCCTransformationFilenameFilter,
	#superclass : #GtSmaCCTransformationTextFilter,
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #accessing }
GtSmaCCTransformationFilenameFilter class >> filterDescriptor [
	^ GtFilterTextModel new
		creator: [ :aString | self new text: aString ];
		named: 'Basename';
		beDefault;
		order: 10
]

{ #category : #testing }
GtSmaCCTransformationFilenameFilter >> stringFor: anObject [
	^ anObject basename
]
