Class {
	#name : #GtSmaCCRewriteExpander,
	#superclass : #BrExpander,
	#instVars : [
		'rewrite'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCRewriteExpander class >> rewrite: aRewrite [
	^ self new
		rewrite: aRewrite;
		yourself
]

{ #category : #ui }
GtSmaCCRewriteExpander >> contentElement [
	^ self subclassResponsibility
]

{ #category : #private }
GtSmaCCRewriteExpander >> defaultTextAttributes [
	^ { (BlFontSizeAttribute size: 14) beNotOverwritableByStyler }
]

{ #category : #ui }
GtSmaCCRewriteExpander >> headerElement [
	^ (BrButton new)
		alignCenterLeft;
		padding: (BlInsets all: 5);
		vFitContent;
		hMatchParent;
		aptitude: (BrGlamorousLabelAptitude new weight: 550);
		label: rewrite displayString;
		background: (Color veryLightGray alpha: 0.6);
		action: [ self toggleExpanded ]
]

{ #category : #'initialize-release' }
GtSmaCCRewriteExpander >> initialize [
	super initialize.
	self vFitContent.
	self hMatchParent.
	self aptitude: (GtCoderExpanderAptitude new borderWidth: 0)
]

{ #category : #private }
GtSmaCCRewriteExpander >> labelFor: aString [
	^ BrLabel new
		text: aString;
		aptitude: BrGlamorousLabelAptitude new;
		padding: (BlInsets all: 5);
		hFitContent;
		yourself
]

{ #category : #accessing }
GtSmaCCRewriteExpander >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCRewriteExpander >> rewrite: aRewrite [
	rewrite notNil
		ifTrue: [ rewrite unsubscribe: self ].
	rewrite := aRewrite.
	rewrite notNil
		ifTrue: [ self subscribeEvents ].
	self updateContent
]

{ #category : #private }
GtSmaCCRewriteExpander >> subscribeEvents [
	
]

{ #category : #updating }
GtSmaCCRewriteExpander >> updateContent [
	self header: [ self headerElement ].
	self
		content:
			[ (BrVerticalFlow new)
				hMatchParent;
				vFitContent;
				addChild: self headerElement;
				addChild: self contentElement;
				yourself ]
]
