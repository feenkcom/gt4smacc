Class {
	#name : #GtSmaCCRewriteAccordion,
	#superclass : #BrAccordion,
	#instVars : [
		'rewrite'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCRewriteAccordion class >> rewrite: aRewrite [
	^ self new
		rewrite: aRewrite;
		yourself
]

{ #category : #updating }
GtSmaCCRewriteAccordion >> contentElement [
	^ BlElement new
		size: 100 @ 100;
		yourself
]

{ #category : #private }
GtSmaCCRewriteAccordion >> defaultTextAttributes [
	^ {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #updating }
GtSmaCCRewriteAccordion >> headerElement [
	^ BrButton new
		padding: (BlInsets all: 5);
		look:
			BrLayoutLook linearHorizontal vFitContent hMatchParent
				+
					(BrGlamorousTextLabelLook new
						weight: 550;
						yourself);
		label: rewrite displayString;
		background: (Color veryLightGray alpha: 0.6);
		action: [ self toggle ]
]

{ #category : #'instance creation' }
GtSmaCCRewriteAccordion >> initialize [
	super initialize.
	self vFitContent.
	self hMatchParent.
	self look: BrGlamorousAccordionWithBorderLook new
]

{ #category : #private }
GtSmaCCRewriteAccordion >> labelFor: aString [
	^ BrLabel new
		text: aString;
		look: BrGlamorousLabelLook new;
		padding: (BlInsets all: 5);
		hFitContent;
		yourself
]

{ #category : #accessing }
GtSmaCCRewriteAccordion >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCRewriteAccordion >> rewrite: aRewrite [
	rewrite := aRewrite.
	self updateContent
]

{ #category : #updating }
GtSmaCCRewriteAccordion >> updateContent [
	self content: [ self contentElement ].
	self header: [ self headerElement ]
]
