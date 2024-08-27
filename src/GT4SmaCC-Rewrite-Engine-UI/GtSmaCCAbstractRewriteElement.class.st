Class {
	#name : #GtSmaCCAbstractRewriteElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'rewrite'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCAbstractRewriteElement class >> rewrite: aRewrite [
	^ self new
		rewrite: aRewrite;
		yourself
]

{ #category : #building }
GtSmaCCAbstractRewriteElement >> addCommentElement [
	| commentEditor label |
	label := (BrLabel new)
		margin: (BlInsets top: 5 right: 5);
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Comment:'.
	commentEditor := (BrEditor new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		hMatchParent;
		vFitContent;
		aptitude: BrGlamorousRegularEditorAptitude new;
		beEditable;
		text: rewrite comment asRopedText.
	commentEditor editor when: BrTextEditorModifiedEvent do: [ :event | rewrite comment: event text asString ].
	self
		addChild:
			((BrHorizontalPane new)
				vFitContent;
				hMatchParent;
				margin: (BlInsets bottom: 5);
				addChild: label;
				addChild: commentEditor as: #commentEditor;
				yourself)
]

{ #category : #building }
GtSmaCCAbstractRewriteElement >> build [
	self addCommentElement
]

{ #category : #private }
GtSmaCCAbstractRewriteElement >> connectModel [
	rewrite ifNil: [ ^ self ].
	rewrite announcer weak
		when: #comment
		send: #updateComment
		to: self
]

{ #category : #private }
GtSmaCCAbstractRewriteElement >> disconnectModel [
	rewrite ifNil: [ ^ self ].
	rewrite announcer unsubscribe: self
]

{ #category : #'initialize-release' }
GtSmaCCAbstractRewriteElement >> initialize [
	super initialize.
	self matchParent.
	self padding: (BlInsets all: 5)
]

{ #category : #accessing }
GtSmaCCAbstractRewriteElement >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCAbstractRewriteElement >> rewrite: aRewrite [
	self disconnectModel.
	rewrite := aRewrite.
	self connectModel.
	self updateContent
]

{ #category : #updating }
GtSmaCCAbstractRewriteElement >> updateComment [
	self childNamed: #commentEditor ifFound: [ :editor | editor text: rewrite comment asRopedText ]
]

{ #category : #updating }
GtSmaCCAbstractRewriteElement >> updateContent [
	self children isEmpty ifTrue: [ ^ self build ].
	self childNamed: #commentEditor ifFound: [ :editor | editor text: rewrite comment asRopedText ]
]
