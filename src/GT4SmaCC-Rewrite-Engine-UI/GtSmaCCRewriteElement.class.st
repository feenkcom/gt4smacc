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

{ #category : #initialization }
GtSmaCCRewriteElement >> initialize [
	super initialize.
	self look: BrGlamorousAccordionWithBorderLook new
]

{ #category : #accessing }
GtSmaCCRewriteElement >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCRewriteElement >> rewrite: aSmaCCRewrite [
	rewrite := aSmaCCRewrite.
	self updateContent
]

{ #category : #updating }
GtSmaCCRewriteElement >> updateContent [
	self
		content: [ BlElement new
				size: 100 @ 100;
				yourself ].
	self
		header: [ BrButton new
				look: BrGlamorousAccordionHeaderLook new;
				label: rewrite displayString;
				action: [ self toggle ] ]
]
