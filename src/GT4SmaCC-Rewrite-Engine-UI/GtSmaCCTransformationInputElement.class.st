Class {
	#name : #GtSmaCCTransformationInputElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'model',
		'results'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> addEditor [
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

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> addFiles [
	| list |
	list := (GtPhlowProtoView new columnedList
			withMultipleSelection;
			contextItemLabel: 'Preview'
				action: [ :el :each | self spawnPreviewFor: each ];
			contextItemLabel: 'Run'
				action: [ :el :each | [ self model runOn: {each} ] fork ];
			contextItemLabel: 'Run all'
				action: [ :el :each | [ self model runOn: self model files ] fork ];
			contextItemLabel: 'Remove files'
				action: [ :el :each | 
					| selectedItems |
					selectedItems := el
							allParentsDetect: [ :e | e isKindOf: BrColumnedList ]
							ifFound: [ :e | selectedItems := e selectedItems asSet ]
							ifNone: [ #() ].
					selectedItems isEmpty ifTrue: [ selectedItems := {each} ].
					self model
						files: (self model files reject: [ :e | selectedItems includes: e ]) ];
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
						ifNotNil: [ :t | t displayString ] ]) asElement.
	list padding: (BlInsets all: 5).
	self addChild: list as: #files.
	self updateFiles
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> addResult: aValue [
	results at: aValue filename put: aValue.
	self updateFiles
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> buildUI [
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
	self addFiles
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> connectToModel [
	| announcer |
	results := Dictionary new.
	model addDependent: self.
	announcer := model announcer weak.
	announcer
		when: #files
			send: #updateFiles
			to: self;
		when: #filename
			send: #updateFilename
			to: self
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> executeResultFor: aFilename [
	^ self
		executeResultFor: aFilename
		before: [  ]
		after: [  ]
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> executeResultFor: aFilename before: beforeBlock after: afterBlock [
	aFilename ifNil: [ ^ nil ].
	^ self model
		previewResultFor: aFilename
		before: beforeBlock
		after: afterBlock
		onException: [  ]
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> filesElementDo: aBlock [
	self
		enqueueTask: (BlTaskAction new
				action: [ self
						childNamed: #files
						ifFound: [ :element | aBlock value: element children last ] ])
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> initialize [
	| header button |
	super initialize.
	self padding: (BlInsets all: 5).
	self matchParent.
	self
		addChild: (BrLabel new
				aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize
						foreground: Color gray;
						fontSize: 12);
				text: 'SmaCC Transformations').
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
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F5;
						build);
				action: [ :anEvent :aShortcut | self preview ]).
	self
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder shift
						key: BlKeyboardKey F5;
						build);
				action: [ :anEvent :aShortcut | self run ])
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> localFilename: aString [
	| commonParentDir |
	commonParentDir := model commonParentDirectory.
	(commonParentDir notEmpty
		and: [ commonParentDir last ~= FileSystem disk delimiter ])
		ifTrue: [ commonParentDir := commonParentDir , '/' ].
	^ aString asFileReference pathString allButFirst: commonParentDir size
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> model: aTransformationToolkitModel [
	model := aTransformationToolkitModel. 
	self connectToModel.
	self buildUI
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> preview [
	self
		filesElementDo: [ :el | 
			| selections |
			selections := el selectedItems.
			selections notEmpty
				ifTrue: [ | file |
					file := selections first.
					self spawnPreviewFor: file ] ]
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> resultFor: aFilename [
	^ results at: aFilename ifAbsent: [  ]
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> run [
	self
		filesElementDo: [ :el | 
			| selections |
			selections := el selectedItems.
			selections notEmpty ifTrue: [ [ self model runOn: selections ] fork ] ]
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> spawnPreviewFor: file [
	^ [ | result |
	result := self executeResultFor: file.
	self enqueueTask: [ self phlow spawnObject: result ] asBlTask ] fork
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> update: aSymbol with: aValue [
	super update: aSymbol with: aValue.
	aSymbol = #resultAdded
		ifTrue: [ self addResult: aValue ]
]

{ #category : #accessing }
GtSmaCCTransformationInputElement >> updateFilename [
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

{ #category : #'as yet unclassified' }
GtSmaCCTransformationInputElement >> updateFiles [
	self
		filesElementDo: [ :element | 
			element
				items: ((model files collect: #asFileReference)
						asSortedCollection: [ :a :b | a pathString < b pathString ]) ]
]
