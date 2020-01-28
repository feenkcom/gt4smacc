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
	^ aView textEditor
		title: 'Code';
		priority: 10;
		styler: styler;
		look: BrGlamorousCodeEditorLook new;
		text: [ self contents asRopedText ]
]
