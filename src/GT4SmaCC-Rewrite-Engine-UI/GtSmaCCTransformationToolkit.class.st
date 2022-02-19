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
		'transformationElement',
		'filesFilter',
		'rewriteFilter',
		'results'
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

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> addOverlay [
	| element |
	element := BrVerticalPane new.
	element alignCenter.
	element matchParent.
	element background: (Color gray alpha: 0.5).
	windowElement addChild: element as: #progress
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> addPercentage: anInteger forProcess: aProcess [
	windowElement
		childNamed: #progress
		ifFound:
			[ :overlay | 
			| progress element button |
			element := BrVerticalPane new.
			element padding: (BlInsets all: 10).
			element border: (BlBorder paint: Color black width: 1).
			element background: Color white.
			element alignCenter.
			element fitContent.
			progress := BrProgress new.
			progress aptitude: BrGlamorousProgressWithBarAptitude.
			progress width: 250.
			progress amount: 0 total: anInteger.
			element addChild: progress as: #percent.
			button := BrButton new.
			button margin: (BlInsets top: 10).
			button
				aptitude: BrGlamorousButtonWithLabelAptitude;
				action:
						[ self removeOverlay.
							aProcess terminate ];
				label: 'Cancel'.
			element addChild: button.
			overlay addChild: element ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> addResult: aResult [
	self incrementPercent.
	results addFirst: aResult.
	self updateResults
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> addRewrite: newRewrite [
	| selected |
	selected := self selectedRewrite.
	selected isComposite
		ifTrue: [ selected addTransformation: newRewrite ]
		ifFalse: [ selected parent notNil ifTrue: [ selected parent addTransformation: newRewrite before: selected ] ].
	self updateAndSelectRewrite: newRewrite
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> addRewriteButton [
	^ self class
		dropDown: 'Add'
		icon: BrGlamorousIcons add
		content:
			[ :button | 
			| element |
			element := BrVerticalPane new.
			element
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
								action:
										[ element removeChildren.
											element
												addChild:
													((BrFileSelectOrCreate new)
														size: 500 @ 350;
														folder: self currentConfigurationDirectory;
														fileFilterBlock: [ :file | file extension = 'rw' ];
														okAction:
																[ :file :btn | 
																	| fn |
																	button dispatchEvent: (BrDropdownHideWish new anchor: button).
																	fn := file asFileReference.
																	fn extension = 'rw' ifFalse: [ fn := fn withExtension: 'rw' ].
																	self addRewrite: (model openRewriteFile: fn) ];
														buttonLabel: 'Add File';
														padding: (BlInsets all: 20)) ]);
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

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> applyRewriteFilter: aString [
	rewriteFilter := aString.
	self updateRewrites.
	self displayRewrite: self selectedRewrite
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> asElement [
	| tabGroup |
	windowElement := BlElement new.
	windowElement
		constraintsDo:
			[ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	tabGroup := BrTabGroup new.
	tabGroup aptitude: BrGlamorousTabGroupAptitude.
	tabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude;
				label: 'Configuration';
				stencil: [ self configurationElement ]).
	tabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude;
				label: 'Transformations';
				stencil: [ self transformationsElement ]).
	tabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude;
				label: 'Preview';
				stencil: [ self previewElement ]).
	windowElement
		addShortcut:
			((BlShortcutWithAction new)
				combination:
						((BlKeyCombination builder)
								key: BlKeyboardKey F5;
								build);
				action: [ :anEvent :aShortcut | self preview ]).
	windowElement addChild: tabGroup as: #tabGroup.
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
	element
		addChild:
			((BrLabel new)
				text: 'Output Directory:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self outputDirectoryElement.
	element
		addChild:
			((BrLabel new)
				text: 'Create Subdirectories:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self createSubdirectoriesElement.
	element
		addChild:
			((BrLabel new)
				text: 'Server:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self serverElement.
	element
		addChild:
			((BrLabel new)
				text: 'Run on Server:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self runOnServerElement.
	^ (BrHorizontalPane new)
		id: #dropdown;
		fitContent;
		addChild: element
]

{ #category : #private }
GtSmaCCTransformationToolkit >> connectModel [
	| announcer |
	model addDependent: self.
	announcer := model announcer weak.
	announcer
		when: #files
		send: #updateFiles
		to: self.
	announcer
		when: #rewrites
		send: #updateRewrites
		to: self
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> createSubdirectoriesElement [
	| check |
	check := BrCheckbox new.
	check
		margin: (BlInsets top: 7);
		aptitude: BrGlamorousCheckboxAptitude;
		checked: model createSubdirectories;
		whenCheckedDo: [ model createSubdirectories: true ];
		whenUncheckedDo: [ model createSubdirectories: false ].
	^ check
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> currentConfigurationDirectory [
	^ (filename notNil and: [ filename parent exists ]) ifTrue: [ filename parent ] ifFalse: [ FileLocator workingDirectory ]
]

{ #category : #'preview-actions' }
GtSmaCCTransformationToolkit >> debugRewrite: aSmaCCRewrite forNode: aClass at: anInterval [
	| block |
	aSmaCCRewrite ifNil: [ ^ self ].
	block := [ :rewrite :node | 
	| debug |
	debug := rewrite == aSmaCCRewrite
		and: [ node class == aClass and: [ node startPosition = anInterval first and: [ node stopPosition = anInterval last ] ] ].
	debug ifTrue: [ self removeOverlay ].
	debug ].
	self debugUsingSeachBlock: block andTransformationBlock: block
]

{ #category : #'preview-actions' }
GtSmaCCTransformationToolkit >> debugUsingSeachBlock: searchBlock andTransformationBlock: transformationBlock [
	self
		openResultFor: self selectedFile
		before:
			[ SmaCCRewriteMatch haltBlock: searchBlock.
			SmaCCRewriteTransformation haltBlock: transformationBlock ]
		after:
			[ SmaCCRewriteMatch haltBlock: nil.
			SmaCCRewriteTransformation haltBlock: nil ]
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
		dropDown: 'Delete'
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
	model announcer unsubscribe: self.
	model removeDependent: self
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> displayPreviewResult: aResult [
	previewResult := aResult.
	(self previewElement childNamed: #previewFiles)
		removeChildren;
		addChild: self newPreviewInputSourceElement;
		addChild: self newPreviewOutputSourceElement
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> displayRewrite: aRewrite [
	transformationElement ifNil: [ ^ self ].
	transformationElement removeChildren.
	aRewrite ifNotNil: [ transformationElement addChild: aRewrite asElement ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> editorFor: aString parser: aClass [
	| element |
	element := BrEditor new.
	element
		aptitude: BrGlamorousCodeEditorAptitude;
		padding: (BlInsets all: 5);
		matchParent.
	element editor text: (aString ifNil: [ '' ]) asRopedText.
	aClass notNil ifTrue: [ aClass gtStyler ifNotNil: [ :styler | element editor styler: styler ] ].
	^ element
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> fileToolbarItems [
	^ {self class
			createToolbarButton: 'Preview'
			icon: BrGlamorousVectorIcons playinspect
			action: [ self preview ].
		self class
			dropDown: 'Run'
			icon: BrGlamorousVectorIcons play
			content: [ :button | self runElement: button ].
		self class
			dropDown: 'Add Files from Directory'
			icon: BrGlamorousVectorIcons folder
			content: [ :button | self addFilesDirectoryElement: button ].
		self class
			dropDown: 'Add File'
			icon: BrGlamorousVectorIcons add
			content: [ :button | self addFileElement: button ].
		self class
			dropDown: 'Remove File'
			icon: BrGlamorousVectorIcons remove
			content: [ :button | self removeFileElement: button ]}
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> filesElement [
	| element label filesSection filesLabelLine |
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
		margin: (BlInsets top: 2 right: 5);
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Files'.
	filesLabelLine := (BrHorizontalPane new)
		fitContent;
		addChild: label;
		addChild: (self filterButton: [ :string | self filterFiles: string ]).
	element addChild: filesLabelLine.
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
	filesSection addChild: filesList as: #filesList.
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

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> filterButton: aBlock [
	| currentValue |
	currentValue := ''.
	^ self class
		dropDown: 'Filter'
		icon: BrGlamorousIcons filter
		content:
			[ :button | 
			| editor |
			editor := BrEditor new.
			editor editor text: currentValue asRopedText.
			editor selecter all select.
			editor
				addShortcut:
						((BlShortcutWithAction new)
								combination: BlKeyCombination return;
								action:
										[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
											currentValue := editor editor text asString.
											aBlock value: currentValue ]);
				requestFocus;
				border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
				margin:
						(BlInsets
								top: 2
								left: 4
								bottom: 6
								right: 4);
				width: 250;
				vFitContent.
			(BrVerticalPane new)
				padding: (BlInsets all: 5);
				fitContent;
				addChild:
						((BrLabel new)
								margin: (BlInsets all: 4);
								vFitContent;
								aptitude: BrGlamorousLabelAptitude;
								text: 'Filter:');
				addChild: editor;
				addChild:
						(self class
								createToolbarButton: 'Apply Filter'
								icon: BrGlamorousIcons filter
								action:
									[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
									currentValue := editor editor text asString.
									aBlock value: currentValue ]);
				yourself ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> filterFiles: aString [
	| selectBlock |
	filesList ifNil: [ ^ self ].
	selectBlock := aString isEmpty
		ifTrue: [ [ :each | true ] ]
		ifFalse:
			[ [ :each | 
			(each
				findString: aString
				startingAt: 1
				caseSensitive: false) > 0 ] ].
	filesList items: (model files select: selectBlock).
	(self selectedFile isNil and: [ filesList items notEmpty ]) ifTrue: [ filesList selectOne: 1 ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> filterRewritesButton [
	^ self filterButton: [ :text | self applyRewriteFilter: text ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> gotoPreviewTab [
	self previewTab select
]

{ #category : #'preview-actions' }
GtSmaCCTransformationToolkit >> gotoRewrite: aRewrite [
	windowElement
		childNamed: #tabGroup
		ifFound:
			[ :tabGroup | 
			tabGroup viewModel selectTab: tabGroup tabs second.
			self selectAndScrollToRewrite: aRewrite ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> incrementPercent [
	windowElement
		enqueueTask:
			(BlTaskAction new
				action:
					[ windowElement
						childNamed: #percent
						ifFound: [ :element | element amount: (element amount + 1 min: element total) total: element total ] ])
]

{ #category : #'initialize-release' }
GtSmaCCTransformationToolkit >> initialize [
	super initialize.
	self model: SmaCCTransformationToolkitModel new.
	rewriteFilter := ''.
	results := OrderedCollection new
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

{ #category : #private }
GtSmaCCTransformationToolkit >> loadButton: aString forExtension: extensionString do: aBlock [
	^ self class
		dropDown: aString
		icon: BrGlamorousIcons loadfromdisk
		content:
			[ :button | 
			(BrFileSelector new)
				size: 500 @ 350;
				folder: self currentConfigurationDirectory;
				fileFilterBlock: [ :file | file extension = extensionString ];
				okAction:
						[ :file :btn | 
							button dispatchEvent: (BrDropdownHideWish new anchor: button).
							aBlock value: file asFileReference ];
				buttonLabel: 'Load';
				padding: (BlInsets all: 20) ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> loadConfiguration: aFileReference [
	self model: SmaCCTransformationToolkitModel new.
	self model loadFile: aFileReference.
	results removeAll.
	self updateResults.
	self displayPreviewResult: SmaCCRewriteCompleteResult new
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> loadConfigurationButton [
	^ self
		loadButton: 'Load Configuration'
		forExtension: 'rwc'
		do:
			[ :file | 
			self loadConfiguration: file.
			filename := file ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> loadRewritesButton [
	^ self
		loadButton: 'Load Rewrites'
		forExtension: 'rw'
		do:
			[ :file | 
			model loadRewriteFile: file.
			self updateRewrites ]
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> localFilename: aString [
	| name |
	name := model createSubdirectories
		ifTrue:
			[ | commonParentDir |
			commonParentDir := model commonParentDirectory.
			(commonParentDir notEmpty and: [ commonParentDir last ~= FileSystem disk delimiter ])
				ifTrue: [ commonParentDir := commonParentDir , '/' ].
			aString asFileReference pathString allButFirst: commonParentDir size ]
		ifFalse: [ aString asFileReference basename ].
	^ name
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

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> moveRewriteDown [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent
				ifNotNil:
					[ :parent | 
					| index |
					index := parent rewrites identityIndexOf: rewrite.
					index = parent rewrites size
						ifFalse:
							[ parent removeTransformation: rewrite.
							index < parent rewrites size
								ifTrue: [ parent addTransformation: rewrite before: (parent rewrites at: index + 1) ]
								ifFalse: [ parent addTransformation: rewrite ].
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> moveRewriteInto [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent
				ifNotNil:
					[ :parent | 
					| index newParent |
					index := parent rewrites identityIndexOf: rewrite.
					(index > 1 and: [ (newParent := parent rewrites at: index - 1) isComposite ])
						ifTrue:
							[ parent removeTransformation: rewrite.
							newParent addTransformation: rewrite.
							self updateAndSelectRewrite: rewrite ].
					(index < parent rewrites size and: [ (newParent := parent rewrites at: index + 1) isComposite ])
						ifTrue:
							[ parent removeTransformation: rewrite.
							newParent rewrites isEmpty
								ifTrue: [ newParent addTransformation: rewrite ]
								ifFalse: [ newParent addTransformation: rewrite before: newParent rewrites first ].
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> moveRewriteOut [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent
				ifNotNil:
					[ :parent | 
					parent parent
						ifNotNil:
							[ :grandparent | 
							parent removeTransformation: rewrite.
							grandparent addTransformation: rewrite before: parent.
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> moveRewriteToBottom [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent
				ifNotNil:
					[ :parent | 
					parent rewrites last == rewrite
						ifFalse:
							[ parent removeTransformation: rewrite.
							parent addTransformation: rewrite.
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> moveRewriteToTop [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent
				ifNotNil:
					[ :parent | 
					parent rewrites first == rewrite
						ifFalse:
							[ parent removeTransformation: rewrite.
							parent addTransformation: rewrite before: parent rewrites first.
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> moveRewriteUp [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent
				ifNotNil:
					[ :parent | 
					| index |
					index := parent rewrites identityIndexOf: rewrite.
					index > 1
						ifTrue:
							[ parent removeTransformation: rewrite.
							parent addTransformation: rewrite before: (parent rewrites at: index - 1).
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> newPreviewFilesElement [
	^ (BrHorizontalPane new)
		matchParent;
		addChild: self newPreviewInputSourceElement;
		addChild: self newPreviewOutputSourceElement;
		yourself
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> newPreviewInputSourceElement [
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
GtSmaCCTransformationToolkit >> newPreviewOutputSourceElement [
	| tabGroup |
	previewResult ifNil: [ ^ BlElement new ].
	tabGroup := BrTabGroup new.
	tabGroup
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
										yourself ]).
	previewResult additionalFiles
		keysAndValuesDo:
			[ :key :value | 
			tabGroup
				addTab:
					((BrTab new)
						aptitude: BrGlamorousTabAptitude new;
						label: key asFileReference basename;
						stencil:
								[ | editorElement |
									editorElement := self editorFor: value asString parser: model validationParserClass.
									(BlElement new)
										constraintsDo:
												[ :c | 
													c horizontal matchParent.
													c vertical matchParent ];
										addChild: editorElement asScrollableElement;
										yourself ]) ].
	^ tabGroup
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> newPreviewRulesElement [
	| list |
	list := ((GtPhlowProtoView new columnedList)
		column: 'Rewrite'
			stencil:
				[ :each | 
					(BrHorizontalPane new)
						fitContent;
						addChild:
								((BrButton new)
										aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
										label: each rewrite displayString;
										action: [ self gotoRewrite: each rewrite ]);
						addChild:
								((BrButton new)
										beSmallSize;
										aptitude: BrGlamorousButtonWithIconAptitude;
										label: 'Debug';
										icon: BrGlamorousVectorIcons debug asElement;
										margin: (BlInsets all: 2);
										action:
												[ self
														debugRewrite: each rewrite
														forNode: each nodeClass
														at: each nodeInterval ]) ];
		column: 'Node' text: [ :each | each nodeClass displayString ];
		column: 'Location' text: [ :each | each nodeInterval first printString , '-' , each nodeInterval last printString ])
		asElement.
	list padding: (BlInsets all: 5).
	list border: (BlBorder paint: Color lightGray width: 1).
	list children last
		when: BrSelectionChanged
		do:
			[ :event | self updateEditorsForAnnotation: (event selectedInterval ifNotNil: [ :each | event target items at: each first ]) ].
	^ (BlElement new)
		height: 200;
		aptitude: BrGlamorousWithVerticalResizerAptitude new beTop;
		margin:
				(BlInsets
						top: 0
						left: 10
						bottom: 10
						right: 10);
		constraintsDo: [ :c | c horizontal matchParent ];
		addChild: list as: #previewRewrites;
		yourself
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
	self
		openResultFor: aFilename
		before: [  ]
		after: [  ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> openResultFor: aFilename before: beforeBlock after: afterBlock [
	aFilename ifNil: [ ^ self ].
	self addOverlay.
	[ | result processor |
	result := SmaCCRewriteCompleteResult new.
	processor := SmaCCRewriteProcessor new.
	processor rules: self model rewrites.
	processor parserClass: self model inputParserClass.
	processor validationParserClass: self model validationParserClass.
	processor debug: true.
	beforeBlock value.
	[ [ processor processFile: aFilename usingResult: result ]
		on: Error , Halt
		do:
			[ :ex | 
			self removeOverlay.
			ex pass ] ]
		ensure:
			[ afterBlock value.
			self removeOverlay.
			processor debug: false ].
	windowElement
		enqueueTask:
			(BlTaskAction new
				action:
					[ self displayPreviewResult: result.
					self gotoPreviewTab ]) ] fork
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> outputDirectoryElement [
	| editor button |
	editor := (BrEditor new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		hMatchParent;
		vFitContent;
		aptitude: BrGlamorousRegularEditorAptitude new.
	editor editor text: model outputDirectory asRopedText.
	editor editor when: BrTextEditorModifiedEvent do: [ :event | model outputDirectory: editor editor text asString ].
	button := self class
		createToolbarButton: 'Select Output Directory'
		icon: BrGlamorousVectorIcons folder
		action:
			[ button
				allParentsDetect: [ :each | each id = #dropdown asBlocElementId ]
				ifFound:
					[ :element | 
					element childrenCount < 2
						ifTrue:
							[ element
								addChild:
									((BrFileSelector new)
										size: 400 @ 250;
										folder:
												(model outputDirectory ifNil: [ '.' ] ifNotNil: [ :dir | dir asFileReference exists ifTrue: [ dir ] ifFalse: [ '.' ] ])
														asFileReference;
										fileFilterBlock: [ :file | false ];
										okAction:
												[ :file :btn | 
													element children last removeFromParent.
													model outputDirectory: file asFileReference pathString.
													editor editor text: model outputDirectory asRopedText ];
										buttonLabel: 'Select Directory';
										padding: (BlInsets all: 20)) ]
						ifFalse: [ element children last removeFromParent ] ]
				ifNone: [  ] ].
	^ (BrHorizontalPane new)
		hMatchParent;
		vFitContent;
		addChild: editor;
		addChild: button
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
				addChild: self newPreviewFilesElement as: #previewFiles;
				addChild: self newPreviewRulesElement;
				yourself ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewInputFilename [
	^ (previewResult notNil and: [ previewResult filename notNil ])
		ifTrue: [ previewResult filename asFileReference basename ]
		ifFalse: [ 'Input' ]
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> previewOutputFilename [
	^ (previewResult notNil and: [ previewResult outputFilename notNil ])
		ifTrue: [ previewResult outputFilename asFileReference basename ]
		ifFalse: [ 'Output' ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> previewTab [
	windowElement childNamed: #tabGroup ifFound: [ :tabGroup | ^ tabGroup viewModel tabs at: 3 ].
	^ nil
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> promptForFile: aTitle extensions: anArray [
	^ UIManager default
		chooseExistingFileReference: aTitle
		extensions: anArray
		path: FileSystem workingDirectory
		preview: nil
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> removeFileElement: button [
	| selectedFiles |
	selectedFiles := self selectedFiles.
	selectedFiles isEmpty
		ifTrue:
			[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
			^ BlElement new size: 0 @ 0 ].
	^ (BrVerticalPane new)
		padding: (BlInsets all: 5);
		fitContent;
		addChild:
				((BrLabel new)
						fitContent;
						aptitude: BrGlamorousLabelAptitude new;
						text:
								'Remove ' , selectedFiles first asFileReference basenameWithoutExtension
										,
											(selectedFiles size > 1
												ifTrue:
													[ ' and ' , (selectedFiles size - 1) printString , ' other' , (selectedFiles size > 2 ifTrue: [ 's' ] ifFalse: [ '' ]) ]
												ifFalse: [ '' ]) , '?');
		addChild:
				(self class
						createToolbarButton: 'Delete'
						icon: BrGlamorousIcons remove
						action:
							[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
							self removeFiles ])
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> removeFiles [
	| files |
	files := self selectedFiles asSet.
	model files: (model files reject: [ :each | files includes: each ]).
	self updateFiles
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> removeOverlay [
	windowElement
		enqueueTask:
			(BlTaskAction new
				action:
					[ windowElement
						childNamed: #progress
						ifFound:
							[ :element | 
							element removeChildren.
							element removeFromParent ] ])
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> resultsElement [
	| element label resultsList |
	element := (BrVerticalPane new)
		padding: (BlInsets all: 5);
		matchParent.
	label := (BrLabel new)
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Results:'.
	element addChild: label.
	resultsList := ((GtPhlowProtoView new columnedList)
		column: 'File' text: [ :each | self localFilename: each filename ];
		column: 'Error' text: [ :each | each errorString ifNil: [ '' ] ];
		column: 'Transformation' text: [ :each | each transformation ifNil: [ '' ] ifNotNil: [ :t | t displayString ] ];
		column: 'Location'
			text:
				[ :each | each startLine ifNil: [ '' ] ifNotNil: [ :line | line asString , ':' , (each startColumn ifNil: [ '' ]) asString ] ]
			width: 55) asElement.
	resultsList
		margin: (BlInsets right: 5);
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		constraintsDo:
				[ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
	resultsList children last
		when: BrSelectionChanged
		do:
			[ :event | 
			windowElement
				childNamed: #filesList
				ifFound:
					[ :files | 
					event selectedInterval
						ifNotNil:
							[ :each | 
							| value |
							value := (event target items at: each first) filename.
							(files viewModel itemsProvider preloadUntilFoundSuchThat: [ :fn | fn = value ])
								then:
									[ :index | 
									index > 0
										ifTrue:
											[ files
												enqueueTask:
													(BlTaskAction new
														action:
															[ files selectOne: index.
															files scrollToIndex: index ]) ] ] ] ] ].
	element addChild: resultsList as: #resultsList.
	^ element
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> rewriteToolbarItems [
	^ {self addRewriteButton.
		self deleteRewriteButton.
		self loadRewritesButton.
		self saveRewritesButton}
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> run [
	self runOn: self selectedFiles
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> runAll [
	self runOn: model files
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> runElement: button [
	^ (BrVerticalPane new)
		padding: (BlInsets all: 5);
		fitContent;
		addChild:
				((BrButton new)
						beSmallSize;
						aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
						label: 'Run Selected';
						action:
								[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
									self run ]);
		addChild:
				((BrButton new)
						beSmallSize;
						aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
						label: 'Run All';
						action:
								[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
									self runAll ]);
		yourself
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> runOn: aCollection [
	| process |
	process := [ [ self model runOn: aCollection ] ensure: [ self removeOverlay ] ] newProcess.
	results := results removeAllSuchThat: [ :each | aCollection includes: each filename ].
	self updateResults.
	self addOverlay.
	aCollection size > 1 ifTrue: [ self addPercentage: aCollection size forProcess: process ].
	process resume
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> runOnServerElement [
	| check |
	check := BrCheckbox new.
	check
		margin: (BlInsets top: 7);
		aptitude: BrGlamorousCheckboxAptitude;
		checked: model runOnServer;
		whenCheckedDo: [ model runOnServer: true ];
		whenUncheckedDo: [ model runOnServer: false ].
	^ check
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> satisfiesRewriteFilter: aSmaCCRewrite [
	rewriteFilter = '' ifTrue: [ ^ true ].
	^ (aSmaCCRewrite matches: rewriteFilter)
		or: [ aSmaCCRewrite rewrites anySatisfy: [ :rw | self satisfiesRewriteFilter: rw ] ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> saveButton: aString forExtension: extensionString current: currentValueBlock do: aBlock [
	^ self class
		dropDown: aString
		icon: BrGlamorousIcons savetodisk
		content:
			[ :button | 
			| element fileSelectElement |
			fileSelectElement := (BrFileSelectOrCreate new)
				size: 500 @ 350;
				folder: self currentConfigurationDirectory;
				fileFilterBlock: [ :file | file extension = extensionString ];
				okAction:
						[ :file :btn | 
							| fn |
							button dispatchEvent: (BrDropdownHideWish new anchor: button).
							fn := file asFileReference.
							fn extension = extensionString ifFalse: [ fn := fn withExtension: extensionString ].
							aBlock value: fn ];
				buttonLabel: 'Save';
				padding: (BlInsets all: 20).
			element := BrVerticalPane new.
			element fitContent.
			currentValueBlock value
				ifNil:
					[ element.
					element addChild: fileSelectElement ]
				ifNotNil:
					[ :file | 
					element
						addChild:
								((BrButton new)
										beSmallSize;
										aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
										label: 'Save ' , file basename;
										action:
												[ button dispatchEvent: (BrDropdownHideWish new anchor: button).
													aBlock value: file ]);
						addChild:
								((BrButton new)
										beSmallSize;
										aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
										label: 'Save as';
										action:
												[ element removeChildren.
													element addChild: fileSelectElement ]);
						yourself ].
			element ]
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> saveConfigurationButton [
	^ self
		saveButton: 'Save Configuration'
		forExtension: 'rwc'
		current: [ filename ]
		do: [ :file | self saveConfigurationTo: file ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> saveConfigurationTo: aFileReference [
	self model saveTo: aFileReference.
	filename := aFileReference
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> saveRewritesButton [
	^ self
		saveButton: 'Save Rewrites'
		forExtension: 'rw'
		current: [ model rewrites filename ]
		do:
			[ :file | 
			model rewrites filename: file.
			model saveRewrites.
			self updateRewrites ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> selectAndScrollToRewrite: aRewrite [
	transformationsTree selectAndScrollTo: aRewrite.
	self displayRewrite: aRewrite
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

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> serverElement [
	| editor |
	editor := (BrEditor new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		hMatchParent;
		vFitContent;
		aptitude: BrGlamorousRegularEditorAptitude new.
	editor editor text: model server asRopedText.
	editor editor when: BrTextEditorModifiedEvent do: [ :event | model server: editor editor text asString ].
	^ editor
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
						((BrHorizontalPane new)
								vFitContent;
								hMatchParent;
								addChild:
										((BrLabel new)
												fitContent;
												margin: (BlInsets top: 2 right: 5);
												aptitude: BrGlamorousLabelAptitude new;
												text: 'Rewrites');
								addChild: self filterRewritesButton);
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
	transformationsTree
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										primary;
										key: BlKeyboardKey arrowUp;
										build);
						action: [ self moveRewriteUp ]);
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										primary;
										key: BlKeyboardKey arrowDown;
										build);
						action: [ self moveRewriteDown ]);
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										primary;
										key: BlKeyboardKey arrowLeft;
										build);
						action: [ self moveRewriteOut ]);
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										primary;
										key: BlKeyboardKey arrowRight;
										build);
						action: [ self moveRewriteInto ]);
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										primary;
										shift;
										key: BlKeyboardKey arrowUp;
										build);
						action: [ self moveRewriteToTop ]);
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										primary;
										shift;
										key: BlKeyboardKey arrowDown;
										build);
						action: [ self moveRewriteToBottom ]).
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

{ #category : #updating }
GtSmaCCTransformationToolkit >> update: aSymbol with: aValue [
	super update: aSymbol with: aValue.
	aSymbol = #resultAdded
		ifTrue: [ self addResult: aValue ]
]

{ #category : #'transformation-actions' }
GtSmaCCTransformationToolkit >> updateAndSelectRewrite: rewrite [
	self updateRewrites.
	self selectAndScrollToRewrite: rewrite
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> updateEditorsForAnnotation: annotation [
	self previewElement
		childNamed: #inputSource
		ifFound:
			[ :element | 
			element editor text clearAttributes: [ :each | each isKindOf: GtSmaCCTransformedAttribute ].
			annotation
				ifNotNil:
					[ (element editor text from: annotation nodeInterval first to: annotation nodeInterval last)
						attributes: {GtSmaCCTransformedAttribute new}.
					element scrollToPosition: (self lineNumberFor: annotation nodeInterval first in: previewResult inputSource) ] ].
	self previewElement
		childNamed: #outputSource
		ifFound:
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

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> updatePreviewAnnotations: aCollection [
	self previewElement
		childNamed: #previewRewrites
		ifFound:
			[ :element | 
			(element children last)
				deselectAll;
				items: aCollection ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> updateResults [
	windowElement
		enqueueTask:
			(BlTaskAction new
				action: [ windowElement childNamed: #resultsList ifFound: [ :element | element children last items: results ] ])
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> updateRewrites [
	transformationsTree ifNil: [ ^ self ].
	transformationsTree
		items: {model rewrites}
		lazy: [ :each | each rewrites select: [ :rw | self satisfiesRewriteFilter: rw ] ].
	transformationsTree expandAll.
	self selectedRewrite ifNotNil: [ :value | self displayRewrite: value ]
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
