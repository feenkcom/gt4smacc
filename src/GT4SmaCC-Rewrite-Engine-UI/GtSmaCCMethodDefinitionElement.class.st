Class {
	#name : #GtSmaCCMethodDefinitionElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#instVars : [
		'editor'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #ui }
GtSmaCCMethodDefinitionElement >> contentElement [
	editor text: rewrite source asRopedText.
	editor text attributes: self defaultTextAttributes.
	^ BrEditorElement new
		padding:
			(BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
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
	rewrite source: editor text asString
]

{ #category : #private }
GtSmaCCMethodDefinitionElement >> styler [
	^ BrRBTextStyler new
		classOrMetaClass: SmaCCRewriteMatchContext;
		yourself
]
