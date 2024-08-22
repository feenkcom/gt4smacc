Extension { #name : #SmaCCTransformationToolkitModel }

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
SmaCCTransformationToolkitModel >> gtInputView: aView [
	<gtView>
	^ aView explicit
		title: 'Input';
		priority: 10;
		stencil: [ GtSmaCCTransformationInputElement new model: self ]
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
