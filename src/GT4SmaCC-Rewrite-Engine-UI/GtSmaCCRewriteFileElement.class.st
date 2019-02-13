Class {
	#name : #GtSmaCCRewriteFileElement,
	#superclass : #BrAccordion,
	#instVars : [
		'file'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCRewriteFileElement class >> file: aRewriteFile [
	^ self new
		file: aRewriteFile;
		yourself
]

{ #category : #accessing }
GtSmaCCRewriteFileElement >> file [
	^ file
]

{ #category : #accessing }
GtSmaCCRewriteFileElement >> file: aSmaCCRewriteFile [
	file := aSmaCCRewriteFile
]
