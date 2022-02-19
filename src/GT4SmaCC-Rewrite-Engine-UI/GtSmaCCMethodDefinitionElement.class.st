Class {
	#name : #GtSmaCCMethodDefinitionElement,
	#superclass : #GtSmaCCAbstractRewriteElement,
	#instVars : [
		'editor'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'initialize-release' }
GtSmaCCMethodDefinitionElement >> build [
	super build.
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		hMatchParent;
		vFitContent;
		aptitude: BrGlamorousCodeEditorAptitude new;
		beEditable;
		padding:
				(BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10);
		matchParent.
	editor
		addShortcut:
			((BlShortcutWithAction new)
				combination: BlKeyCombination primaryShiftF;
				action: [ self format ]).
	editor editor styler: self styler.
	editor editor when: BrTextEditorModifiedEvent do: [ :event | self sourceChanged ].
	self updateSource.
	self addChild: editor
]

{ #category : #actions }
GtSmaCCMethodDefinitionElement >> format [
	| ast |
	ast := RBParser parseMethod: editor editor text asString onError: [ :e :p | ^ self ].
	rewrite source: ast formattedCode
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> sourceChanged [
	rewrite source: editor editor text asString
]

{ #category : #private }
GtSmaCCMethodDefinitionElement >> styler [
	^ (GtCompositeSmaCCASTStyler forParser: GtPharoParser)
		stylers: {GtSmaCCPharoStyler new};
		yourself
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> update: aSymbol [
	aSymbol = #source ifTrue: [ self updateSource ].
	^ super update: aSymbol
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> updateSource [
	editor text asString = rewrite source ifTrue: [ ^ self ].
	editor text: rewrite source asRopedText
]
