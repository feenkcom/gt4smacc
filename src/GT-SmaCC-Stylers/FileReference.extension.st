Extension { #name : #FileReference }

{ #category : #'*GT-SmaCC-Stylers' }
FileReference >> gtJavaFor: aView [
	<gtView>
	(self isFile and: [ self extension = 'java' ]) ifFalse: [ ^ aView empty ].
	^ aView explicit 
		title: 'Code';
		priority: 10;
		stencil: [
			| editorElement textEditor text |
			textEditor := BrTextEditor new.
			textEditor styler: JavaParser gtStyler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := (self readStreamDo: [ :s | s contents ]) asRopedText.
			text attributes: {
				BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler
			}.
			textEditor text: text.
			editorElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement
		]
]

{ #category : #'*GT-SmaCC-Stylers' }
FileReference >> gtJavascriptFor: aView [
	<gtView>
	(self isFile and: [ self extension = 'js' ]) ifFalse: [ ^ aView empty ].
	^ aView explicit 
		title: 'Code';
		priority: 10;
		stencil: [
			| editorElement textEditor text |
			textEditor := BrTextEditor new.
			textEditor styler: JSParser gtStyler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := (self readStreamDo: [ :s | s contents ]) asRopedText.
			text attributes: {
				BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler
			}.
			textEditor text: text.
			editorElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement
		]
]
