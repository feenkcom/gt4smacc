Extension { #name : #FileReference }

{ #category : #'*GT-SmaCC-Stylers' }
FileReference >> gtStyledCodeFor: aView [
	<gtView>
	| parser styler |
	(self isFile
		and: [ (parser := SmaCCParser allSubclasses
				detect: [ :each | each fileExtensions includes: '.' , self extension ]
				ifNone: [  ]) notNil and: [ (styler := parser gtStyler) notNil ] ])
		ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Code';
		priority: 10;
		stencil: [ | editorElement textEditor text |
			textEditor := BrTextEditor new.
			textEditor styler: styler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := (self readStreamDo: [ :s | s contents ]) asRopedText.
			text
				attributes: {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler}.
			textEditor text: text.
			editorElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement ]
]
