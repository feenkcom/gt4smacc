Extension { #name : #SmaCCTransformationToolkitModel }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> asRRJob [
	| job |
	job := GtRrTasksJob
			tasks: (self files
					collect: [ :each | 
						GtSmaCCTransformationTask new
							filename: each;
							rewritesFile: rewrites filename asFileReference pathString;
							commonParentDirectory: self commonParentDirectory;
							inputParserName: inputParserClass name;
							outputParserName: (validationParserClass ifNotNil: [ validationParserClass name ]);
							outputDirectory: outputDirectory;
							lineEnding: lineEnding ]).
	^ job
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> createSubdirectoriesDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #createSubdirectories;
		label: 'Create subdirectories';
		priority: 180;
		default: true;
		yourself
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowExplicitTool new
				name: 'SmaCC';
				stencil: [ GtSmaCCTransformationToolkit new model: self ]);
		addTool: super gtDefaultInspectorTool
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> gtInputView: aView [
	<gtView>
	^ aView explicit
		title: 'Transformation';
		priority: 10;
		stencil: [ GtSmaCCTransformationToolkit new model: self ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> gtUpdateElement: element [
	element ifNil: [ ^ self ].
	element rewrites ~~ self rewrites ifTrue: [ element rewrites: self rewrites ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> inputParserClassDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		accessor: #inputParserClass;
		label: 'Input parser';
		priority: 100;
		default: SmaCCParser;
		options: (SmaCCParser withAllSubclasses asSortedCollection: [ :a :b | a name < b name ]);
		reference: MAClassDescription new;
		yourself
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> outputDirectoryDescription [
	<magritteDescription>
	^ MADirectoryDescription new
		label: 'Output directory';
		priority: 150;
		kind: AbstractFileReference;
		accessor: #outputDirectoryReference
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> outputDirectoryReference [
	| dir |
	dir := self outputDirectory.
	^ (dir isEmpty ifTrue: [ '.' ] ifFalse: [ dir ]) asFileReference
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> outputDirectoryReference: aFileReference [
	self outputDirectory: aFileReference pathString
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> rewriteFilename [
	^ rewrites filename ifNil: [ 'new file.rw' asFileReference ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> rewriteFilename: aFileReference [
	^ self loadRewriteFile: aFileReference
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> rewriteFilenameDescription [
	<magritteDescription>
	^ MAFileDescription new
		label: 'Rewrite file';
		priority: 140;
		kind: AbstractFileReference;
		accessor: #rewriteFilename;
		beOptional
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> runOnServerDescription [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: #runOnServer;
		label: 'Run on server';
		priority: 200;
		default: false;
		yourself
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> serverDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Server';
		priority: 190;
		accessor: #server;
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousCodeFontAndSmallSize ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitModel >> validationParserClassDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		accessor: #validationParserClass;
		label: 'Validation parser';
		priority: 110;
		default: SmaCCParser;
		options: (SmaCCParser withAllSubclasses asSortedCollection: [ :a :b | a name < b name ]);
		reference: MAClassDescription new;
		yourself
]
