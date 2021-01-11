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

{ #category : #ui }
GtSmaCCRewriteAccordion >> contentElement [
	^ self subclassResponsibility
]

{ #category : #private }
GtSmaCCRewriteAccordion >> defaultTextAttributes [
	^ { (BlFontSizeAttribute size: 14) beNotOverwritableByStyler }
]

{ #category : #ui }
GtSmaCCRewriteAccordion >> headerElement [
	^ BrButton new
		alignCenterLeft;
		padding: (BlInsets all: 5);
		vFitContent;
		hMatchParent;
		look: (BrGlamorousLabelLook new weight: 550);
		label: rewrite displayString;
		background: (Color veryLightGray alpha: 0.6);
		action: [ self toggle ]
]

{ #category : #'initialize-release' }
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
	rewrite notNil
		ifTrue: [ rewrite unsubscribe: self ].
	rewrite := aRewrite.
	rewrite notNil
		ifTrue: [ self subscribeEvents ].
	self updateContent
]

{ #category : #private }
GtSmaCCRewriteAccordion >> subscribeEvents [
	
]

{ #category : #updating }
GtSmaCCRewriteAccordion >> updateContent [
	self content: [ self contentElement ].
	self header: [ self headerElement ]
]
