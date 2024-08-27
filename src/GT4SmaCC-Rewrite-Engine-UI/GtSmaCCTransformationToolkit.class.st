Class {
	#name : #GtSmaCCTransformationToolkit,
	#superclass : #BrVerticalPane,
	#instVars : [
		'model',
		'results'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #actions }
GtSmaCCTransformationToolkit >> addDirectory: aFile [
	| names match stream todo dir |
	names := Set new.
	stream := WriteStream on: String new.
	(self model inputParserClass ifNil: [ SmaCCParser ]) fileExtensions
		do: [ :each | 
			stream
				nextPut: $*;
				nextPutAll: each ]
		separatedBy: [ stream nextPut: $; ].
	match := stream contents.
	match isEmpty ifTrue: [ match := '*' ].
	todo := OrderedCollection with: aFile.
	[ todo notEmpty ]
		whileTrue: [ ((dir := todo removeFirst) filesMatching: match)
				do: [ :each | names add: each pathString ].
			todo addAll: dir directories ].
	self addFiles: names
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> addEditor [
	| expander |
	expander := BrExpander new
			hMatchParent;
			vFitContent;
			margin: (BlInsets all: 5);
			aptitude: (GtCoderExpanderAptitude new padding: BlInsets empty).
	expander
		header: [ (model
				asGtMagritteViewModelWithDescription: model inputParserClassDescription beReadOnly
						, model rewriteFilenameDescription beReadOnly) asElement
				hMatchParent;
				padding: (BlInsets all: 5);
				yourself ];
		content: [ model asGtMagritteViewModel asElement
				hMatchParent;
				padding: (BlInsets all: 5);
				yourself ].
	expander
		when: BlClickEvent
		do: [ :anEvent | 
			expander isCollapsed
				ifTrue: [ anEvent consumed: true.
					expander expand ] ].
	self addChild: expander as: #editor
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> addFiles: aCollection [
	| files isFileReference |
	isFileReference := self model files isEmpty
			or: [ self model files first isString not ].
	files := Set withAll: self model files.
	files
		addAll: (isFileReference
				ifTrue: [ aCollection collect: #asFileReference ]
				ifFalse: [ aCollection ]).
	self model files: files asSortedCollection asArray
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> addResult: aValue [
	results at: aValue filename put: aValue.
	self userData
		at: #transformationJob
		ifPresent: [ :job | job currentValue: job currentValue + 1 ]
		ifAbsent: [  ].
	self updateFiles
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> addTabs [
	| views |
	self
		childNamed: #tabGroup
		ifFound: [ :each | each removeFromParent ]
		ifNone: [  ].
	views := GtPhlowViewsCollector new
			fromObject: self;
			pragmaName: #gtTransformationViews;
			collect.

	self
		addChild: (GtPhlowCompositeView new
				views: views;
				asElementDo: [ :aTabGroup | 
					aTabGroup
						matchParent;
						padding: (BlInsets all: 5) ])
		as: #tabGroup
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> buildUI [
	self
		childNamed: #files
		ifFound: [ :each | each removeFromParent ]
		ifNone: [  ].
	self
		childNamed: #editor
		ifFound: [ :each | each removeFromParent ]
		ifNone: [  ].
	self updateFilename.
	self addEditor.
	self addTabs
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> connectToModel [
	results := Dictionary new.
	model addDependent: self.
	model announcer weak
		when: #files
			send: #updateFiles
			to: self;
		when: #filename
			send: #updateFilename
			to: self
]

{ #category : #private }
GtSmaCCTransformationToolkit >> executeResultFor: aFilename [
	^ self
		executeResultFor: aFilename
		before: [  ]
		after: [  ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> executeResultFor: aFilename before: beforeBlock after: afterBlock [
	aFilename ifNil: [ ^ nil ].
	^ self model
		previewResultFor: aFilename
		before: beforeBlock
		after: afterBlock
		onException: [  ]
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> files [
	^ (model files collect: #asFileReference)
		asSortedCollection: [ :a :b | a pathString < b pathString ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> filesElementDo: aBlock [
	self
		enqueueTask: (BlTaskAction new
				action: [ self
						childNamed: #tabGroup
						ifFound: [ :group | 
							group tabs
								detect: [ :each | each tabLabel text asString = 'Files' ]
								ifFound: [ :each | 
									each contentElement
										ifNotNil: [ :el | 
											el
												childWithId: GtPhlowColumnedListId
												ifFound: aBlock
												ifNone: [  ] ] ]
								ifNone: [  ] ] ])
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> filesView: aView [
	<gtTransformationViews>
	^ aView columnedList
		title: 'Files';
		priority: 10;
		withMultipleSelection;
		items: [ self files ];
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Preview'
			action: [ self preview ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Transform'
			action: [ self run ];
		actionButtonIcon: BrGlamorousVectorIcons playAsynchronous
			tooltip: 'Transform all'
			action: [ self runAll ];
		actionDropdownButtonIcon: BrGlamorousVectorIcons folder
			tooltip: 'Add all files in folder'
			content: [ :button | 
				BrFileSelector new
					size: 500 @ 350;
					fileFilterBlock: [ :file | false ];
					okAction: [ :file :btn | 
						button dispatchEvent: (BrDropdownHideWish new anchor: button).
						self addDirectory: file ];
					buttonLabel: 'Add all files';
					padding: (BlInsets all: 20) ];
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add file'
			content: [ :button | 
				| extensions |
				extensions := (self model inputParserClass ifNil: [ SmaCCParser ])
						fileExtensions ifEmpty: [ '' ].
				BrFileSelector new
					size: 500 @ 350;
					fileFilterBlock: [ :file | extensions anySatisfy: [ :each | '*' , each match: file basename ] ];
					okAction: [ :file :btn | 
						button dispatchEvent: (BrDropdownHideWish new anchor: button).
						self addFiles: {file pathString} ];
					buttonLabel: 'Add file';
					padding: (BlInsets all: 20) ];
		actionButtonIcon: BrGlamorousVectorIcons remove
			tooltip: 'Remove selection'
			action: [ self removeFiles: nil ];
		contextItemLabel: 'Preview'
			action: [ :el :each | self spawnPreviewFor: each ];
		contextItemLabel: 'Run'
			action: [ :el :each | [ self model runOn: {each} ] fork ];
		contextItemLabel: 'Run all' action: [ :el :each | self runAll ];
		column: 'File' text: [ :each | self localFilename: each ];
		column: 'Ran'
			text: [ :each | (self resultFor: each) ifNotNil: [ 'X' ] ifNil: [ '' ] ]
			width: 35;
		column: 'Error'
			text: [ :each | 
				((self resultFor: each) ifNotNil: [ :result | result errorString ])
					ifNil: [ '' ] ];
		column: 'Transformation'
			text: [ :each | 
				((self resultFor: each) ifNotNil: [ :result | result transformation ])
					ifNil: [ '' ]
					ifNotNil: [ :t | t displayString ] ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> gtRulesByClassFor: aView [
	<gtTransformationViews>
	^ aView forward
		title: 'Transformations by class';
		priority: 30;
		object: [ self model rewrites ];
		view: #gtRulesByClassFor:
]

{ #category : #initialization }
GtSmaCCTransformationToolkit >> initialize [
	| header button |
	super initialize.
	model := SmaCCTransformationToolkitModel new.
	self padding: (BlInsets all: 5).
	self matchParent.
	self
		addChild: (BrLabel new
				aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
						foreground: Color gray;
						fontSize: 12);
				text: 'SmaCC Transformation Toolkit').
	header := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			yourself.
	header
		addChild: (BrLabel new
				hMatchParent;
				vFitContent;
				aptitude: BrGlamorousLabelAptitude new glamorousRegularFontAndSize;
				text: '')
		as: #filenameLabel.
	button := BrButton new
			icon: BrGlamorousIcons savetodisk;
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: 'Save configuration';
			beSmallSize;
			margin: (BlInsets all: 2);
			addAptitude: (BrGlamorousWithDropdownAptitude
					handle: [ BrButton new
							beSmallSize;
							icon: BrGlamorousIcons savetodisk;
							label: 'Save configuration';
							aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
									- BrGlamorousButtonExteriorAptitude ]
					content: [ | element fileSelectElement |
						fileSelectElement := BrFileSelectOrCreate new
								size: 500 @ 350;
								folder: (model filename ifNil: [ '.' asFileReference ] ifNotNil: [ :fn | fn parent ]);
								fileFilterBlock: [ :file | file extension = 'rwc' ];
								okAction: [ :file :btn | 
									| fn |
									button dispatchEvent: (BrDropdownHideWish new anchor: button).
									fn := file asFileReference.
									fn extension = 'rwc' ifFalse: [ fn := fn withExtension: 'rwc' ].
									model saveTo: fn ];
								buttonLabel: 'Save';
								padding: (BlInsets all: 20).
						model filename ifNotNil: [ :fn | fileSelectElement file: fn ].
						element := BrVerticalPane new.
						element fitContent.
						element addChild: fileSelectElement.
						element ]).
	header addChild: button.
	self addChild: header.
	self model: SmaCCTransformationToolkitModel new.
	self
		addShortcut: (BlShortcutWithAction new
				combination: ((BlKeyCombination builder
						key: BlKeyboardKey F5;
						build) or: BlKeyCombination primaryG);
				action: [ :anEvent :aShortcut | self preview ]).
	self
		addShortcut: (BlShortcutWithAction new
				combination: ((BlKeyCombination builder shift
						key: BlKeyboardKey F5;
						build) or: BlKeyCombination primaryD);
				action: [ :anEvent :aShortcut | self run ])
]

{ #category : #private }
GtSmaCCTransformationToolkit >> localFilename: aString [
	| commonParentDir |
	commonParentDir := model commonParentDirectory.
	(commonParentDir notEmpty
		and: [ commonParentDir last ~= FileSystem disk delimiter ])
		ifTrue: [ commonParentDir := commonParentDir , '/' ].
	^ aString asFileReference pathString allButFirst: commonParentDir size
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> model: aTransformationToolkitModel [
	model := aTransformationToolkitModel. 
	self connectToModel.
	self buildUI
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> preview [
	self
		filesElementDo: [ :el | 
			| selections |
			selections := el selectedItems.
			selections notEmpty
				ifTrue: [ | file |
					file := selections first.
					self spawnPreviewFor: file ] ]
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> removeFiles: aFileReference [
	self
		filesElementDo: [ :list | 
			| selectedItems |
			selectedItems := list selectedItems asSet.
			(selectedItems isEmpty and: [ aFileReference isNil ])
				ifTrue: [ selectedItems := {aFileReference} ].
			self model
				files: (self model files reject: [ :e | selectedItems includes: e asFileReference ]) ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> resultFor: aFilename [
	^ results at: aFilename ifAbsent: [  ]
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> run [
	self filesElementDo: [ :el | self runOn: el selectedItems ]
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> runAll [
	self filesElementDo: [ :el | self runOn: self model files ]
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> runOn: aCollection [
	| notification job |
	aCollection isEmpty ifTrue: [ ^ self ].
	aCollection size = 1 ifTrue: [ ^ self model runOn: aCollection ].
	job := (GtJob
			block: [ :j | 
				| totalCount current |
				j label: 'Transforming ' , aCollection size printString , ' files.'.
				totalCount := aCollection size.
				j max: totalCount.
				current := 0.
				self userData at: #transformationJob put: j.
				[ self model runOn: aCollection ]
					ensure: [ self userData removeKey: #transformationJob ifAbsent: [  ] ] ])
			announcer: Announcer new.
	notification := GtCompilationNotificationJob new.
	notification job: job.
	notification registerNotifications.
	^ [ job run ] asAsyncPromise
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> spawnPreviewFor: file [
	^ [ | result |
	result := self executeResultFor: file.
	self enqueueTask: [ self phlow spawnObject: result ] asBlTask ] fork
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> transformationsView: aView context: aContext [
	<gtTransformationViews>
	aContext at: #model put: self model.
	^ aView forward
		title: 'Transformations';
		priority: 20;
		object: [ self model rewrites ];
		view: #gtEditorFor:context:
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> update: aSymbol with: aValue [
	super update: aSymbol with: aValue.
	aSymbol = #resultAdded
		ifTrue: [ self addResult: aValue ]
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> updateFilename [
	self
		childNamed: #filenameLabel
		ifFound: [ :label | 
			label
				text: (model filename
						ifNil: [ 'New file' ]
						ifNotNil: [ :fn | fn asFileReference basenameWithoutExtension ])
						asRopedText bold ]
		ifNone: [  ]
]

{ #category : #private }
GtSmaCCTransformationToolkit >> updateFiles [
	self filesElementDo: [ :element | element items: self files ]
]
