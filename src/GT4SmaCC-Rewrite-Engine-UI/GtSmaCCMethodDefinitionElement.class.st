Class {
	#name : #GtSmaCCMethodDefinitionElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#instVars : [
		'editor'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> contentElement [
	editor text: rewrite source asRopedText.
	editor text attributes: self defaultTextAttributes.
	^ BrEditorElement new
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		editor: editor;
		yourself
]

{ #category : #'initialize-release' }
GtSmaCCMethodDefinitionElement >> initialize [
	super initialize.
	editor := BrTextEditor new.
	editor styler: self styler.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ]
]

{ #category : #updating }
GtSmaCCMethodDefinitionElement >> sourceChanged [
]

{ #category : #private }
GtSmaCCMethodDefinitionElement >> styler [
	^ BrRBTextStyler new
		classOrMetaClass: SmaCCRewriteMatchContext;
		yourself
]
