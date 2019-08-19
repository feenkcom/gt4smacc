Class {
	#name : #GtSmaCCGrammarVariableCoderElement,
	#superclass : #GtSmaCCListCoderElement,
	#instVars : [
		'editType'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCGrammarVariableCoderElement >> coderListElementClass [
	^ GtSmaCCVariableListElement
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> editTypes [
	^ #(single same all)
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> editorsDo: aBlock [
	self
		allChildrenBreadthFirstDo: [ :each | 
			(each userData at: #variableNameAttribute ifAbsent: [ nil ]) notNil
				ifTrue: [ aBlock value: each ] ]
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> focusedEditor [
	self
		editorsDo: [ :each | 
			each focused
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
GtSmaCCGrammarVariableCoderElement >> group [
	^ grammarCoder variableGroup
]

{ #category : #'initialize-release' }
GtSmaCCGrammarVariableCoderElement >> initialize [
	super initialize.
	editType := #single.
	self
		addShortcut:
			(BlShortcut new
				combination:
					(BlCompulsoryCombination new
						withAll:
							{BlKeyCombination builder primary build.
							(BlSingleKeyCombination key: BlKeyboardKey t)});
				action: [ :each | self toggleNextRenaming ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlCompulsoryCombination new
						withAll:
							{BlKeyCombination builder primary shift build.
							(BlSingleKeyCombination key: BlKeyboardKey t)});
				action: [ :each | self togglePreviousRenaming ])
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> loseFocusFrom: anEditorElement [
	self editorsDo: [ :each | each background: Color white ]
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> toggleNextRenaming [
	| index |
	index := self editTypes indexOf: editType.
	index := index + 1.
	index > self editTypes size
		ifTrue: [ index := 1 ].
	editType := self editTypes at: index.
	self updateEditorBackgrounds
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> togglePreviousRenaming [
	| index |
	index := self editTypes indexOf: editType.
	index := index - 1.
	index < 1
		ifTrue: [ index := self editTypes size ].
	editType := self editTypes at: index.
	self updateEditorBackgrounds
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> updateEditorBackgrounds [
	| focused |
	focused := self focusedEditor.
	focused isNil
		ifTrue: [ ^ self ].
	self updateFocusTo: focused
]

{ #category : #private }
GtSmaCCGrammarVariableCoderElement >> updateFocusTo: anEditorElement [
	| testBlock |
	testBlock := editType = #single
		ifTrue: [ [ :each | each == anEditorElement ] ]
		ifFalse: [ editType = #all
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
GtSmaCCGrammarVariableCoderElement >> updateNameTo: newName from: initialName in: element [
	| testBlock |
	testBlock := editType = #single
		ifTrue: [ [ :each | each == element ] ]
		ifFalse: [ editType = #all
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
