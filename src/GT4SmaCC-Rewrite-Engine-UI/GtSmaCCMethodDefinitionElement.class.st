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
		aptitude: BrGlamorousRegularEditorAptitude new;
		beEditable;
		padding:
				(BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10);
		matchParent.
	editor editor styler: self styler.
	editor editor when: BrTextEditorModifiedEvent do: [ :event | self sourceChanged ].
	self updateSource.
	self addChild: editor
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> sourceChanged [
	rewrite source: editor editor text asString
]

{ #category : #private }
GtSmaCCMethodDefinitionElement >> styler [
	^ BrRBTextStyler new
		classOrMetaClass: SmaCCRewriteMatchContext;
		yourself
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> update: aSymbol [
	aSymbol = #source ifTrue: [ self updateSource ].
	^ super update: aSymbol
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> updateSource [
	editor editor text asString = rewrite source ifTrue: [ ^ self ].
	editor editor text: rewrite source asRopedText
]
