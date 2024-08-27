Class {
	#name : #GtSmaCCTransformationElement,
	#superclass : #BrHorizontalPane,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'transformationsTree',
		'transformationElement',
		'rewriteFilter',
		'rewrites',
		'announcer'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #actions }
GtSmaCCTransformationElement >> addRewrite: newRewrite [
	| selected |
	selected := self selectedRewrite.
	selected isComposite
		ifTrue: [ selected addTransformation: newRewrite ]
		ifFalse: [ selected parent notNil ifTrue: [ selected parent addTransformation: newRewrite before: selected ] ].
	self updateAndSelectRewrite: newRewrite
]

{ #category : #ui }
GtSmaCCTransformationElement >> addTransformationDropdownFor: button [
	| element |
	element := BrVerticalPane new.
	^ element
		padding: (BlInsets all: 5);
		fitContent;
		addChild: (BrButton new
				beSmallSize;
				aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
				label: 'Rewrite';
				action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self addRewrite: SmaCCRewrite newInstance ]);
		addChild: (BrButton new
				beSmallSize;
				aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
				label: 'Method';
				action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self addRewrite: SmaCCRewriteMethodDefinition new ]);
		addChild: (BrButton new
				beSmallSize;
				aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
				label: 'Properties';
				action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self addRewrite: SmaCCRewritePropertyDefinition new ]);
		addChild: (BrButton new
				beSmallSize;
				aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
				label: 'File';
				action: [ element removeChildren.
					element
						addChild: (BrFileSelectOrCreate new
								size: 500 @ 350;
								folder: self currentDirectory;
								fileFilterBlock: [ :file | file extension = 'rw' ];
								okAction: [ :file :btn | 
									| fn |
									button dispatchEvent: (BrDropdownHideWish new anchor: button).
									fn := file asFileReference.
									fn extension = 'rw' ifFalse: [ fn := fn withExtension: 'rw' ].
									self addRewrite: (SmaCCRewriteFile onFile: fn) ];
								buttonLabel: 'Add File';
								padding: (BlInsets all: 20)) ]);
		yourself
]

{ #category : #announcer }
GtSmaCCTransformationElement >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> applyRewriteFilter: aString [
	rewriteFilter := aString.
	self updateRewrites.
	self displayRewrite: self selectedRewrite
]

{ #category : #ui }
GtSmaCCTransformationElement >> connectModel [
	rewrites ifNil: [ ^ self ].
	rewrites announcer weak
		when: #rewrites
		send: #updateRewrites
		to: self
]

{ #category : #accessing }
GtSmaCCTransformationElement >> currentDirectory [
	| filename |
	filename := rewrites filename ifNotNil: [ rewrites filename asFileReference ].
	^ (filename notNil and: [ filename parent exists ])
		ifTrue: [ filename parent ]
		ifFalse: [ FileLocator workingDirectory ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> deleteRewrite [
	self selectedRewrite
		ifNotNil:
			[ :rewrite | 
			rewrite parent notNil
				ifTrue:
					[ rewrite parent removeTransformation: rewrite.
					self updateRewrites.
					self displayRewrite: self selectedRewrite ] ]
]

{ #category : #ui }
GtSmaCCTransformationElement >> deleteTransformationDropdownFor: button [
	| rewrite |
	rewrite := self selectedRewrite.
	^ (rewrite isNil or: [ rewrite parent isNil ])
		ifTrue: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
			BlElement new size: 0 @ 0 ]
		ifFalse: [ BrVerticalPane new
				padding: (BlInsets all: 5);
				fitContent;
				addChild: (BrLabel new
						fitContent;
						aptitude: BrGlamorousLabelAptitude new;
						text: 'Delete ' , rewrite displayString , '?');
				addChild: (BrButton new
						beSmallSize;
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: 'Delete';
						icon: BrGlamorousIcons remove asElement;
						margin: (BlInsets all: 2);
						action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
							self deleteRewrite ]) ]
]

{ #category : #ui }
GtSmaCCTransformationElement >> disconnectModel [
	rewrites ifNil: [ ^ self ].
	rewrites announcer unsubscribe: self
]

{ #category : #actions }
GtSmaCCTransformationElement >> displayRewrite: aRewrite [
	transformationElement ifNil: [ ^ self ].
	transformationElement removeChildren.
	aRewrite ifNotNil: [ transformationElement addChild: aRewrite asElement ]
]

{ #category : #ui }
GtSmaCCTransformationElement >> filterDropdownFor: button [
	| editor |
	editor := BrEditor new.
	editor editor text: rewriteFilter asRopedText.
	editor selecter all select.
	editor
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination enter;
				action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self applyRewriteFilter: editor editor text asString ]);
		requestFocus;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		margin: (BlInsets
				top: 2
				left: 4
				bottom: 6
				right: 4);
		width: 250;
		vFitContent.
	^ BrVerticalPane new
		padding: (BlInsets all: 5);
		fitContent;
		addChild: (BrLabel new
				margin: (BlInsets all: 4);
				vFitContent;
				aptitude: BrGlamorousLabelAptitude;
				text: 'Filter:');
		addChild: editor;
		addChild: (BrButton new
				beSmallSize;
				aptitude: BrGlamorousButtonWithIconAptitude;
				label: 'Apply Filter';
				icon: BrGlamorousIcons filter asElement;
				margin: (BlInsets all: 2);
				action: [ button dispatchEvent: (BrDropdownHideWish new anchor: button).
					self applyRewriteFilter: editor editor text asString ]);
		yourself
]

{ #category : #initialization }
GtSmaCCTransformationElement >> initialize [
	| leftElement |
	super initialize.
	rewrites := SmaCCRewriteFile new.
	rewriteFilter := ''.
	self matchParent.
	leftElement := BrVerticalPane new
			width: 250;
			vMatchParent;
			margin: (BlInsets all: 5);
			padding: (BlInsets all: 5);
			aptitude: BrGlamorousWithHorizontalResizerAptitude new beRight.
	transformationsTree := BrSimpleTree new.
	transformationsTree
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new;
		nodeStencil: [ BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				vFitContent;
				hMatchParent ];
		nodeDataBinder: [ :label :rewrite | label text: rewrite displayString ];
		when: BrSelectionChanged
			do: [ :event | self selectedRewrite ifNotNil: [ :value | self displayRewrite: value ] ].
	transformationsTree
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						primary;
						key: BlKeyboardKey arrowUp;
						build);
				action: [ self moveRewriteUp ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						primary;
						key: BlKeyboardKey arrowDown;
						build);
				action: [ self moveRewriteDown ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						primary;
						key: BlKeyboardKey arrowLeft;
						build);
				action: [ self moveRewriteOut ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						primary;
						key: BlKeyboardKey arrowRight;
						build);
				action: [ self moveRewriteInto ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						primary;
						shift;
						key: BlKeyboardKey arrowUp;
						build);
				action: [ self moveRewriteToTop ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						primary;
						shift;
						key: BlKeyboardKey arrowDown;
						build);
				action: [ self moveRewriteToBottom ]).
	leftElement addChild: transformationsTree.
	self addChild: leftElement.
	transformationElement := BlElement new.
	transformationElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		margin: (BlInsets all: 5).
	self addChild: transformationElement.
	self updateRewrites
]

{ #category : #actions }
GtSmaCCTransformationElement >> moveRewriteDown [
	self selectedRewrite
		ifNotNil: [ :rewrite | 
			rewrite parent
				ifNotNil: [ :parentRewrite | 
					| index |
					index := parentRewrite rewrites identityIndexOf: rewrite.
					index = parentRewrite rewrites size
						ifFalse: [ parentRewrite removeTransformation: rewrite.
							index < parentRewrite rewrites size
								ifTrue: [ parentRewrite
										addTransformation: rewrite
										before: (parentRewrite rewrites at: index + 1) ]
								ifFalse: [ parentRewrite addTransformation: rewrite ].
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> moveRewriteInto [
	self selectedRewrite
		ifNotNil: [ :rewrite | 
			rewrite parent
				ifNotNil: [ :parentRewrite | 
					| index newParent |
					index := parentRewrite rewrites identityIndexOf: rewrite.
					(index > 1
						and: [ (newParent := parentRewrite rewrites at: index - 1) isComposite ])
						ifTrue: [ parentRewrite removeTransformation: rewrite.
							newParent addTransformation: rewrite.
							self updateAndSelectRewrite: rewrite ].
					(index < parentRewrite rewrites size
						and: [ (newParent := parentRewrite rewrites at: index + 1) isComposite ])
						ifTrue: [ parentRewrite removeTransformation: rewrite.
							newParent rewrites isEmpty
								ifTrue: [ newParent addTransformation: rewrite ]
								ifFalse: [ newParent addTransformation: rewrite before: newParent rewrites first ].
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> moveRewriteOut [
	self selectedRewrite
		ifNotNil: [ :rewrite | 
			rewrite parent
				ifNotNil: [ :parentRewrite | 
					parentRewrite parent
						ifNotNil: [ :grandparent | 
							parentRewrite removeTransformation: rewrite.
							grandparent addTransformation: rewrite before: parentRewrite.
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> moveRewriteToBottom [
	self selectedRewrite
		ifNotNil: [ :rewrite | 
			rewrite parent
				ifNotNil: [ :parentRewrite | 
					parentRewrite rewrites last == rewrite
						ifFalse: [ parentRewrite removeTransformation: rewrite.
							parentRewrite addTransformation: rewrite.
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> moveRewriteToTop [
	self selectedRewrite
		ifNotNil: [ :rewrite | 
			rewrite parent
				ifNotNil: [ :parentParent | 
					parentParent rewrites first == rewrite
						ifFalse: [ parentParent removeTransformation: rewrite.
							parentParent
								addTransformation: rewrite
								before: parentParent rewrites first.
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #actions }
GtSmaCCTransformationElement >> moveRewriteUp [
	self selectedRewrite
		ifNotNil: [ :rewrite | 
			rewrite parent
				ifNotNil: [ :parentRewrite | 
					| index |
					index := parentRewrite rewrites identityIndexOf: rewrite.
					index > 1
						ifTrue: [ parentRewrite removeTransformation: rewrite.
							parentRewrite
								addTransformation: rewrite
								before: (parentRewrite rewrites at: index - 1).
							self updateAndSelectRewrite: rewrite ] ] ]
]

{ #category : #ui }
GtSmaCCTransformationElement >> rewrites [
	^ rewrites
]

{ #category : #ui }
GtSmaCCTransformationElement >> rewrites: aRewriteFile [
	self disconnectModel.
	rewrites = aRewriteFile ifTrue: [ ^ self ].
	rewrites := aRewriteFile.
	self connectModel.
	self updateRewrites
]

{ #category : #private }
GtSmaCCTransformationElement >> satisfiesRewriteFilter: aSmaCCRewrite [
	rewriteFilter = '' ifTrue: [ ^ true ].
	^ (aSmaCCRewrite matches: rewriteFilter)
		or: [ aSmaCCRewrite rewrites anySatisfy: [ :rw | self satisfiesRewriteFilter: rw ] ]
]

{ #category : #private }
GtSmaCCTransformationElement >> selectAndScrollToRewrite: aRewrite [
	transformationsTree selectAndScrollTo: aRewrite.
	self displayRewrite: aRewrite
]

{ #category : #accessing }
GtSmaCCTransformationElement >> selectedRewrite [
	transformationsTree
		selectedNodeDo: [ :node | node value ifNotNil: [ :value | ^ value ] ].
	^ rewrites
]

{ #category : #actions }
GtSmaCCTransformationElement >> updateAndSelectRewrite: rewrite [
	self updateRewrites.
	self selectAndScrollToRewrite: rewrite
]

{ #category : #private }
GtSmaCCTransformationElement >> updateRewrites [
	transformationsTree ifNil: [ ^ self ].
	transformationsTree
		items: {rewrites}
		lazy: [ :each | each rewrites select: [ :rw | self satisfiesRewriteFilter: rw ] ].
	transformationsTree expandAll.
	self selectedRewrite ifNotNil: [ :value | self displayRewrite: value ]
]
