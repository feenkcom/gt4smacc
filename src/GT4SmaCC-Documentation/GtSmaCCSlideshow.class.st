Class {
	#name : 'GtSmaCCSlideshow',
	#superclass : 'GtSmaCCSlides',
	#category : 'GT4SmaCC-Documentation'
}

{ #category : 'private' }
GtSmaCCSlideshow >> addButtonFor: coderElement [
	^ coderElement
		allChildrenBreadthFirstDetect:
			[ :aChild | (aChild isKindOf: BrToolbar) and: [ aChild parent isKindOf: GtCoderToolbarElement ] ]
		ifFound: [ :aChild | aChild childAt: 4 ]
]

{ #category : 'create parser slide' }
GtSmaCCSlideshow >> createSlideElement [
	| coderElement buttonTarget |
	coderElement := BlUseAsyncFeatures disableDuring: [ GtCoder new createInPager maximized ].
	buttonTarget := self addButtonFor: coderElement.
	buttonTarget addChild: ((self yellowExplanationTargetCircleFor: #addButton) relocate: 2 @ 10).
	^ (BlElement new)
		constraintsDo:
				[ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
		aptitude: BrShadowAptitude;
		background: Color white;
		margin: (BlInsets all: 5);
		padding: (BlInsets all: 5);
		addChild: coderElement
]

{ #category : 'create parser slide' }
GtSmaCCSlideshow >> createSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 2;
		newTextWithFormat: self createSlideText;
		element: [ self createSlideElement ];
		elementWeight: 0.6;
		onEveryAddToSceneGraphDo:
				[ :anElement | 
					| coderElement button |
					coderElement := anElement childAt: 2.
					coderElement
						enqueueTask:
							(BlTaskAction new
								action:
									[ button := self addButtonFor: coderElement.
									BlSpace simulateClickOn: button ]) ]
]

{ #category : 'create parser slide' }
GtSmaCCSlideshow >> createSlideText [
	^ ('To create a SmaCC parser, click the ' asRopedText , ('+' asRopedText glamorousExplanationFor: #addButton)
		,
			' and select the SmaCC tab.  Enter the class names for the new parser and scanner classes as well as the package where they should be saved.'
				asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'debugger slide' }
GtSmaCCSlideshow >> debuggerSlideElement [
	<gtExample>
	
	| session element |
	session := self
		startDebuggerOn:
			'{
  "colors": [
    {
      "color": "black",
      "code": {
        "rgba": [255,255,255,1],
        "hex": "#000"
      }
    },
    {
      "color": "white",
      "code": {
        "rgba": [0,0,0,1],
        "hex": "#FFF"
      }
    }
   ]
}'
		in: JSONParser.
	element := GtSmaCCDebuggerElement on: session.
	element
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action:
						[ element
								childNamed: #parserStack
								ifFound: [ :each | each addChild: ((self yellowExplanationTargetCircleFor: #parserStack) relocate: 2 @ 8) ].
							element
								childNamed: #parserActions
								ifFound: [ :each | each addChild: ((self yellowExplanationTargetCircleFor: #parserActions) relocate: 2 @ 8) ].
							element
								childNamed: #source
								ifFound:
									[ :each | each parent addChild: ((self yellowExplanationTargetCircleFor: #parserSource) relocate: 2 @ 8 + each position) ].
							element
								childNamed: #toolbar
								ifFound:
									[ :each | 
									each
										allChildrenDepthFirstDo:
											[ :child | 
											((child isKindOf: BrButton) and: [ child label asString ~= '' ])
												ifTrue:
													[ child addChild: ((self yellowExplanationTargetCircleFor: child label asString asSymbol) relocate: 2 @ 8) ] ] ] ]).
	^ element
]

{ #category : 'debugger slide' }
GtSmaCCSlideshow >> debuggerSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 40;
		newTextWithFormat: self debuggerSlideText;
		element: [ self debuggerSlideElement ];
		elementWeight: 0.6
]

{ #category : 'debugger slide' }
GtSmaCCSlideshow >> debuggerSlideText [
	^ ('SmaCC defines a custom debugger for parsers. If a debugger opens while parsing, there will be a SmaCCParser button at the top of the window. Selecting that button, switches to the SmaCC debugger. The SmaCC debugger shows the parser''s '
		asRopedText , ('stack' asRopedText glamorousExplanationFor: #parserStack) , ', the potential ' asRopedText
		, ('actions' asRopedText glamorousExplanationFor: #parserActions)
		, ' that the parser can perform, and the parser''s ' asRopedText
		, ('input' asRopedText glamorousExplanationFor: #parserSource) , '.' asRopedText , String cr asRopedText
		, 'You can use the ' asRopedText , ('Through Action' asRopedText glamorousExplanationFor: #'Through Action')
		, ' button to step until the next shift or reduce action is performed. The ' asRopedText
		, ('Into Reduce' asRopedText glamorousExplanationFor: #'Into Reduce')
		,
			' button steps until the parser starts to perform the reduction action for a production. This allows you to debug the code expressions defined in your parser. The '
				asRopedText , ('Next Token' asRopedText glamorousExplanationFor: #'Next Token')
		,
			' button steps until the next token is returned from the scanner. Finally, the last two buttons step until a character is processed by the scanner. The '
				asRopedText , ('Step Next Character' asRopedText glamorousExplanationFor: #'Step Next Character')
		, ' button steps until the scanner processes the next character from the input, and the ' asRopedText
		, ('Step to Cursor' asRopedText glamorousExplanationFor: #'Step to Cursor')
		, ' steps until the scanner processes the character at the cursor''s position in the ' asRopedText
		, ('input' asRopedText glamorousExplanationFor: #parserSource)
		, '. This can be used for skipping to the location where an error is occurring.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'coder explanation slide' }
GtSmaCCSlideshow >> explanationSlideElement [
	<gtExample>
	
	| coderElement |
	coderElement := self createParserCoderOn: LineParser.
	self addCommonExplanationTargetsFor: coderElement.
	coderElement
		allChildrenDepthFirstDo:
			[ :each | 
			(each isKindOf: GtSmaCCCoderElement)
				ifTrue:
					[ each coder isProductionRule
						ifTrue: [ each addChild: ((self yellowExplanationTargetCircleFor: #productions) relocate: 2 @ 8) ].
					each coder isTokenRule ifTrue: [ each addChild: ((self yellowExplanationTargetCircleFor: #tokens) relocate: 2 @ 8) ].
					each coder isDirective ifTrue: [ each addChild: ((self yellowExplanationTargetCircleFor: #directives) relocate: 2 @ 8) ] ] ].
	^ coderElement
]

{ #category : 'coder explanation slide' }
GtSmaCCSlideshow >> explanationSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 1;
		newTextWithFormat: self explanationSlideText;
		element: [ self explanationSlideElement ];
		elementWeight: 0.6
]

{ #category : 'coder explanation slide' }
GtSmaCCSlideshow >> explanationSlideText [
	^ ('Browsing a SmaCC parser class in coder displays a special ' asRopedText
		, ('grammar' asRopedText glamorousExplanationFor: #GrammarTab) , ' tab that displays the parser''s ' asRopedText
		, ('productions' asRopedText glamorousExplanationFor: #productions) , ', ' asRopedText
		, ('tokens' asRopedText glamorousExplanationFor: #tokens) , ', and ' asRopedText
		, ('directives' asRopedText glamorousExplanationFor: #directives)
		,
			' as individual editable items.

New items can be added to the grammar by using the ' asRopedText , ('+' asRopedText glamorousExplanationFor: #addButton)
		, ' dropdown.  When finished editing the grammar, you can ' asRopedText , ('save' asRopedText glamorousExplanationFor: #saveButton)
		, ' the grammar to the parser and scanner classes.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'filter slide' }
GtSmaCCSlideshow >> filterSlideElement [
	<gtExample>
	
	| coderElement coderList textSearch toggles |
	coderElement := self createParserCoderOn: JSONParser.
	coderElement
		allChildrenBreadthFirstDetect: [ :each | each isKindOf: GtFilterTagElement ]
		ifFound: [ :each | coderList := each ].
	textSearch := coderElement childNamed: #textSearch.
	textSearch parent addChild: ((self yellowExplanationTargetCircleFor: #textSearch) relocate: 2 @ textSearch extent y / 2).
	toggles := coderElement childNamed: #toggles.
	toggles children first addChild: ((self yellowExplanationTargetCircleFor: #production) relocate: 0 @ toggles height / 2).
	toggles children second addChild: ((self yellowExplanationTargetCircleFor: #token) relocate: 0 @ toggles height / 2).
	toggles children third addChild: ((self yellowExplanationTargetCircleFor: #directive) relocate: 0 @ toggles height / 2).
	coderElement
		allChildrenDepthFirstDo:
			[ :each | 
			(each isKindOf: GtSmaCCCoderElement)
				ifTrue:
					[ (each childNamed: #badges)
						ifNotNil:
							[ :badges | badges children notEmpty ifTrue: [ badges children first addChild: (self yellowExplanationTargetCircleFor: #badges) ] ] ] ].
	^ coderElement
]

{ #category : 'filter slide' }
GtSmaCCSlideshow >> filterSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 10;
		newTextWithFormat: self filterSlideText;
		element: [ self filterSlideElement ];
		elementWeight: 0.6
]

{ #category : 'filter slide' }
GtSmaCCSlideshow >> filterSlideText [
	^ ('When working with a large grammar, you need to be able to quickly search for items. First, you can filter the items by entering a '
		asRopedText , ('search string' asRopedText glamorousExplanationFor: #textSearch)
		, '. Also, you can limit the types of items displayed by using the  ' asRopedText
		, ('production' asRopedText glamorousExplanationFor: #production) , ', ' asRopedText
		, ('token' asRopedText glamorousExplanationFor: #token) , ', or ' asRopedText
		, ('directive' asRopedText glamorousExplanationFor: #directive) , ' toggles. Finally, you can use the ' asRopedText
		, ('badge toggles' asRopedText glamorousExplanationFor: #badges) , ' on the items.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'production simulator slide' }
GtSmaCCSlideshow >> productionSimulatorSlideElement [
	<gtExample>
	
	| coderElement |
	coderElement := self createParserCoderOn: JSONParser.
	(self findItem: 'value' in: coderElement)
		ifNotNil:
			[ :each | 
			| bar |
			each expand.
			bar := each childNamed: #actionBar.
			bar children first addChild: ((self yellowExplanationTargetCircleFor: #simulateButton) relocate: 2 @ 8).
			each coder viewParserSimulator: (each childNamed: #actionBar) children first ].
	coderElement
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action:
						[ (coderElement
								allChildrenBreadthFirstDetect: [ :each | each isKindOf: GtSmaCCParserSimulatorElement ]
								ifFound: [ :each | each ])
								ifNotNil:
									[ :each | 
									each addChild: ((self yellowExplanationTargetCircleFor: #testInput) relocate: 2 @ 8 + (each childNamed: #testInput) position).
									(each childNamed: #parseTree) addChild: ((self yellowExplanationTargetCircleFor: #parseTree) relocate: 2 @ 8) ] ]).
	^ coderElement
]

{ #category : 'production simulator slide' }
GtSmaCCSlideshow >> productionSimulatorSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 21;
		newTextWithFormat: self productionSimulatorSlideText;
		element: [ self productionSimulatorSlideElement ];
		elementWeight: 0.6
]

{ #category : 'production simulator slide' }
GtSmaCCSlideshow >> productionSimulatorSlideText [
	^ ('Like tokens, you can also test your production definitions without compiling by using the ' asRopedText
		, ('debug' asRopedText glamorousExplanationFor: #simulateButton)
		, ' button. Once pressed, you can test the token using the ' asRopedText
		, ('input field' asRopedText glamorousExplanationFor: #testInput) , '. As you enter text, the ' asRopedText
		, ('parse tree' asRopedText glamorousExplanationFor: #parseTree)
		, ' for the production is shown. The root item in the ' asRopedText
		, ('parse tree' asRopedText glamorousExplanationFor: #parseTree)
		,
			' will display the production''s name if the text can be parsed, Incomplete if the text is a prefix of a valid parse, or Error if the text cannot be parsed.'
				asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'testing slide' }
GtSmaCCSlideshow >> testingSlideElement [
	<gtExample>
	
	| coderElement |
	coderElement := self createParserCoderOn: JSONParser.
	self addCommonExplanationTargetsFor: coderElement.
	self switchToTab: 'Test' in: coderElement.
	coderElement
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action:
						[ coderElement
								childNamed: #parserTestInput
								ifFound: [ :each | each parent addChild: ((self yellowExplanationTargetCircleFor: #testInput) relocate: 2 @ 8) ].
							coderElement
								childNamed: #parserTestActions
								ifFound:
									[ :each | 
									each children first addChild: ((self yellowExplanationTargetCircleFor: #inspectButton) relocate: 2 @ 8).
									each children second addChild: ((self yellowExplanationTargetCircleFor: #debugButton) relocate: 2 @ 8) ] ]).
	^ coderElement
]

{ #category : 'testing slide' }
GtSmaCCSlideshow >> testingSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 30;
		newTextWithFormat: self testingSlideText;
		element: [ self testingSlideElement ];
		elementWeight: 0.6
]

{ #category : 'testing slide' }
GtSmaCCSlideshow >> testingSlideText [
	^ ('You can test your compiled parser by using the ' asRopedText , ('Test' asRopedText glamorousExplanationFor: #TestTab)
		, ' tab. Enter your expression you want to parse in the ' asRopedText
		, ('input field' asRopedText glamorousExplanationFor: #testInput) , '. You can ' asRopedText
		, ('inspect' asRopedText glamorousExplanationFor: #inspectButton) , ' the results of parsing the ' asRopedText
		, ('text' asRopedText glamorousExplanationFor: #testInput) , ', or you can ' asRopedText
		, ('debug' asRopedText glamorousExplanationFor: #debugButton) , ' the parse.' asRopedText)
		glamorousRegularFont;
		fontSize: 20
]

{ #category : 'token simulator slide' }
GtSmaCCSlideshow >> tokenSimulatorSlideElement [
	<gtExample>
	
	| coderElement |
	coderElement := self createParserCoderOn: JSONParser.
	(self findItem: '<string>' in: coderElement)
		ifNotNil:
			[ :each | 
			| bar |
			each expand.
			bar := each childNamed: #actionBar.
			bar children first addChild: ((self yellowExplanationTargetCircleFor: #simulateButton) relocate: 2 @ 8).
			each coder viewTokenSimulator: (each childNamed: #actionBar) children first ].
	coderElement
		enqueueTask:
			((BlDelayedTaskAction new)
				delay: 500 milliSeconds;
				action:
						[ (coderElement
								allChildrenBreadthFirstDetect: [ :each | each isKindOf: GtSmaCCTokenSimulatorElement ]
								ifFound: [ :each | each ])
								ifNotNil:
									[ :each | each addChild: ((self yellowExplanationTargetCircleFor: #testInput) relocate: 2 @ 8 + (each childNamed: #testInput) position) ] ]).
	^ coderElement
]

{ #category : 'token simulator slide' }
GtSmaCCSlideshow >> tokenSimulatorSlideFor: aSlide [
	<gtSlide>
	
	^ (aSlide textAndElement)
		priority: 20;
		newTextWithFormat: self tokenSimulatorSlideText;
		element: [ self tokenSimulatorSlideElement ];
		elementWeight: 0.6
]

{ #category : 'token simulator slide' }
GtSmaCCSlideshow >> tokenSimulatorSlideText [
	^ ('You can test your token definition regular expressions without compiling the grammar by using the ' asRopedText
		, ('debug' asRopedText glamorousExplanationFor: #simulateButton)
		, ' button. Once pressed, you can test the token using the ' asRopedText
		, ('input field' asRopedText glamorousExplanationFor: #testInput)
		,
			'. As you enter characters the matched parts in the regular expression are underlined. If the entered text does not match, then the character that did not match and all future characters are underlined.'
				asRopedText)
		glamorousRegularFont;
		fontSize: 20
]
