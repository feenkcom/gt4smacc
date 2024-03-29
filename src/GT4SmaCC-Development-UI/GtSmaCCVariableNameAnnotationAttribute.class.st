Class {
	#name : #GtSmaCCVariableNameAnnotationAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'coder',
		'index',
		'initialName'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'instance creation' }
GtSmaCCVariableNameAnnotationAttribute class >> for: aCoder at: anIndex named: aString [
	^ self new
		beAppend;
		coder: aCoder;
		index: anIndex;
		initialName: aString;
		yourself
]

{ #category : #accessing }
GtSmaCCVariableNameAnnotationAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	| editorElement editor text |
	editorElement := BrEditorElement new.
	editorElement userData
		at: #variableCoderElement
			put: (self variableCoderElementFor: anEditorElement);
		at: #variableNameAttribute put: self.
	editorElement
		constraintsDo: [ :c | 
			c minWidth: 25.
			c horizontal fitContent.
			c vertical fitContent ].
	text := self initialNameText.
	editor := BrTextEditorModel new
		text: text;
		yourself.
	editorElement editor: editor.
	editor
		when: BrTextEditorInsertedEvent
			do: [ :event | self updateVariableName: editorElement ];
		when: BrTextEditorDeletedEvent
			do: [ :event | self updateVariableName: editorElement ].
	editorElement
		addEventFilterOn: BlBaseFocusEvent
		do: [ :event | self updateFocus: event ].
	^ BlElement new
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		border: (BlBorder paint: Color veryLightGray width: 1);
		padding: (BlInsets left: 2 right: 2);
		margin: (BlInsets top: 0 left: 4 bottom: 0 right: -2);
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addChild: editorElement;
		yourself
]

{ #category : #accessing }
GtSmaCCVariableNameAnnotationAttribute >> coder [
	^ coder
]

{ #category : #'initialize-release' }
GtSmaCCVariableNameAnnotationAttribute >> coder: anObject [
	coder := anObject
]

{ #category : #accessing }
GtSmaCCVariableNameAnnotationAttribute >> index [
	^ index
]

{ #category : #'initialize-release' }
GtSmaCCVariableNameAnnotationAttribute >> index: anObject [
	index := anObject
]

{ #category : #accessing }
GtSmaCCVariableNameAnnotationAttribute >> initialName [
	^ initialName
]

{ #category : #'initialize-release' }
GtSmaCCVariableNameAnnotationAttribute >> initialName: aString [
	initialName := aString
]

{ #category : #private }
GtSmaCCVariableNameAnnotationAttribute >> initialNameText [
	| text |
	text := initialName asRopedText.
	text glamorousCodeFontAndSize.
	^ text
]

{ #category : #private }
GtSmaCCVariableNameAnnotationAttribute >> updateFocus: event [
	| coderElement |
	coderElement := event target userData
		at: #variableCoderElement
		ifAbsent: [ ^ self ].
	event target focused
		ifTrue: [ coderElement updateFocusTo: event target ]
		ifFalse: [ coderElement loseFocusFrom: event target ]
]

{ #category : #private }
GtSmaCCVariableNameAnnotationAttribute >> updateVariableName: editorElement [
	| name textEditor coderElement |
	textEditor := editorElement editor.
	name := textEditor text asString.
	initialName = name
		ifTrue: [ ^ self ].
	coderElement := editorElement userData
		at: #variableCoderElement
		ifAbsent: [ ^ self ].
	coderElement updateNameTo: name from: initialName in: editorElement
]

{ #category : #private }
GtSmaCCVariableNameAnnotationAttribute >> variableCoderElementFor: anElement [
	anElement
		allParentsDo: [ :each | 
			(each isKindOf: GtSmaCCVariableCoderElement)
				ifTrue: [ ^ each ] ].
	^ nil
]
