Class {
	#name : #GtSmaCCPropertyDefinitionElement,
	#superclass : #GtSmaCCAbstractRewriteElement,
	#category : #'GT4SmaCC-Rewrite-Engine-UI-UI'
}

{ #category : #building }
GtSmaCCPropertyDefinitionElement >> addButton: aString [
	| button |
	button := BrButton new.
	button icon: BrGlamorousIcons add.
	button aptitude: BrGlamorousButtonWithIconAptitude.
	button label: 'Add'.
	button beSmallSize.
	button margin: (BlInsets all: 2).
	button
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
				handle: [ BrButton new
						beSmallSize;
						icon: BrGlamorousIcons add;
						label: 'Add';
						aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
								- BrGlamorousButtonExteriorAptitude ]
				content: [ | editor |
					editor := BrEditor new
							border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
							hMatchParent;
							vFitContent;
							aptitude: BrGlamorousRegularEditorAptitude new.
					BrVerticalPane new
						width: 300;
						vFitContent;
						padding: (BlInsets all: 5);
						addChild: (BrHorizontalPane new
								hMatchParent;
								vFitContent;
								addChild: (BrLabel new
										margin: (BlInsets all: 4);
										vFitContent;
										aptitude: BrGlamorousLabelAptitude;
										text: 'Name:');
								addChild: editor);
						addChild: (BrButton new
								beSmallSize;
								aptitude: BrGlamorousButtonWithIconAptitude;
								label: 'Add';
								icon: BrGlamorousIcons add asElement;
								margin: (BlInsets all: 2);
								action: [ :theButton | | variableName |
									variableName := editor text asString.
									(RBScanner isVariable: variableName)
										ifTrue: [ theButton fireEvent: BrDropdownHideWish new.
											rewrite perform: ('add' , aString , ':') asSymbol with: variableName ] ]) ]).
	^ button
]

{ #category : #building }
GtSmaCCPropertyDefinitionElement >> build [
	| tabGroup |
	super build.
	tabGroup := (BrTabGroup new)
		matchParent;
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white.
	tabGroup addTab: (self variablesTab: 'Local').
	tabGroup addTab: (self variablesTab: 'Global').
	self addChild: tabGroup as: #tabGroup.
	self updateLocals.
	self updateGlobals
]

{ #category : #private }
GtSmaCCPropertyDefinitionElement >> connectModel [
	super connectModel.
	rewrite ifNil: [ ^ self ].
	rewrite announcer weak
		when: #locals
			send: #updateLocals
			to: self;
		when: #globals
			send: #updateGlobals
			to: self
]

{ #category : #building }
GtSmaCCPropertyDefinitionElement >> removeButton: aString list: list [
	^ BrButton new
		beSmallSize;
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: 'Remove';
		icon: BrGlamorousIcons remove asElement;
		margin: (BlInsets all: 2);
		action: [ list selectedIndices
				collect: [ :i | 
					rewrite
						perform: ('remove' , aString , ':') asSymbol
						with: (list items at: i ifAbsent: [  ]) ] ]
]

{ #category : #private }
GtSmaCCPropertyDefinitionElement >> updateGlobals [
	self childNamed: #GlobalVariables ifFound: [ :list | list items: rewrite globalVariableNames ].
	self
		childNamed: #tabGroup
		ifFound: [ :tg | tg tabs second widget label: 'Globals (' , rewrite globalVariableNames size printString , ')' ]
]

{ #category : #private }
GtSmaCCPropertyDefinitionElement >> updateLocals [
	self childNamed: #LocalVariables ifFound: [ :list | list items: rewrite localVariableNames ].
	self
		childNamed: #tabGroup
		ifFound: [ :tg | tg tabs first widget label: 'Locals (' , rewrite localVariableNames size printString , ')' ]
]

{ #category : #building }
GtSmaCCPropertyDefinitionElement >> variableNamesFor: aSymbol [
	^ aSymbol = 'Local' ifTrue: [ rewrite localVariableNames ] ifFalse: [ rewrite globalVariableNames ]
]

{ #category : #building }
GtSmaCCPropertyDefinitionElement >> variableTabPage: aString [
	| toolbar element list |
	element := (BrHorizontalPane new)
		matchParent;
		margin: (BlInsets all: 5).
	list := (BrSimpleList new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		margin: (BlInsets right: 5);
		matchParent;
		itemStencil:
				[ (BrLabel new)
						hMatchParent;
						aptitude: BrGlamorousLabelAptitude new + BrGlamorousListItemAptitude;
						padding: (BlInsets all: 5) ];
		itemDataBinder: [ :lbl :each :i | lbl text: each ].
	element addChild: list as: (aString , 'Variables') asSymbol.
	toolbar := (BrToolbar new)
		aptitude: BrGlamorousToolbarAptitude new;
		vMatchParent;
		layout: BlLinearLayout vertical;
		addItems:
				{self addButton: aString.
						self removeButton: aString list: list}.
	element addChild: toolbar.
	^ element
]

{ #category : #building }
GtSmaCCPropertyDefinitionElement >> variablesTab: aString [
	^ (BrTab new)
		aptitude: BrGlamorousTabAptitude new;
		label: aString;
		stencil: [ self variableTabPage: aString ]
]
