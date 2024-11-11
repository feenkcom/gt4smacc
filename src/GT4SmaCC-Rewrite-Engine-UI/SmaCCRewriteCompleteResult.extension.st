Extension { #name : #SmaCCRewriteCompleteResult }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteCompleteResult >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowExplicitTool new
				name: self gtDisplayString;
				stencil: [ GtSmaCCPreviewElement new previewResult: self ]);
		addTool: super gtDefaultInspectorTool
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteCompleteResult >> gtDisplayOn: stream [
	self filename ifNotNil: [ stream << self filename asFileReference basename ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteCompleteResult >> gtPreviewFor: aView [
	<gtView>
	^ aView explicit
		title: 'Preview';
		stencil: [ GtSmaCCPreviewElement new previewResult: self ]
]
