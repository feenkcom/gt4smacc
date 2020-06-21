Class {
	#name : #GtTextNodeHighlighter,
	#superclass : #Object,
	#instVars : [
		'editor',
		'offsets'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #'instance creation' }
GtTextNodeHighlighter class >> on: anEditor source: aString [
	^ self new
		on: anEditor source: aString;
		yourself
]

{ #category : #accessing }
GtTextNodeHighlighter >> editorPositionFor: anInteger [
	| offset |
	offset := 0.
	offsets
		do: [ :each | 
			each key > anInteger
				ifTrue: [ ^ anInteger + offset ]
				ifFalse: [ offset := each value ] ].
	^ anInteger + offset
]

{ #category : #highlighting }
GtTextNodeHighlighter >> highlight: aNode with: anAttribute [
	| start stop |
	start := self editorPositionFor: aNode startPosition.
	stop := self editorPositionFor: aNode stopPosition.
	(editor text from: start to: stop) attributes: { anAttribute }
]

{ #category : #'initialize-release' }
GtTextNodeHighlighter >> on: anEditor source: aString [
	| offset |
	offset := 0.
	offsets := OrderedCollection new.
	1 to: aString size - 1 do: [ :i | 
		((aString at: i) == Character cr
			and: [ (aString at: i + 1) == Character lf ])
			ifTrue: [ offset := offset - 1.
				offsets add: i + 1 -> offset ] ].
	editor := anEditor
]

{ #category : #accessing }
GtTextNodeHighlighter >> stringPositionFor: anInteger [
	| offset |
	offset := 0.
	offsets
		do: [ :each | 
			each key + each value > anInteger
				ifTrue: [ ^ anInteger - offset ]
				ifFalse: [ offset := each value ] ].
	^ anInteger - offset
]
