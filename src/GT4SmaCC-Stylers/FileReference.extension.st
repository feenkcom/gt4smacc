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
		look: BrGlamorousCodeEditorLook;
		text: [ self contents asRopedText ];
		actionDropdownButtonIcon: BrGlamorousVectorIcons hamburger
			content: [ | parsers menuItems |
			parsers := SmaCCParser allSubclasses
				select: [ :each | each fileExtensions includes: '.' , self extension ].
			menuItems := OrderedCollection new.
			parsers
				do: [ :each | 
					menuItems
						add:
							(GtCoderContextMenuAction new
								action:
										[ :ignore :button | button phlow spawnObject: (self smaCCParseUsing: each) ];
								title: 'Parse with ' , each name) ].
			GtCoderContextMenuContent new
				constraintsDo: [ :c | c horizontal matchParent ];
				items: menuItems;
				hMatchParent;
				vMatchParent ]
]
