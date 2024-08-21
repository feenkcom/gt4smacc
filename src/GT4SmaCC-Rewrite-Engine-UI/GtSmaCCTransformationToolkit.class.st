Class {
	#name : #GtSmaCCTransformationToolkit,
	#superclass : #Object,
	#instVars : [
		'model',
		'filename',
		'windowElement',
		'filesList',
		'previewElement',
		'results',
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

{ #category : #ui }
GtSmaCCTransformationToolkit >> asElement [
	| tabGroup |
	windowElement := BlElement new.
	windowElement userData at: #transformationToolkit put: self.
	windowElement
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	tabGroup := BrTabGroup new.
	tabGroup aptitude: BrGlamorousTabGroupAptitude.
	tabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude;
				label: 'Configuration';
				stencil: [ self configurationElement ]).
	tabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude;
				label: 'Transformations';
				stencil: [ self transformationElement ]).
	self previewElement
		ifNotNil: [ :el | 
			tabGroup
				addTab: (BrTab new
						aptitude: BrGlamorousTabAptitude;
						label: 'Preview';
						stencil: [ el ]) ].
	windowElement
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
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

{ #category : #private }
GtSmaCCTransformationToolkit >> disconnectModel [
	model announcer unsubscribe: self.
	model removeDependent: self
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> displayPreviewResult: aResult [
	self previewElement
		ifNil: [ windowElement phlow spawnObject: aResult ]
		ifNotNil: [ self updatePreviewResult: aResult ]
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> displayRewrite: aRewrite [
	self transformationElement displayRewrite: aRewrite
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
	element := BlElement new
			aptitude: BrGlamorousWithVerticalResizerAptitude new beBottom;
			layout: BlLinearLayout vertical;
			padding: (BlInsets all: 5);
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical matchParent ].
	label := BrLabel new
			fitContent;
			margin: (BlInsets top: 2 right: 5);
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Files'.
	filesLabelLine := BrHorizontalPane new
			fitContent;
			addChild: label;
			addChild: (self filterButton: [ :string | self filterFiles: string ]).
	element addChild: filesLabelLine.
	filesSection := BrHorizontalPane new matchParent.
	filesList := BrSimpleList new
			border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
			margin: (BlInsets right: 5);
			matchParent;
			itemStencil: [ BrLabel new
					hMatchParent;
					aptitude: BrGlamorousLabelAptitude new + BrGlamorousListItemAptitude;
					padding: (BlInsets all: 5) ];
			itemDataBinder: [ :lbl :file :i | lbl text: file asFileReference pathString ];
			items: model files.
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

{ #category : #ui }
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
								combination: BlKeyCombination enter;
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

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> gotoPreviewTab [
	self previewTab ifNotNil: [ :tab | tab select ]
]

{ #category : #'preview-actions' }
GtSmaCCTransformationToolkit >> gotoRewrite: aRewrite [
	windowElement
		childNamed: #tabGroup
		ifFound: [ :tabGroup | 
			tabGroup viewModel selectTab: tabGroup tabs second.
			self transformationElement selectAndScrollToRewrite: aRewrite ]
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
	results := OrderedCollection new.
	self model: SmaCCTransformationToolkitModel new
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> inputParserElement [
	^ (GtSmaCCDropDownList new)
		selectedItem: model inputParserClass;
		items: (SmaCCParser allSubclasses asSortedCollection: [ :a :b | a name < b name ]);
		when: BrSelectionChanged do: [ :event | model inputParserClass: event target selectedItem ]
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
	self updateModel
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
	model notNil ifTrue: [ self disconnectModel ].
	model := aSmaCCTransformationToolkitModel.
	model notNil
		ifTrue: [ self connectModel.
			self updateModel ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> open [
	| space |
	space := BlSpace new.
	space withHalos.
	space title: 'SmaCC Transformation Toolkit'.
	space extent: 1200 @ 800.
	previewElement := GtSmaCCPreviewElement new.
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
	[ | result |
	result := self model
			previewResultFor: aFilename
			before: beforeBlock
			after: [ afterBlock value.
				self removeOverlay ]
			onException: [ self removeOverlay ].
	windowElement
		enqueueTask: [ self displayPreviewResult: result.
			self gotoPreviewTab ] asBlTask ] fork
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
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> previewTab [
	^ windowElement
		childNamed: #tabGroup
		ifFound: [ :tabGroup | tabGroup viewModel tabs at: 3 ifAbsent: [ nil ] ]
		ifNone: [ nil ]
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
	element := BrVerticalPane new
			padding: (BlInsets all: 5);
			matchParent.
	label := BrLabel new
			fitContent;
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Results:'.
	element addChild: label.
	resultsList := (GtPhlowProtoView new columnedList
			column: 'File' text: [ :each | self localFilename: each filename ];
			column: 'Error' text: [ :each | each errorString ifNil: [ '' ] ];
			column: 'Transformation'
				text: [ :each | each transformation ifNil: [ '' ] ifNotNil: [ :t | t displayString ] ];
			column: 'Location'
				text: [ :each | 
					each startLine
						ifNil: [ '' ]
						ifNotNil: [ :line | line asString , ':' , (each startColumn ifNil: [ '' ]) asString ] ]
				width: 55) asElement.
	resultsList
		margin: (BlInsets right: 5);
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	resultsList children last
		when: BrSelectionChanged
		do: [ :event | 
			windowElement
				childNamed: #filesList
				ifFound: [ :files | 
					event selectedInterval
						ifNotNil: [ :each | 
							| value |
							value := (event target items at: each first) filename.
							(files viewModel itemsProvider
								preloadUntilFoundSuchThat: [ :fn | fn = value ])
								then: [ :index | 
									index > 0
										ifTrue: [ files
												enqueueTask: (BlTaskAction new
														action: [ files selectOne: index.
															files scrollToIndex: index ]) ] ] ] ] ].
	element addChild: resultsList as: #resultsList.
	^ element
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

{ #category : #private }
GtSmaCCTransformationToolkit >> saveButton: aString forExtension: extensionString current: currentValueBlock do: aBlock [
	^ self class
		dropDown: aString
		icon: BrGlamorousIcons savetodisk
		content: [ :button | 
			| element fileSelectElement |
			fileSelectElement := BrFileSelectOrCreate new
					size: 500 @ 350;
					folder: self currentConfigurationDirectory;
					fileFilterBlock: [ :file | file extension = extensionString ];
					okAction: [ :file :btn | 
						| fn |
						button dispatchEvent: (BrDropdownHideWish new anchor: button).
						fn := file asFileReference.
						fn extension = extensionString
							ifFalse: [ fn := fn withExtension: extensionString ].
						aBlock value: fn ];
					buttonLabel: 'Save';
					padding: (BlInsets all: 20).
			element := BrVerticalPane new.
			element fitContent.
			currentValueBlock value
				ifNil: [ element.
					element addChild: fileSelectElement ]
				ifNotNil: [ :file | 
					element
						addChild: (BrButton new
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: 'Save ' , file basename;
								action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
									aBlock value: file ]);
						addChild: (BrButton new
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: 'Save as';
								action: [ element removeChildren.
									element addChild: fileSelectElement ]) ].
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

{ #category : #private }
GtSmaCCTransformationToolkit >> selectedFile [
	filesList selectedIndices do: [ :i | ^ filesList items at: i ifAbsent: [  ] ].
	^ nil
]

{ #category : #private }
GtSmaCCTransformationToolkit >> selectedFiles [
	^ (filesList selectedIndices collect: [ :i | filesList items at: i ifAbsent: [  ] ]) reject: [ :each | each isNil ]
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
GtSmaCCTransformationToolkit >> transformationElement [
	^ transformationElement
		ifNil: [ transformationElement := GtSmaCCTransformationElement new.
			transformationElement rewrites: model rewrites.
			transformationElement weak
				when: GtSmaCCRewritesLoaded
				send: #updateRewritesFile:
				to: self.
			transformationElement ]
]

{ #category : #updating }
GtSmaCCTransformationToolkit >> update: aSymbol with: aValue [
	super update: aSymbol with: aValue.
	aSymbol = #resultAdded
		ifTrue: [ self addResult: aValue ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateFiles [
	filesList notNil
		ifTrue: [ filesList items: model files ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> updateModel [
	self updateFiles.
	results removeAll.
	self updateResults.
	self updatePreviewResult: (SmaCCRewriteCompleteResult model: self model)
]

{ #category : #'ui-preview' }
GtSmaCCTransformationToolkit >> updatePreviewResult: aResult [
	self previewElement ifNotNil: [ :element | element previewResult: aResult ]
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> updateResults [
	windowElement ifNil: [ ^ self ].
	windowElement
		enqueueTask: (BlTaskAction new
				action: [ windowElement
						childNamed: #resultsList
						ifFound: [ :element | element children last items: results ] ])
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationToolkit >> updateRewrites [
	self transformationElement rewrites: self model rewrites
]

{ #category : #'ui-transformations' }
GtSmaCCTransformationToolkit >> updateRewritesFile: aGtSmaCCRewritesLoaded [
	model rewrites == aGtSmaCCRewritesLoaded rewrites ifTrue: [ ^ self ].
	model rewrites: aGtSmaCCRewritesLoaded rewrites
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> validationParserElement [
	^ (GtSmaCCDropDownList new)
		selectedItem: model validationParserClass;
		items: (SmaCCParser allSubclasses asSortedCollection: [ :a :b | a name < b name ]);
		when: BrSelectionChanged do: [ :event | model validationParserClass: event target selectedItem ]
]
