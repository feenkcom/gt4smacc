Extension { #name : #SmaCCTransformationToolkitModel }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowValuableTool new
				name: self gtDisplayString;
				valuable: [ GtSmaCCTransformationToolkit new model: self ]);
		addTool: super gtDefaultInspectorTool
]
