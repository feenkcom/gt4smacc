Extension { #name : #SmaCCAbstractRewrite }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> asElement [
	self subclassResponsibility
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> asElementInTree [
	| topParent |
	topParent := self topParent.
	(topParent isKindOf: SmaCCRewriteFile) ifFalse: [ ^ self asElement ].
	^ GtSmaCCTransformationElement new
		rewrites: topParent;
		selectAndScrollToRewrite: self;
		hideLoadButton;
		yourself
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> gtEditorFor: aView [
	<gtView>
	^ aView explicit
		title: 'Editor';
		priority: 10;
		stencil: [ self asElementInTree ]
]
