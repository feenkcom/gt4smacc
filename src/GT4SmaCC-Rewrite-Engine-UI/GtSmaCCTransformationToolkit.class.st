Class {
	#name : #GtSmaCCTransformationToolkit,
	#superclass : #BrVerticalPane,
	#instVars : [
		'model',
		'results',
		'filterModel',
		'updateTask'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-UI'
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
	self
		inUIProcessDo: [ | fileRef |
			fileRef := aValue filename asFileReference.
			results at: fileRef put: aValue.
			results at: fileRef asAbsolute asFileReference put: aValue.
			self userData
				at: #transformationJob
				ifPresent: [ :job | job currentValue: job currentValue + 1 ]
				ifAbsent: [  ].
			self delayUpdateFiles ]
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

{ #category : #filtering }
GtSmaCCTransformationToolkit >> buildFilter [
	| filter |
	filter := GtSmaCCTransformationFilesFilter new toolkit: self.
	(filterModel items collect: #asSearchFilter)
		do: [ :each | filter := filter & (each toolkit: self) ].
	^ filter
]

{ #category : #filtering }
GtSmaCCTransformationToolkit >> buildFilterModel [
	^ GtFilterItemsModel new
		items: {GtSmaCCTransformationFilenameFilter filterDescriptor};
		availableFiltersBuilder: GtSmaCCTransformationFilesFilter
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
GtSmaCCTransformationToolkit >> delayUpdateFiles [
	updateTask ifNotNil: [ ^ self ].
	updateTask := BlDelayedTaskAction new
			action: [ updateTask := nil.
				self updateFiles ];
			delay: 100 milliseconds.
	self enqueueTask: updateTask
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> errorStringFor: each [
	^ ((self resultFor: each) ifNotNil: [ :result | result errorString ])
		ifNil: [ '' ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> errorTransformationFor: each [
	^ ((self resultFor: each) ifNotNil: [ :result | result transformation ])
		ifNil: [ '' ]
		ifNotNil: [ :t | t displayString ]
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
	^ aView columnedList
		title: 'Files';
		priority: 10;
		withMultipleSelection;
		items: [ self files ];
		contextItemLabel: 'Preview'
			action: [ :el :each | self spawnPreviewFor: each ];
		contextItemLabel: 'Transform' action: [ :el :each | self runOn: {each} ];
		contextItemLabel: 'Transform all' action: [ :el :each | self runAll ];
		contextItemLabel: 'Transform all using remote runner'
			action: [ :el :each | self runAllUsingRemoteRunner ];
		column: 'File' text: [ :each | self localFilename: each ];
		column: 'Ran'
			text: [ :each | (self resultFor: each) ifNotNil: [ 'X' ] ifNil: [ '' ] ]
			width: 35;
		column: 'Error' text: [ :each | self errorStringFor: each ];
		column: 'Transformation' text: [ :each | self errorTransformationFor: each ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> filesWithSearchView: aView [
	<gtTransformationViews>
	^ aView explicit
		title: 'Files';
		priority: 10;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Preview'
			action: [ self preview ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Transform'
			action: [ self run ];
		actionButtonIcon: BrGlamorousVectorIcons playAsynchronous
			tooltip: 'Transform all'
			action: [ self runAll ];
		actionButtonIcon: self playAllOnServerIcon
			tooltip: 'Transform all using remote runner'
			action: [ self runAllUsingRemoteRunner ];
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
		stencil: [ | pane |
			pane := BrVerticalPane new matchParent.
			pane addChild: self filterElement.
			pane addChild: (self filesView: GtPhlowProtoView new) asElement.
			pane ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> filterElement [
	filterModel
		ifNil: [ filterModel := self buildFilterModel.
			filterModel weak
				when: GtFiltersModelAnnouncement
				send: #updateFilters
				to: self ].
	^ filterModel asFiltersElement
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

{ #category : #testing }
GtSmaCCTransformationToolkit >> hasRun: anObject [
	^ (self resultFor: anObject) notNil
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
			addAptitude: (BrGlamorousWithExplicitDropdownAptitude
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
	commonParentDir := model commonParentDirectory asFileReference.
	^ (aString asFileReference relativeTo: commonParentDir) pathString
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

{ #category : #ui }
GtSmaCCTransformationToolkit >> onTaskCompletedAnnouncement: anAnnouncement [
	self addResult: anAnnouncement taskResult
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> playAllOnServerIcon [
	^ [ BlElement new
		size: 18 @ 16;
		geometry: (BlSvgPath new
				svg: 'M -.70100145 3.5 L -.70100145 13.4 L 6.6989986 8.45 Z M 4.29899855 3.5 L 4.29899855 13.4 L 11.6989986 8.45 Z M 14.668068 12.2 L 14.668068 12.2 C 15.238442 12.2 15.705104 12.098149 16.068068 11.894444 C 16.431033 11.69074 16.707574 11.436113 16.897698 11.130556 L 16.897698 11.741667 C 16.897698 11.83426 16.923624 11.910648 16.975476 11.970833 C 17.027328 12.031019 17.096463 12.061111 17.182883 12.061111 L 17.753253 12.061111 C 17.839674 12.061111 17.91097 12.031019 17.967142 11.970833 C 18.023315 11.910648 18.051402 11.83426 18.051402 11.741667 L 18.051402 7.227778 C 18.051402 6.505552 17.841836 5.903706 17.422698 5.422222 C 17.00356 4.9407383 16.310048 4.7 15.342142 4.7 C 14.780411 4.7 14.305107 4.8041656 13.916216 5.0125 C 13.527326 5.2208344 13.239983 5.466202 13.054179 5.748611 C 12.868376 6.03102 12.775476 6.278703 12.775476 6.491667 C 12.775476 6.5750004 12.803562 6.646759 12.859735 6.7069444 C 12.915908 6.76713 12.982883 6.797222 13.060661 6.797222 L 13.566216 6.797222 C 13.635353 6.797222 13.689364 6.781019 13.728253 6.748611 C 13.767143 6.7162035 13.803871 6.653704 13.838439 6.561111 C 13.950785 6.3296285 14.127944 6.1282416 14.36992 5.9569444 C 14.611897 5.785647 14.931647 5.7 15.32918 5.7 C 16.35758 5.7 16.871772 6.176847 16.871772 7.1305556 L 16.871772 7.533333 L 14.927328 7.825 C 14.12362 7.95463 13.488441 8.213887 13.021772 8.602778 C 12.555103 8.991669 12.321772 9.491664 12.321772 10.102778 C 12.321772 10.491669 12.427635 10.845832 12.639365 11.165278 C 12.851094 11.484724 13.136276 11.737036 13.49492 11.922222 C 13.853564 12.107408 14.244609 12.2 14.668068 12.2 Z M 16.871772 8.852778 L 16.871772 8.852778 C 16.871772 9.612041 16.690292 10.190739 16.327328 10.588889 C 15.964363 10.987039 15.497701 11.186111 14.927328 11.186111 C 14.529795 11.186111 14.18628 11.08426 13.896772 10.880556 C 13.607264 10.676851 13.462513 10.385187 13.462513 10.005556 C 13.462513 9.67222 13.622388 9.394446 13.942142 9.172222 C 14.261897 8.949999 14.73288 8.792593 15.355105 8.7 L 16.871772 8.463889 Z'
				viewbox: (-10 @ 0 extent: 18 @ 16));
		background: Color black ] asStencil
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
	^ results
		at: aFilename
		ifAbsent: [ results at: aFilename asAbsolute asFileReference ifAbsent: [  ] ]
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> run [
	self filesElementDo: [ :el | self runOn: el selectedItems ]
]

{ #category : #actions }
GtSmaCCTransformationToolkit >> runAll [
	self filesElementDo: [ :el | self runOn: self model files ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> runAllUsingRemoteRunner [
	| job |
	job := self model asRRJob.
	job showProgressNotification.
	job
		when: GtRrTaskCompletedAnnouncement
		send: #onTaskCompletedAnnouncement:
		to: self.
	GtRemoteRunner default submitJob: job
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
	notification := GtNotificationJob new
			summaryClass: GtCompilationNotificationSummary;
			job: job;
			registerNotifications;
			yourself.
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
	| filter |
	filter := self buildFilter.
	self filesElementDo: [ :element | element stream: filter asAsyncStream ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> updateFilters [
	self updateFiles
]
