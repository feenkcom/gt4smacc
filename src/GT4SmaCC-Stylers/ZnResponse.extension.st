Extension { #name : #ZnResponse }

{ #category : #'*GT4SmaCC-Stylers' }
ZnResponse >> gtJsonFor: aView [
	<gtView>
	self isSuccess ifFalse: [ ^ aView empty ].
	self contentType main = 'application' ifFalse: [ ^ aView empty ].
	self contentType sub = 'json' ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'JSON';
		priority: 10;
		stencil: [ | editorElement textEditor text |
			textEditor := BrTextEditor new.
			textEditor styler: JSONParser gtStyler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := (STONJSON toStringPretty: (STONJSON fromString: self contents)) asRopedText.
			text
				attributes: {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler}.
			textEditor text: text.
			editorElement
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement ]
]
