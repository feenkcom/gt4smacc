Class {
	#name : #GtSmaCCTransformationToolkit,
	#superclass : #Object,
	#instVars : [
		'model',
		'filename',
		'windowElement',
		'filesList',
		'previewElement',
		'previewResult',
		'transformationsTree',
		'transformationElement'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #ui }
GtSmaCCTransformationToolkit class >> createToolbarButton: aString icon: anIcon action: aBlock [
	^ BrButton new
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: aString;
		icon: anIcon asElement;
		margin: (BlInsets all: 2);
		action: aBlock
]

{ #category : #ui }
GtSmaCCTransformationToolkit class >> dropDown: aString icon: anIcon content: aBlock [
	| button |
	button := BrButton new.
	button icon: anIcon.
	button aptitude: BrGlamorousButtonWithIconAptitude.
	button label: aString.
	button beSmallSize.
	button margin: (BlInsets all: 2).
	button
		addAptitude:
			(BrGlamorousWithDropdownAptitude
				handle:
					[ (BrButton new)
						beSmallSize;
						icon: anIcon;
						label: aString;
						aptitude:
								BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude - BrGlamorousButtonExteriorAptitude ]
				content: [ aBlock cull: button ]).
	^ button
]

{ #category : #'world menu' }
GtSmaCCTransformationToolkit class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'SmaCC Transformation Toolkit (GT)')
		parent: #Tools;
		order: 490.31;
		action: [ self open ].
	aBuilder withSeparatorAfter
]

{ #category : #opening }
GtSmaCCTransformationToolkit class >> open [
	^ self new open
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> addDirectory: aFile [
	| names match stream todo dir |
	names := Set new.
	stream := WriteStream on: String new.
	(self model inputParserClass ifNil: [ SmaCCParser ]) fileExtensions
		do:
			[ :each | 
			stream
				nextPut: $*;
				nextPutAll: each ]
		separatedBy: [ stream nextPut: $; ].
	match := stream contents.
	match isEmpty ifTrue: [ match := '*' ].
	todo := OrderedCollection with: aFile.
	[ todo notEmpty ]
		whileTrue:
			[ ((dir := todo removeFirst) filesMatching: match) do: [ :each | names add: each fullName ].
			todo addAll: dir directories ].
	self addFiles: names
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> addFileElement: button [
	| extensions |
	extensions := (self model inputParserClass ifNil: [ SmaCCParser ]) fileExtensions ifEmpty: [ '' ].
	^ (BrFileSelector new)
		size: 500 @ 350;
		folder: self currentConfigurationDirectory;
		fileFilterBlock: [ :file | extensions anySatisfy: [ :each | '*' , each match: file basename ] ];
		okAction:
				[ :file :btn | 
					button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self addFiles: {file pathString} ];
		buttonLabel: 'Add';
		padding: (BlInsets all: 20)
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> addFiles: aCollection [
	| files |
	files := Set withAll: self model files.
	files addAll: aCollection.
	self model files: files asSortedCollection asArray
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> addFilesDirectoryElement: button [
	^ (BrFileSelector new)
		size: 500 @ 350;
		folder: self currentConfigurationDirectory;
		fileFilterBlock: [ :file | false ];
		okAction:
				[ :file :btn | 
					button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self addDirectory: file ];
		buttonLabel: 'Add all files';
		padding: (BlInsets all: 20)
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> addRewrite: newRewrite [
	| selected |
	selected := self selectedRewrite.
	selected isComposite
		ifTrue: [ selected addTransformation: newRewrite ]
		ifFalse: [ selected parent notNil ifTrue: [ selected parent addTransformation: newRewrite before: selected ] ].
	self updateRewrites.
	transformationsTree selectAndScrollTo: newRewrite.
	self displayRewrite: newRewrite
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> addRewriteButton [
	^ self class
		dropDown: 'Add'
		icon: BrGlamorousIcons add
		content:
			[ :button | 
			(BrVerticalPane new)
				padding: (BlInsets all: 5);
				fitContent;
				addChild:
						((BrButton new)
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: 'Rewrite';
								action:
										[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
											self addRewrite: SmaCCRewrite newInstance ]);
				addChild:
						((BrButton new)
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: 'Method';
								action:
										[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
											self addRewrite: SmaCCRewriteMethodDefinition new ]);
				addChild:
						((BrButton new)
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: 'Properties';
								action:
										[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
											self addRewrite: SmaCCRewritePropertyDefinition new ]);
				addChild:
						((BrButton new)
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: 'File';
								action: [  ]);
				yourself ]
]

{ #category : #'ui-preview' }
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

{ #category : #'ui-preview' }
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

{ #category : #ui }
GtSmaCCTransformationToolkit >> asElement [
	windowElement := BrTabGroup new.
	windowElement aptitude: BrGlamorousTabGroupAptitude.
	windowElement
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude;
				label: 'Configuration';
				stencil: [ self configurationElement ]).
	windowElement
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude;
				label: 'Transformations';
				stencil: [ self transformationsElement ]).
	windowElement
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude;
				label: 'Preview';
				stencil: [ self previewElement ]).
	^ windowElement
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationElement [
	^ (BlElement new)
		layout: BlLinearLayout vertical;
		constraintsDo:
				[ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
		padding: (BlInsets all: 5);
		addChild: self configurationToolbar;
		addChild: self filesElement;
		addChild: self resultsElement;
		yourself
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationToolbar [
	^ (BrToolbar new)
		aptitude: BrGlamorousToolbarAptitude new;
		hMatchParent;
		addItems: self configurationToolbarItems
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationToolbarItems [
	^ {self loadConfigurationButton.
		self saveConfigurationButton.
		self configureButton}
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configureButton [
	^ self class
		dropDown: 'Configure'
		icon: BrGlamorousIcons hamburger
		content: [ :button | self configureElement ]
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configureElement [
	| element |
	element := BlElement new.
	element layout: (BlGridLayout new columnCount: 2).
	element padding: (BlInsets all: 5).
	element
		constraintsDo:
			[ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		addChild:
			((BrLabel new)
				text: 'Input Parser:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self inputParserElement.
	element
		addChild:
			((BrLabel new)
				text: 'Validation Parser:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self validationParserElement.
	^ element
]

{ #category : #private }
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

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> currentConfigurationDirectory [
	^ (filename notNil and: [ filename parent exists ]) ifTrue: [ filename parent ] ifFalse: [ FileLocator workingDirectory ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> deleteRewrite [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent notNil
				ifTrue:
					[ rewrite parent removeTransformation: rewrite.
					self updateRewrites.
					self displayRewrite: self selectedRewrite ] ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> deleteRewriteButton [
	^ self class
		dropDown: 'remove'
		icon: BrGlamorousIcons remove
		content:
			[ :button | 
			| rewrite |
			rewrite := self selectedRewrite.
			(rewrite isNil or: [ rewrite parent isNil ])
				ifTrue:
					[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
					BlElement new size: 0 @ 0 ]
				ifFalse:
					[ (BrVerticalPane new)
						padding: (BlInsets all: 5);
						fitContent;
						addChild:
								((BrLabel new)
										fitContent;
										aptitude: BrGlamorousLabelAptitude new;
										text: 'Delete ' , rewrite displayString , '?');
						addChild:
								(self class
										createToolbarButton: 'Delete'
										icon: BrGlamorousIcons remove
										action:
											[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
											self deleteRewrite ]) ] ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> disconnectModel [
	model announcer unsubscribe: self
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> displayPreviewResult: aResult [
	previewResult := aResult.
	(self previewElement childNamed: #previewFiles)
		removeChildren;
		addChild: self previewInputSourceElement;
		addChild: self previewOutputSourceElement
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> displayRewrite: aRewrite [
	transformationElement ifNil: [ ^ self ].
	transformationElement removeChildren.
	aRewrite ifNotNil: [ transformationElement addChild: aRewrite asElement ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> editorFor: aString parser: aClass [
	| editor element |
	editor := BrTextEditor new.
	editor text: aString asRopedText.
	element := BrEditorElement new.
	element
		editor: editor;
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	aClass notNil
		ifTrue:
			[ aClass gtStyler ifNotNil: [ :styler | editor styler: styler ] ].
	^ element
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> fileToolbarItems [
	^ {self class
			createToolbarButton: 'Preview'
			icon: BrGlamorousVectorIcons playinspect
			action: [ self preview ].
		self class
			createToolbarButton: 'Run'
			icon: BrGlamorousVectorIcons play
			action: [ self run ].
		self class
			dropDown: 'Add Files from Directory'
			icon: BrGlamorousVectorIcons folder
			content: [ :button | self addFilesDirectoryElement: button ].
		self class
			dropDown: 'Add File'
			icon: BrGlamorousVectorIcons add
			content: [ :button | self addFileElement: button ].
		self class
			createToolbarButton: 'Remove File'
			icon: BrGlamorousVectorIcons remove
			action: [ self removeFiles ]}
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> filesElement [
	| element label filesSection |
	element := (BlElement new)
		aptitude: BrGlamorousWithVerticalResizerAptitude new beBottom;
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 5);
		constraintsDo:
				[ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
	label := (BrLabel new)
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Files'.
	element addChild: label.
	filesSection := BrHorizontalPane new matchParent.
	filesList := (BrSimpleList new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		margin: (BlInsets right: 5);
		matchParent;
		itemStencil:
				[ (BrLabel new)
						hMatchParent;
						aptitude: BrGlamorousLabelAptitude new + BrGlamorousListItemAptitude;
						padding: (BlInsets all: 5) ];
		itemDataBinder: [ :lbl :file :i | lbl text: file asFileReference pathString ].
	filesSection addChild: filesList.
	filesSection addChild: self filesToolbar.
	element addChild: filesSection.
	^ element
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> filesToolbar [
	^ (BrToolbar new)
		aptitude: BrGlamorousToolbarAptitude new;
		vMatchParent;
		layout: BlLinearLayout vertical;
		addItems: self fileToolbarItems
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> gotoPreviewTab [
	self previewTab select
]

{ #category : #'initialize-release' }
GtSmaCCTransformationToolkit >> initialize [
	super initialize.
	self model: SmaCCTransformationToolkitModel new
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> inputParserElement [
	^ (GtSmaCCDropDownList new)
		selectedItem: model inputParserClass;
		items: (SmaCCParser allSubclasses asSortedCollection: [ :a :b | a name < b name ]);
		when: BrSelectionChanged do: [ :event | model inputParserClass: event target selectedItem ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> lineNumberFor: anInteger in: aString [
	| stream |
	stream := SmaCCLineNumberStream on: aString readStream.
	stream position: anInteger.
	^ stream lineNumber
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> loadConfiguration: aFileReference [
	self model: (SmaCCTransformationToolkitModel new loadFile: aFileReference).
"	self fileResults removeAll.
	self result: SmaCCRewriteCompleteResult new"
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> loadConfigurationButton [
	^ self class
		dropDown: 'Load Configuration'
		icon: BrGlamorousIcons loadfromdisk
		content:
			[ :button | 
			(BrFileSelector new)
				size: 500 @ 350;
				folder: self currentConfigurationDirectory;
				fileFilterBlock: [ :file | file extension = 'rwc' ];
				okAction:
						[ :file :btn | 
							button dispatchEvent: (BrDropdownHideWish new anchor: button).
							self loadConfiguration: file asFileReference.
							filename := file asFileReference ];
				buttonLabel: 'Load';
				padding: (BlInsets all: 20) ]
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> model: aSmaCCTransformationToolkitModel [
	model notNil
		ifTrue: [ self disconnectModel ].
	model := aSmaCCTransformationToolkitModel.
	model notNil
		ifTrue: [ self connectModel ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> open [
	| space |
	space := BlSpace new.
	space withHalos.
	space title: 'SmaCC Transformation Toolkit'.
	space extent: 1200 @ 800.
	space root addChild: self asElement.
	space show
]

{ #category : #'configuration-actions' }
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

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> preview [
	self openResultFor: self selectedFile
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewElement [
	^ previewElement
		ifNil:
			[ previewElement := (BrVerticalPane new)
				matchParent;
				addChild: self previewFilesElement as: #previewFiles;
				addChild: self previewRulesElement;
				yourself ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewFilesElement [
	^ (BrHorizontalPane new)
		matchParent;
		addChild: self previewInputSourceElement;
		addChild: self previewOutputSourceElement;
		yourself
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewInputFilename [
	^ previewResult notNil
		ifTrue: [ previewResult filename asFileReference basename ]
		ifFalse: [ 'Input' ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewInputSourceElement [
	previewResult ifNil: [ ^ BlElement new ].
	^ (BrTabGroup new)
		aptitude: BrGlamorousWithHorizontalResizerAptitude new beRight + BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 5);
		addTab:
				((BrTab new)
						aptitude: BrGlamorousTabAptitude new;
						label: self previewInputFilename;
						stencil:
								[ | editorElement |
									editorElement := self editorFor: previewResult inputSource parser: model inputParserClass.
									self
										whenCursorEventsIn: editorElement editor
										do: [ :intervals | self updatePreviewAnnotations: (self annotationsInOriginalRanges: intervals) ].
									(BlElement new)
										constraintsDo:
												[ :c | 
													c horizontal matchParent.
													c vertical matchParent ];
										addChild: editorElement asScrollableElement as: #inputSource;
										yourself ])
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewOutputFilename [
	^ previewResult notNil
		ifTrue: [ previewResult outputFilename asFileReference basename ]
		ifFalse: [ 'Output' ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewOutputSourceElement [
	previewResult ifNil: [ ^ BlElement new ].
	^ (BrTabGroup new)
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 5);
		addTab:
				((BrTab new)
						aptitude: BrGlamorousTabAptitude new;
						label: self previewOutputFilename;
						stencil:
								[ | editorElement |
									editorElement := self editorFor: previewResult outputSource parser: model validationParserClass.
									self
										whenCursorEventsIn: editorElement editor
										do: [ :intervals | self updatePreviewAnnotations: (self annotationsInNewRanges: intervals) ].
									(BlElement new)
										constraintsDo:
												[ :c | 
													c horizontal matchParent.
													c vertical matchParent ];
										addChild: editorElement asScrollableElement as: #outputSource;
										yourself ])
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewRulesElement [
	| list |
	list := BrColumnedList new.
	list rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new.
	(list column)
		title: 'Rewrite';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: each rewrite displayString ].
	(list column)
		title: 'Node';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: each nodeClass displayString ].
	(list column)
		title: 'Location';
		stencil:
				[ :each | BrColumnCellLabelStencil matchParent: each nodeInterval first printString , '-' , each nodeInterval last printString ].
	list
		when: BrSelectionChanged
		do: [ :event | self updateEditorsForAnnotation: (event selectedInterval ifNotNil: [ :each | list items at: each first ]) ].
	^ (BlElement new)
		height: 200;
		aptitude: BrGlamorousWithVerticalResizerAptitude new beTop;
		margin: (BlInsets all: 10);
		padding: (BlInsets all: 5);
		border: (BlBorder paint: Color lightGray width: 1);
		constraintsDo: [ :c | c horizontal matchParent ];
		addChild: list as: #previewRewrites;
		yourself
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> previewTab [
	^ windowElement viewModel tabs at: 3
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> promptForFile: aTitle extensions: anArray [
	^ UIManager default
		chooseExistingFileReference: aTitle
		extensions: anArray
		path: FileSystem workingDirectory
		preview: nil
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> removeFiles [
	| files |
	files := self selectedFiles asSet.
	model files: (model files reject: [ :each | files includes: each ]).
	self updateFiles
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> resultsElement [
	| element label resultsList |
	element := (BlElement new)
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 5);
		constraintsDo:
				[ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
	label := (BrLabel new)
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Results'.
	element addChild: label.
	resultsList := (BrColumnedList new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		margin: (BlInsets right: 5);
		matchParent;
		rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new.
	(resultsList column)
		title: 'File';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: each filename ].
	(resultsList column)
		title: 'Error';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: (each errorString ifNil: [ '' ]) ].
	(resultsList column)
		title: 'Transformation';
		stencil:
				[ :each | BrColumnCellLabelStencil matchParent: (each transformation ifNil: [ '' ] ifNotNil: [ :t | t displayString ]) ].
	(resultsList column)
		title: 'Line';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: (each startLine ifNil: [ '' ]) ].
	(resultsList column)
		title: 'Column';
		stencil: [ :each | BrColumnCellLabelStencil matchParent: (each startColumn ifNil: [ '' ]) ].
	element addChild: resultsList.
	^ element
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> rewriteToolbarItems [
	^ {self addRewriteButton.
		self deleteRewriteButton}
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> run [
	self model runOn: self selectedFiles
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> saveConfigurationButton [
	^ self class
		dropDown: 'Save Configuration'
		icon: BrGlamorousIcons savetodisk
		content: [ :button | self saveConfigurationDropDownElementFrom: button ]
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> saveConfigurationDropDownElementFrom: button [
	| element |
	element := BlElement new.
	element size: 500 @ 350.
	element
		addChild:
			((BrFileSelectOrCreate new)
				folder: self currentConfigurationDirectory;
				fileFilterBlock: [ :file | file extension = 'rwc' ];
				okAction:
						[ :file :btn | 
							button dispatchEvent: (BrDropdownHideWish new anchor: button).
							self saveConfigurationTo: file asFileReference ];
				buttonLabel: 'Save';
				padding: (BlInsets all: 20)).
	^ element
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> saveConfigurationTo: aFileReference [
	| file |
	file := aFileReference extension = 'rwc' ifTrue: [ aFileReference ] ifFalse: [ aFileReference withExtension: 'rwc' ].
	self model saveTo: file.
	filename := file
]

{ #category : #private }
GtSmaCCTransformationToolkit >> selectedFile [
	filesList selectedIndices do: [ :i | ^ filesList items at: i ifAbsent: [  ] ].
	^ nil
]

{ #category : #private }
GtSmaCCTransformationToolkit >> selectedFiles [
	^ (filesList selectedIndices collect: [ :i | filesList items at: i ifAbsent: [  ] ]) reject: [ :each | each isNil ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> selectedRewrite [
	transformationsTree selectedNodeDo: [ :node | node value ifNotNil: [ :value | ^ value ] ].
	^ model rewrites
]

{ #category : #ui }
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

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> transformationsElement [
	| element leftElement toolbar |
	element := BrHorizontalPane new.
	element matchParent.
	leftElement := (BrVerticalPane new)
		width: 250;
		vMatchParent;
		margin: (BlInsets all: 5);
		padding: (BlInsets all: 5);
		aptitude: BrGlamorousWithHorizontalResizerAptitude new beRight.
	toolbar := (BrToolbar new)
		aptitude: BrGlamorousToolbarAptitude new;
		fitContent;
		addItems: self rewriteToolbarItems.
	leftElement
		addChild:
			((BrHorizontalPane new)
				vFitContent;
				hMatchParent;
				addChild:
						((BrLabel new)
								vFitContent;
								hMatchParent;
								aptitude: BrGlamorousLabelAptitude new;
								text: 'Rewrites:');
				addChild: toolbar).
	transformationsTree := BrSimpleTree new.
	transformationsTree
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new;
		nodeStencil:
				[ (BrLabel new)
						aptitude: BrGlamorousLabelAptitude;
						vFitContent;
						hMatchParent ];
		nodeDataBinder: [ :label :rewrite | label text: rewrite displayString ];
		when: BrSelectionChanged do: [ :event | self selectedRewrite ifNotNil: [ :value | self displayRewrite: value ] ].
	leftElement addChild: transformationsTree.
	element addChild: leftElement.
	transformationElement := BlElement new.
	transformationElement
		constraintsDo:
				[ :c | 
					c horizontal matchParent.
					c vertical matchParent ];
		margin: (BlInsets all: 5).
	element addChild: transformationElement.
	self updateRewrites.
	^ element
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateCreateSubdirectories [
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> updateEditorsForAnnotation: annotation [
	(self previewElement childNamed: #inputSource)
		ifNotNil:
			[ :element | 
			element editor text clearAttributes: [ :each | each isKindOf: GtSmaCCTransformedAttribute ].
			annotation
				ifNotNil:
					[ (element editor text from: annotation nodeInterval first to: annotation nodeInterval last)
						attributes: {GtSmaCCTransformedAttribute new}.
					element scrollToPosition: (self lineNumberFor: annotation nodeInterval first in: previewResult inputSource) ] ].
	(self previewElement childNamed: #outputSource)
		ifNotNil:
			[ :element | 
			element editor text clearAttributes: [ :each | each isKindOf: GtSmaCCTransformedAttribute ].
			annotation
				ifNotNil:
					[ | firstIndex |
					firstIndex := SmallInteger maxVal.
					(previewResult transformedString annotationRangesFor: annotation)
						do:
							[ :each | 
							firstIndex := firstIndex min: each first.
							(element editor text from: each first to: each last) attributes: {GtSmaCCTransformedAttribute new} ].
					firstIndex < SmallInteger maxVal
						ifTrue: [ element scrollToPosition: (self lineNumberFor: firstIndex in: previewResult outputSource) ] ] ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateFiles [
	filesList notNil
		ifTrue: [ filesList items: model files ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateInputParserClass [
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateOutputDirectory [
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> updatePreviewAnnotations: aCollection [
	(self previewElement childNamed: #previewRewrites)
		ifNotNil:
			[ :element | 
			element
				deselectAll;
				items: aCollection ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> updateRewrites [
	transformationsTree ifNil: [ ^ self ].
	transformationsTree items: {model rewrites} lazy: [ :each | each rewrites ].
	transformationsTree expandAll
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateRunOnServer [
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateServer [
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateValidationParserClass [
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> validationParserElement [
	^ (GtSmaCCDropDownList new)
		selectedItem: model validationParserClass;
		items: (SmaCCParser allSubclasses asSortedCollection: [ :a :b | a name < b name ]);
		when: BrSelectionChanged do: [ :event | model validationParserClass: event target selectedItem ]
]

{ #category : #'ui-preview' }
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
