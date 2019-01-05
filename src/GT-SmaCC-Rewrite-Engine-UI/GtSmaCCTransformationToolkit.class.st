Class {
	#name : #GtSmaCCTransformationToolkit,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'GT-SmaCC-Rewrite-Engine-UI'
}

{ #category : #'world menu' }
GtSmaCCTransformationToolkit class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Gt SmaCC Transformation Toolkit')
		parent: #Tools;
		order: 0.57;
		action: [ self open ].
	aBuilder withSeparatorAfter
]

{ #category : #opening }
GtSmaCCTransformationToolkit class >> open [
	^ self new open
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationElement [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		addChild: self configurationToolbar;
		yourself
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationToolbar [
	^ BrToolbar new
		look: BrToolbarLook new;
		layout:
			(BlGridLayout horizontal
				rowCount: 1;
				cellSpacing: 3);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addItems: self configurationToolbarItems
]

{ #category : #'ui-configuration' }
GtSmaCCTransformationToolkit >> configurationToolbarItems [
	^ #(
		#('Load' #open #loadConfiguration) 
		#('Save' #save #saveConfiguration)
		#('Run' #play #run)
		)
		collect: [ :each | 
			self
				createToolbarButton: each first
				icon: (BrGlamorousIcons perform: each second)
				action: [ self perform: each last ] ]
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> createToolbarButton: aString icon: anIcon action: aBlock [
	^ BrButton new
		beSmall;
		look: BrGlamorousButtonWithIconLook;
		label: aString;
		icon: anIcon asElement;
		action: aBlock
]

{ #category : #'initialize-release' }
GtSmaCCTransformationToolkit >> initialize [
	super initialize.
	self model: SmaCCTransformationToolkitModel new
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> loadConfiguration [
	| file |
	file := self promptForFile: 'Load Configuration File' extensions: #('rwc').
	file isNil
		ifTrue: [ ^ self ].
	self model: (SmaCCTransformationToolkitModel new loadFile: file).
"	self fileResults removeAll.
	self result: SmaCCRewriteCompleteResult new"
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCTransformationToolkit >> model: aSmaCCTransformationToolkitModel [
	model := aSmaCCTransformationToolkitModel
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> open [
	| space |
	space := BlSpace new.
	space withHalos.
	space title: 'SmaCC Transformation Toolkit'.
	space extent: 1200 @ 800.
	space root addChild: self windowElement.
	space show
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> previewElement [
	^ BlElement new
]

{ #category : #'configuration-actions' }
GtSmaCCTransformationToolkit >> promptForFile: aTitle extensions: anArray [
	^ UIManager default
		chooseExistingFileReference: aTitle
		extensions: anArray
		path: FileSystem workingDirectory
		preview: nil
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

{ #category : #ui }
GtSmaCCTransformationToolkit >> transformationsElement [
	^ BlElement new
]

{ #category : #ui }
GtSmaCCTransformationToolkit >> windowElement [
	| configurationTab transformationsTab previewTab tabGroup |
	configurationTab := BrTabModel new
		add: (BrLabelModel text: 'Configuration');
		stencil: [ self configurationElement ].
	transformationsTab := BrTabModel new
		add: (BrLabelModel text: 'Transformations');
		stencil: [ self transformationsElement ].
	previewTab := BrTabModel new
		add: (BrLabelModel text: 'Preview');
		stencil: [ self previewElement ].
	tabGroup := BrTabGroupModel
		with:
			{configurationTab.
			transformationsTab.
			previewTab}.
	tabGroup tabs
		do: [ :each | 
			BlElement new
				look: BrMaterialTabLabelledLook;
				viewModel: each ].
	^ BlElement new
		look: BrMaterialTabGroupLook;
		viewModel: tabGroup
]
