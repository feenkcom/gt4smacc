Extension { #name : #FileReference }

{ #category : #'*GT4SmaCC-Stylers' }
FileReference >> gtStyledCodeFor: aView [
	<gtView>
	| parser styler |
	(self isFile
		and: [ (parser := SmaCCParser allSubclasses
				detect: [ :each | each fileExtensions includes: '.' , self extension ]
				ifNone: [  ]) notNil and: [ (styler := parser gtStyler) notNil ] ])
		ifFalse: [ ^ aView empty ].
	"^ aView textEditor
		title: 'Code';
		priority: 10;
		styler: styler;
		look: BrGlamorousCodeEditorLook new;
		text: [ self contents asRopedText ]"
	^ aView explicit
		title: 'Code';
		priority: 10;
		stencil: [ | editorElement textEditor text |
			textEditor := BrTextEditor new.
			textEditor styler: styler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := self contents asRopedText.
			text glamorousCodeFontDo: #beNotOverwritableByStyler; glamorousCodeSizeDo: #beNotOverwritableByStyler.
			textEditor text: text.
			editorElement
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement ]
]
