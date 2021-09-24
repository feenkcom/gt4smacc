Class {
	#name : 'GtSmaCCTransformationToolkit',
	#superclass : 'Object',
	#instVars : [
		'model',
		'windowElement',
		'filesList',
		'previewElement',
		'previewResult',
		'transformationsElement'
	],
	#category : 'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : 'world menu' }
GtSmaCCTransformationToolkit class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'SmaCC Transformation Toolkit (GT)')
		parent: #Tools;
		order: 490.31;
		action: [ self open ].
	aBuilder withSeparatorAfter
]

{ #category : 'opening' }
GtSmaCCTransformationToolkit class >> open [
	^ self new open
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> annotationsInNewRanges: intervals [
	| items |
	items := IdentitySet new.
	intervals
		do: [ :each | 
			items
				addAll: (previewResult transformedString annotationsInNewRange: each) ].
	^ items
		asSortedCollection: [ :a :b | a nodeInterval first < b nodeInterval first ]
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> annotationsInOriginalRanges: intervals [
	| items |
	items := IdentitySet new.
	intervals
		do: [ :each | 
			items
				addAll: (previewResult transformedString annotationsInOriginalRange: each) ].
	^ items
		asSortedCollection: [ :a :b | a nodeInterval first < b nodeInterval first ]
]

{ #category : 'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationBody [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element addChild: self filesElement.
	^ element
]

{ #category : 'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationElement [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		addChild: self configurationToolbar;
		addChild: self configurationBody;
		yourself
]

{ #category : 'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		hMatchParent;
		addItems: self configurationToolbarItems
]

{ #category : 'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationToolbarItems [
	^ #(
		#('Load' #open #loadConfiguration) 
		#('Save' #save #saveConfiguration)
		#('Run' #play #run)
		#('Preview' #playinspect #preview)
		)
		collect: [ :each | 
			self
				createToolbarButton: each first
				icon: (BrGlamorousIcons perform: each second)
				action: [ self perform: each last ] ]
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> connectModel [
	| announcer |
	announcer := model announcer weak.
	#(
		#(#createSubdirectories #updateCreateSubdirectories)
		#(#files #updateFiles)
		#(#inputParserClass #updateInputParserClass)
		#(#outputDirectory #updateOutputDirectory)
		#(#rewrites #updateRewrites)
		#(#runOnServer #updateRunOnServer)
		#(#server #updateServer)
		#(#validationParserClass #updateValidationParserClass)
	) do: [ :each | 
		announcer when: each first send: each last to: self.
		self perform: each last ].
"		#(#addTransformation:under:)
		#(#resultAdded #addedResult:)
		#(#removedTransformation:)"
]

{ #category : 'ui' }
GtSmaCCTransformationToolkit >> createToolbarButton: aString icon: anIcon action: aBlock [
	^ BrButton new
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: aString;
		icon: anIcon asElement;
		action: aBlock
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> disconnectModel [
	model announcer unsubscribe: self
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> displayPreviewResult: aResult [
	previewResult := aResult.
	self previewElement
		layout: (BlGridLayout vertical rowCount: 2);
		removeChildren;
		addChild:
			(self previewFilesElement
				constraintsDo: [ :c | c grid vertical weight: 3 ];
				yourself);
		addChild: self previewRulesElement
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> editorFor: aString parser: aClass [
	| editor element |
	editor := BrTextEditor new.
	editor text: aString asRopedText.
	aClass notNil
		ifTrue:
			[ aClass gtStyler ifNotNil: [ :styler | editor styler: styler ] ].
	element := BrEditorElement new.
	element
		editor: editor;
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ element
]

{ #category : 'ui-configuration' }
GtSmaCCTransformationToolkit >> filesElement [
	| element label |
	element := BlElement new
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 5);
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	label := BrLabel new
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Files'.
	element addChild: label.
	filesList := BrSimpleList new
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		stencil: [ :each :index | 
			BlTextElement new
				text: each asRopedText;
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent
					do: [ :anEvent | 
					anEvent consumed: true.
					filesList selectOne: index ] ].
	element addChild: filesList.
	^ element
]

{ #category : 'configuration-actions' }
GtSmaCCTransformationToolkit >> gotoPreviewTab [
	self previewTab select
]

{ #category : 'initialize-release' }
GtSmaCCTransformationToolkit >> initialize [
	super initialize.
	self model: SmaCCTransformationToolkitModel new
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> lineNumberFor: anInteger in: aString [
	| stream |
	stream := SmaCCLineNumberStream on: aString readStream.
	stream position: anInteger.
	^ stream lineNumber
]

{ #category : 'configuration-actions' }
GtSmaCCTransformationToolkit >> loadConfiguration [
	| file |
	file := self promptForFile: 'Load Configuration File' extensions: #('rwc').
	file isNil
		ifTrue: [ ^ self ].
	self model: (SmaCCTransformationToolkitModel new loadFile: file).
"	self fileResults removeAll.
	self result: SmaCCRewriteCompleteResult new"
]

{ #category : 'accessing' }
GtSmaCCTransformationToolkit >> model [
	^ model
]

{ #category : 'accessing' }
GtSmaCCTransformationToolkit >> model: aSmaCCTransformationToolkitModel [
	model notNil
		ifTrue: [ self disconnectModel ].
	model := aSmaCCTransformationToolkitModel.
	model notNil
		ifTrue: [ self connectModel ]
]

{ #category : 'ui' }
GtSmaCCTransformationToolkit >> open [
	| space |
	space := BlSpace new.
	space withHalos.
	space title: 'SmaCC Transformation Toolkit'.
	space extent: 1200 @ 800.
	space root addChild: self windowElement.
	space show
]

{ #category : 'configuration-actions' }
GtSmaCCTransformationToolkit >> openResultFor: aFilename [
	| result processor |
	aFilename isNil
		ifTrue: [ ^ self ].
	Cursor wait
		showWhile: [ result := SmaCCRewriteCompleteResult new.
			processor := SmaCCRewriteProcessor new.
			processor rules: self model rewrites.
			processor parserClass: self model inputParserClass.
			processor validationParserClass: self model validationParserClass.
			processor debug: true.
			[ processor processFile: aFilename usingResult: result ]
				ensure: [ processor debug: false ].
			self displayPreviewResult: result.
			self gotoPreviewTab ]
]

{ #category : 'configuration-actions' }
GtSmaCCTransformationToolkit >> preview [
	self openResultFor: self selectedFile
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewElement [
	^ previewElement
		ifNil: [ previewElement := BlElement new
				layout: BlLinearLayout vertical;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				yourself ]
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewFilesElement [
	^ BlElement new
		layout: (BlGridLayout horizontal columnCount: 2);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		aptitude: BrGlamorousWithResizerAptitude;
		addChild: self previewInputSourceElement;
		addChild: self previewOutputSourceElement;
		yourself
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewInputFilename [
	^ previewResult notNil
		ifTrue: [ previewResult filename asFileReference basename ]
		ifFalse: [ 'Input' ]
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewInputSourceElement [
	^ BrTabGroup new
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 5);
		addTab: (BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: self previewInputFilename;
			stencil: [
				| editorElement |
				editorElement := self
					editorFor: previewResult inputSource
					parser: model inputParserClass.
				self
					whenCursorEventsIn: editorElement editor
					do: [ :intervals | 
						self
							updatePreviewAnnotations: (self annotationsInOriginalRanges: intervals) ].
				BlElement new
					constraintsDo: [ :c | 
						c horizontal matchParent.
						c vertical matchParent ];
					addChild: editorElement asScrollableElement as: #inputSource;
					yourself ])
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewOutputFilename [
	^ previewResult notNil
		ifTrue: [ previewResult outputFilename asFileReference basename ]
		ifFalse: [ 'Output' ]
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewOutputSourceElement [
	^ BrTabGroup new
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 5);
		addTab: (BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: self previewOutputFilename;
			stencil: [
				| editorElement |
				editorElement := self
					editorFor: previewResult outputSource
					parser: model validationParserClass.
				self
					whenCursorEventsIn: editorElement editor
					do: [ :intervals | 
						self
							updatePreviewAnnotations: (self annotationsInNewRanges: intervals) ].
				BlElement new
					constraintsDo: [ :c | 
						c horizontal matchParent.
						c vertical matchParent ];
					addChild: editorElement asScrollableElement as: #outputSource;
					yourself ])
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> previewRulesElement [
	| list |
	list := BrColumnedList new.
	list column
		title: 'Rewrite';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: each rewrite displayString ].
	list column
		title: 'Node';
		stencil:
				[ :each | BrColumnCellLabelStencil matchParent: each nodeClass displayString ].
	list column
		title: 'Location';
		stencil:
				[ :each | BrColumnCellLabelStencil matchParent: each nodeInterval displayString ].
	list
		when: BrSelectionChanged
		do: [ :event | 
			event
				selectedDo:
					[ :each | self updateEditorsForAnnotation: (list items at: each first) ] ].
	^ BlElement new
		margin: (BlInsets all: 10);
		padding: (BlInsets all: 5);
		border: (BlBorder paint: Color lightGray width: 1);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		addChild: list as: #previewRewrites;
		yourself
]

{ #category : 'configuration-actions' }
GtSmaCCTransformationToolkit >> previewTab [
	^ windowElement viewModel tabs at: 3
]

{ #category : 'configuration-actions' }
GtSmaCCTransformationToolkit >> promptForFile: aTitle extensions: anArray [
	^ UIManager default
		chooseExistingFileReference: aTitle
		extensions: anArray
		path: FileSystem workingDirectory
		preview: nil
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> selectedFile [
	filesList selectedIndices do: [ :i | ^ filesList items at: i ].
	^ nil
]

{ #category : 'ui' }
GtSmaCCTransformationToolkit >> separatorToolbarItem [
	^ BlElement new
		background: (Color gray alpha: 0.2);
		margin:
			(BlInsets
				top: 5
				left: 5
				bottom: 5
				right: 5);
		constraintsDo: [ :c | 
			c horizontal exact: 1.
			c vertical matchParent ]
]

{ #category : 'ui-transformations' }
GtSmaCCTransformationToolkit >> transformationsElement [
	^ transformationsElement
		ifNil: [ transformationsElement := BlElement new
				layout: BlLinearLayout vertical;
				padding: (BlInsets all: 5);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
				yourself ]
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateCreateSubdirectories [
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> updateEditorsForAnnotation: annotation [
	annotation isNil
		ifTrue: [ ^ self ].
	(self previewElement childNamed: #inputSource)
		ifNotNil: [ :element | 
			element editor text
				clearAttributes: [ :each | each isKindOf: GtSmaCCTransformedAttribute ].
			(element editor text
				from: annotation nodeInterval first
				to: annotation nodeInterval last)
				attributes: {GtSmaCCTransformedAttribute new}.
			element
				scrollToPosition:
					(self
						lineNumberFor: annotation nodeInterval first
						in: previewResult inputSource) ].
	(self previewElement childNamed: #outputSource)
		ifNotNil: [ :element | 
			| firstIndex |
			firstIndex := SmallInteger maxVal.
			element editor text
				clearAttributes: [ :each | each isKindOf: GtSmaCCTransformedAttribute ].
			(previewResult transformedString annotationRangesFor: annotation)
				do: [ :each | 
					firstIndex := firstIndex min: each first.
					(element editor text from: each first to: each last)
						attributes: {GtSmaCCTransformedAttribute new} ].
			firstIndex < SmallInteger maxVal
				ifTrue: [ element
						scrollToPosition:
							(self lineNumberFor: firstIndex in: previewResult outputSource) ] ]
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateFiles [
	filesList notNil
		ifTrue: [ filesList items: model files ]
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateInputParserClass [
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateOutputDirectory [
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> updatePreviewAnnotations: aCollection [
	(self previewElement childNamed: #previewRewrites)
		ifNotNil: [ :element | 
			element
				deselectAll;
				items: aCollection ]
]

{ #category : 'ui-transformations' }
GtSmaCCTransformationToolkit >> updateRewrites [
	| rewritesElement |
	self transformationsElement removeChildren.
	rewritesElement := model rewrites element.
	self transformationsElement
		addChild: rewritesElement asScrollableElement
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateRunOnServer [
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateServer [
]

{ #category : 'private' }
GtSmaCCTransformationToolkit >> updateValidationParserClass [
]

{ #category : 'ui-preview' }
GtSmaCCTransformationToolkit >> whenCursorEventsIn: editor do: aBlock [
	editor
		when: BrTextEditorEvent
		do: [ :event | 
			| intervals |
			intervals := OrderedCollection new.
			editor selection
				do: [ :each | 
					each isNotEmpty
						ifTrue: [ intervals add: (each from + 1 to: each to) ] ].
			intervals isEmpty
				ifTrue: [ editor cursors
						do: [ :each | intervals add: (each position to: each position) ] ].
			aBlock value: intervals ]
]

{ #category : 'ui' }
GtSmaCCTransformationToolkit >> windowElement [
	windowElement := BrTabGroup new.
	windowElement aptitude: BrGlamorousTabGroupAptitude.
	windowElement addTab: (
		BrTab new
			aptitude: BrGlamorousTabAptitude;
			label:  'Configuration';
			stencil: [ self configurationElement ]).

	windowElement addTab: (
		BrTab new
			aptitude: BrGlamorousTabAptitude;
			label:  'Transformations';
			stencil: [ self transformationsElement ]).

	windowElement addTab: (
		BrTab new
			aptitude: BrGlamorousTabAptitude;
			label:  'Preview';
			stencil: [ self previewElement ]).

	^ windowElement
]
