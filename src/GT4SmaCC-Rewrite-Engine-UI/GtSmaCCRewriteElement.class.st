Class {
	#name : #GtSmaCCRewriteElement,
	#superclass : #BrAccordion,
	#instVars : [
		'rewrite'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCRewriteElement class >> rewrite: aRewrite [
	^ self new
		rewrite: aRewrite;
		yourself
]

{ #category : #accessing }
GtSmaCCRewriteElement >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCRewriteElement >> rewrite: aSmaCCRewrite [
	rewrite := aSmaCCRewrite
]
