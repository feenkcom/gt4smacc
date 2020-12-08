Class {
	#name : #GtSmaCCVariableCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'coder'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCVariableCoderElement class >> onCoder: aGrammarCoder [
	^ self new
		coder: aGrammarCoder;
		yourself
]

{ #category : #accessing }
GtSmaCCVariableCoderElement >> coder [
	^ coder
]

{ #category : #accessing }
GtSmaCCVariableCoderElement >> coder: aCoder [
	coder := aCoder.
	self header: [ self collapsedElement ].
	self content: [ self contentElement ].
	self margin: (BlInsets all: 4).
	self
		when: BrExpandedEvent
		do: [ :event | coder expanded: true ].	
	self
		when: BrCollapsedEvent
		do: [ :event | coder expanded: false ].	
	coder expanded
		ifTrue: [ self expand ]
]

{ #category : #ui }
GtSmaCCVariableCoderElement >> collapsedElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	element addChild: self labelElement.
	^ element
]

{ #category : #ui }
GtSmaCCVariableCoderElement >> contentElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	element addChild: self labelElement.
	element addChildren: self referenceElements.
	^ element
]

{ #category : #private }
GtSmaCCVariableCoderElement >> editType [
	^ self ownerElement editType
]

{ #category : #private }
GtSmaCCVariableCoderElement >> editorsDo: aBlock [
	self
		allChildrenBreadthFirstDo: [ :each | 
			(each userData at: #variableNameAttribute ifAbsent: [ nil ]) notNil
				ifTrue: [ aBlock value: each ] ]
]

{ #category : #private }
GtSmaCCVariableCoderElement >> focusedEditor [
	self
		editorsDo: [ :each | 
			each focused
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #'initialize-release' }
GtSmaCCVariableCoderElement >> initialize [
	| resizer |
	super initialize.
	self
		vFitContent;
		hMatchParent.
	resizer := BrResizer new
		beBottom;
		look: BrGlamorousResizerLook new;
		constraintsDo: [ :c | c ignoreByLayout ];
		when: BlDoubleClickEvent
			do: [ self
				childNamed: #bodyEditor
				ifFound: [ :anEditor | anEditor constraintsDo: [ :c | c vertical fitContent ] ]
				ifNone: [  ] ];
		yourself.
	self
		look:
			(GtCoderExpanderLook new
				borderWidth: 0;
				padding:
					(BlInsets
						top: 1
						left: 10
						bottom: 1
						right: 10))
				+
					(BrInteractiveLook new
						style: [ :aStyler | 
							aStyler
								default: [ resizer removeFromParent.
									self background: Color transparent ].
							aStyler
								expanded: [ self addChild: resizer.
									self
										enqueueTask:
											(BlTaskAction new
												action: [ self
														childNamed: #bodyEditor
														ifFound: [ :anEditor | resizer target: anEditor ]
														ifNone: [ resizer target: nil ] ]).
									self background: Color white ] ]).
	self
		addShortcut:
			(BlShortcutWithAction new
				combination:
					(BlKeyCombination builder
						primary;
						return;
						build);
				action: [ self toggle ]);
		addShortcut:
			(BlShortcutWithAction new
				combination:
					(BlCompulsoryCombination new
						withAll:
							{BlKeyCombination builder primary build.
							(BlSingleKeyCombination key: BlKeyboardKey t)});
				action: [ :each | self toggleNextRenaming ]);
		addShortcut:
			(BlShortcutWithAction new
				combination:
					(BlCompulsoryCombination new
						withAll:
							{BlKeyCombination builder primary shift build.
							(BlSingleKeyCombination key: BlKeyboardKey t)});
				action: [ :each | self togglePreviousRenaming ])
]

{ #category : #ui }
GtSmaCCVariableCoderElement >> labelElement [
	| label |
	label := BrLabel new.
	label padding: (BlInsets all: 2).
	label look: BrGlamorousLabelLook new glamorousCodeFontAndSize.
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	label text: coder labelText.
	^ label
]

{ #category : #private }
GtSmaCCVariableCoderElement >> loseFocusFrom: anEditorElement [
	self editorsDo: [ :each | each background: Color white ]
]

{ #category : #private }
GtSmaCCVariableCoderElement >> ownerElement [
	self
		allParentsDo: [ :each | 
			(each isKindOf: GtSmaCCGrammarVariableCoderElement)
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #ui }
GtSmaCCVariableCoderElement >> referenceElements [
	^ coder referencesText
		collect: [ :each | 
			| editorElement |
			editorElement := BrEditorElement new.
			editorElement
				margin:
					(BlInsets
						top: 2
						left: 15
						bottom: 0
						right: 15).
			editorElement padding: (BlInsets all: 2).
			editorElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ].
			editorElement
				editor:
					(BrTextEditor new
						text: each readonly;
						yourself).
			editorElement ]
]

{ #category : #private }
GtSmaCCVariableCoderElement >> toggleNextRenaming [
	self ownerElement toggleNextRenaming.
	self updateEditorBackgrounds
]

{ #category : #private }
GtSmaCCVariableCoderElement >> togglePreviousRenaming [
	self ownerElement togglePreviousRenaming.
	self updateEditorBackgrounds
]

{ #category : #private }
GtSmaCCVariableCoderElement >> updateEditorBackgrounds [
	| focused |
	focused := self focusedEditor.
	focused isNil
		ifTrue: [ ^ self ].
	self updateFocusTo: focused
]

{ #category : #private }
GtSmaCCVariableCoderElement >> updateFocusTo: anEditorElement [
	| testBlock |
	testBlock := self editType = #single
		ifTrue: [ [ :each | each == anEditorElement ] ]
		ifFalse: [ self editType = #all
				ifTrue: [ [ :each | true ] ]
				ifFalse:
					[ [ :each | each editor text asString = anEditorElement editor text asString ] ] ].
	self
		editorsDo: [ :each | 
			(testBlock value: each)
				ifTrue: [ each background: (Color veryLightGray alpha: 0.5) ]
				ifFalse: [ each background: Color white ] ]
]

{ #category : #private }
GtSmaCCVariableCoderElement >> updateNameTo: newName from: initialName in: element [
	| testBlock |
	testBlock := self editType = #single
		ifTrue: [ [ :each | each == element ] ]
		ifFalse: [ self editType = #all
				ifTrue: [ [ :each | true ] ]
				ifFalse:
					[ [ :each | (each userData at: #variableNameAttribute) initialName = initialName ] ] ].
	self
		editorsDo: [ :each | 
			(testBlock value: each)
				ifTrue: [ | attr |
					attr := each userData at: #variableNameAttribute.
					(attr coder nameVariableAt: attr index as: newName)
						ifNotNil: [ :name | attr initialName: name ].
					each editor text asString ~= attr initialName
						ifTrue: [ each editor
								text: attr initialName asRopedText glamorousCodeFontAndSize ] ] ].
	self updateEditorBackgrounds
]
