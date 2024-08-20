Extension { #name : #SmaCCAbstractRewrite }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> asElement [
	self subclassResponsibility
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowValuableTool new
				name: self displayString;
				valuable: [ self asElement ]);
		addTool: super gtDefaultInspectorTool
]
