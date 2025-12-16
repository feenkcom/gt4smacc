Class {
	#name : #GtSmaCCRenameAction,
	#superclass : #GtRenameAction,
	#instVars : [
		'otherLocations',
		'otherRenameAttributes'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #initialization }
GtSmaCCRenameAction >> addLocations: intervals to: anEditor [
	otherLocations
		at: anEditor
		put: (intervals asSortedCollection: [ :a :b | a first < b first ])
]

{ #category : #private }
GtSmaCCRenameAction >> addRenameAttributes [
	super addRenameAttributes.
	otherLocations keysAndValuesDo: [ :editor :intervals | 
		| text |
		text := editor text.
		intervals do: [ :interval | 
			| attribute |
			attribute := GtRenamePreviewAttribute new
				             action: self;
				             text: (text from: interval first to: interval last).
			(text from: interval first to: interval last) attributes:
				{ attribute }.
			otherRenameAttributes add: attribute ].
		editor text: text ]
]

{ #category : #'private - actions' }
GtSmaCCRenameAction >> allowSave [
]

{ #category : #initialization }
GtSmaCCRenameAction >> initialize [
	super initialize.
	otherLocations := IdentityDictionary new.
	otherRenameAttributes := OrderedCollection new
]

{ #category : #'private - actions' }
GtSmaCCRenameAction >> preventSave [
]

{ #category : #removing }
GtSmaCCRenameAction >> removeAttributes [
	super removeAttributes.
	otherLocations keysDo: [ :editor | 
		editor text clearAttributes: [ :each | self isRenameAttribute: each ] ]
]

{ #category : #private }
GtSmaCCRenameAction >> undoChanges [
	self textElement text: originalText.
	self textEditor moveCursorTo: originalCursorPosition
]

{ #category : #private }
GtSmaCCRenameAction >> updateEditor: editor intervals: intervals [
	| newText index |
	newText := '' asRopedText.
	index := 1.
	intervals do: [ :each | 
		each first = 1
			ifTrue: [ newText := newText , self newName asRopedText ]
			ifFalse: [ 
				newText := newText
				           , (editor text copyFrom: index to: each first - 1)
				           , self newName asRopedText ].
		index := each last + 1 ].
	index > editor text size ifFalse: [ 
		newText := newText
		           , (editor text copyFrom: index to: editor text size) ].
	editor text: newText
]

{ #category : #actions }
GtSmaCCRenameAction >> updateName: blText [
	otherRenameAttributes do: [ :each | each updateText: blText ].
	super updateName: blText
]

{ #category : #private }
GtSmaCCRenameAction >> updateSource [
	self newName = self originalName ifTrue: [ ^ self removeAttributes ].
	self updateEditor: self textEditor intervals: originalLocations.
	self updateCursorLocation.
	otherLocations keysAndValuesDo: [ :editor :intervals | 
		self updateEditor: editor intervals: intervals ]
]
