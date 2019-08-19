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
GtSmaCCVariableNameAnnotationAttribute >> affect: aBrText in: anEditorElement [
	| editorElement editor text |
	editorElement := BrEditorElement new.
	editorElement border: (BlBorder paint: Color veryLightGray width: 1).
	editorElement
		margin:
			(BlInsets
				top:  -3
				left: 5
				bottom: 3
				right: 5).
	editorElement padding: (BlInsets all: 2).
	editorElement
		constraintsDo: [ :c | 
			c minWidth: 25.
			c horizontal fitContent.
			c vertical fitContent ].
	text := self initialNameText.
	editor := BrTextEditor new
		text: text;
		yourself.
	editorElement editor: editor.
	editorElement
		addEventFilterOn: BlBlurEvent
		do: [ :event | self updateVariableName: editor ].
	^ editorElement
]

{ #category : #'initialize-release' }
GtSmaCCVariableNameAnnotationAttribute >> coder: anObject [
	coder := anObject
]

{ #category : #'initialize-release' }
GtSmaCCVariableNameAnnotationAttribute >> index: anObject [
	index := anObject
]

{ #category : #'initialize-release' }
GtSmaCCVariableNameAnnotationAttribute >> initialName: anObject [
	initialName := anObject
]

{ #category : #private }
GtSmaCCVariableNameAnnotationAttribute >> initialNameText [
	| text |
	text := initialName asRopedText.
	text attributes: GtSmaCCCoder defaultTextAttributes.
	^ text
]

{ #category : #private }
GtSmaCCVariableNameAnnotationAttribute >> updateVariableName: textEditor [
	| name |
	name := textEditor text asString trim.
	initialName = name
		ifTrue: [ ^ self ].
	initialName := (coder nameVariableAt: index as: name)
		ifNil: [ initialName ].
	textEditor text: self initialNameText
]
