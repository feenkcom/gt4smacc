Extension { #name : #SmaCCAbstractRewrite }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> asElement [
	self subclassResponsibility
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> asElementInTree [
	| topParent |
	topParent := self topParent.
	self == topParent ifTrue: [ ^ self asElement ].
	^ GtSmaCCTransformationElement new
		rewrites: topParent;
		selectAndScrollToRewrite: self;
		yourself
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowValuableTool new
				name: self topParent displayString;
				valuable: [ self asElementInTree ]);
		addTool: super gtDefaultInspectorTool
]
