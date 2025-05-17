Class {
	#name : #GtSmaCCPreviewElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'previewResult'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-UI'
}

{ #category : #accessing }
GtSmaCCPreviewElement >> addMenuItemsFor: aSymbol to: editorElement [
	| pragmas symbol parser options |
	parser := previewResult inputParserClass.
	parser isNil ifTrue: [ ^ self ].
	options := OrderedCollection new.
	symbol := #smaccTransformationToolkitMenu:for:parser:.
	pragmas := Pragma allNamed: symbol.
	pragmas
		do: [ :pragma | 
			(pragma selector = symbol
				and: [ pragma arguments second = aSymbol
						and: [ parser
								includesBehavior: (Smalltalk at: pragma arguments third ifAbsent: [ self class ]) ] ])
				ifTrue: [ options
						add: pragma arguments first
								-> [ pragma method methodClass instanceSide
										perform: pragma method selector
										with: editorElement
										with: self ] ] ].
	options isEmpty ifTrue: [ ^ self ].
	editorElement
		addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
				items: options)
]

{ #category : #accessing }
GtSmaCCPreviewElement >> annotationsInNewRanges: intervals [
	| items |
	items := IdentitySet new.
	intervals
		do: [ :each | items addAll: (previewResult transformedString annotationsInNewRange: each) ].
	^ items
		asSortedCollection: [ :a :b | a nodeInterval first < b nodeInterval first ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> annotationsInOriginalRanges: intervals [
	| items |
	items := IdentitySet new.
	intervals
		do: [ :each | items addAll: (previewResult transformedString annotationsInOriginalRange: each) ].
	^ items
		asSortedCollection: [ :a :b | a nodeInterval first < b nodeInterval first ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> debugRewrite: aSmaCCRewrite forNode: aClass at: anInterval [
	| block |
	aSmaCCRewrite ifNil: [ ^ self ].
	block := [ :rewrite :node | 
		rewrite == aSmaCCRewrite
			and: [ node class == aClass
					and: [ node startPosition = anInterval first
							and: [ node stopPosition = anInterval last ] ] ] ].
	self debugUsingSeachBlock: block andTransformationBlock: block
]

{ #category : #accessing }
GtSmaCCPreviewElement >> debugUsingSeachBlock: searchBlock andTransformationBlock: transformationBlock [
	self
		openResultFor: previewResult filename
		before: [ SmaCCRewriteMatch haltBlock: searchBlock.
			SmaCCRewriteTransformation haltBlock: transformationBlock ]
		after: [ SmaCCRewriteMatch haltBlock: nil.
			SmaCCRewriteTransformation haltBlock: nil ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> editorFor: aString parser: aClass [
	^ self
		editorFor: aString
		parser: aClass
		scrollToError: false
]

{ #category : #accessing }
GtSmaCCPreviewElement >> editorFor: aString parser: aClass scrollToError: aBoolean [
	| element index |
	element := BrEditor new.
	element
		aptitude: BrGlamorousCodeEditorAptitude + BrGlamorousEditorSearchTextAptitude;
		padding: (BlInsets all: 5);
		matchParent.
	element editor text: (aString ifNil: [ '' ]) asRopedText.
	aClass
		ifNotNil: [ aClass gtStyler ifNotNil: [ :styler | element editor styler: styler ] ].
	aBoolean
		ifTrue: [ [ aClass ifNotNil: [ aClass parse: aString ] ]
				on: SmaCCParserError
				do: [ :ex | 
					index := (ex parser position - 1 max: 1) min: aString size.
					(element editor text from: index to: index)
						attributes: {GtSourceCoderErrorAttribute for: ex messageText}.
					element editor moveCursorTo: index.
					element scrollToPosition: (aString lineNumberCorrespondingToIndex: index) ] ].
	^ element
]

{ #category : #accessing }
GtSmaCCPreviewElement >> editorWrapperFor: editorElement [
	| pane findText lineText updating |
	updating := false.
	pane := BrHorizontalPane new.
	pane
		padding: (BlInsets all: 3);
		hMatchParent;
		vFitContent.
	findText := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude new
					+ (BrStyleCommonAptitude new
							default: [ :aStyle | 
								aStyle
									border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1) ];
							focused: [ :aStyle | 
								aStyle
									border: (BlBorder paint: BrGlamorousColors focusedEditorBorderColor width: 1) ]);
			hMatchParent;
			vFitContent;
			addShortcut: (BlShortcutWithAction new
					combination: BlKeyCombination enter;
					action: [ self find: findText editor text asString in: editorElement ]).
	lineText := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude new
					+ (BrStyleCommonAptitude new
							default: [ :aStyle | 
								aStyle
									border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1) ];
							focused: [ :aStyle | 
								aStyle
									border: (BlBorder paint: BrGlamorousColors focusedEditorBorderColor width: 1) ]);
			hFitContent;
			vFitContent;
			text: '1';
			addShortcut: (BlShortcutWithAction new
					combination: BlKeyCombination enter;
					action: [ [ | string position line |
						updating := true.
						[ line := lineText editor text asString asNumber.
						string := editorElement editor text asString.
						position := string intervalOfLine: line.
						editorElement editor moveCursorTo: (position first - 1 max: 0).
						editorElement scrollToPosition: line.
						editorElement requestFocus ] ensure: [ updating := false ] ]
							on: Error
							do: [ :ex | ex return ] ]).
	self
		whenCursorEventsIn: editorElement editor
		do: [ :intervals | 
			(updating not and: [ intervals notEmpty ])
				ifTrue: [ lineText editor
						text: (editorElement editor text asString
								lineNumberCorrespondingToIndex: intervals first first) printString
								asRopedText glamorousRegularFont ] ].
	pane
		addChild: (BrLabel new
				text: 'Find:';
				padding: (BlInsets all: 3);
				aptitude: BrGlamorousLabelAptitude new);
		addChild: findText;
		addChild: (BrLabel new
				text: 'Line';
				padding: (BlInsets all: 3);
				aptitude: BrGlamorousLabelAptitude new);
		addChild: lineText;
		addChild: (BrLabel new
				text: '/' , editorElement editor text asString lineCount printString;
				padding: (BlInsets all: 3);
				aptitude: BrGlamorousLabelAptitude new).
	^ pane
]

{ #category : #accessing }
GtSmaCCPreviewElement >> find: aString in: editorElement [
	| editorString cursorPosition index |
	aString isEmpty ifTrue: [ ^ self ].
	editorString := editorElement editor text asString.
	editorElement editor cursors
		do: [ :each | cursorPosition := each position + 1 ].
	cursorPosition ifNil: [ cursorPosition := 1 ].
	index := editorString
			findString: aString
			startingAt: (cursorPosition min: editorString size)
			caseSensitive: false.
	(index = 0 and: [ cursorPosition > 1 ])
		ifTrue: [ index := editorString
					findString: aString
					startingAt: 1
					caseSensitive: false ].
	index > 0 ifFalse: [ ^ self ].
	editorElement selecter
		overwrite;
		from: index - 1 to: index + aString size - 1;
		select.
	editorElement editor moveCursorTo: index + aString size - 1.
	editorElement
		scrollToPosition: (editorString lineNumberCorrespondingToIndex: index)
]

{ #category : #accessing }
GtSmaCCPreviewElement >> gotoRewrite: aRewrite [
	self
		allParentsDetect: [ :each | each userData includesKey: #transformationToolkit ]
		ifFound: [ :each | (each userData at: #transformationToolkit) gotoRewrite: aRewrite ]
		ifNone: [ self phlow spawnObject: aRewrite ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> initialize [
	super initialize.
	self matchParent
]

{ #category : #accessing }
GtSmaCCPreviewElement >> lineNumberFor: anInteger in: aString [
	| stream |
	stream := SmaCCLineNumberStream on: aString readStream.
	stream position: anInteger.
	^ stream lineNumber
]

{ #category : #accessing }
GtSmaCCPreviewElement >> newPreviewFilesElement [
	^ (BrHorizontalPane new)
		matchParent;
		addChild: self newPreviewInputSourceElement;
		addChild: self newPreviewOutputSourceElement;
		yourself
]

{ #category : #accessing }
GtSmaCCPreviewElement >> newPreviewInputSourceElement [
	(previewResult isNil or: [ previewResult inputSource isNil ])
		ifTrue: [ ^ BlElement new ].
	^ BrTabGroup new
		aptitude: BrGlamorousWithHorizontalResizerAptitude new beRight
				+ BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 5);
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: self previewInputFilename;
				stencil: [ | editorElement |
					editorElement := self
							editorFor: previewResult inputSource
							parser: previewResult inputParserClass.
					self addMenuItemsFor: #previewInput to: editorElement.
					self
						whenCursorEventsIn: editorElement editor
						do: [ :intervals | self updatePreviewAnnotations: (self annotationsInOriginalRanges: intervals) ].
					BrVerticalPane new
						matchParent;
						addChild: editorElement asScrollableElement as: #inputSource;
						addChild: (self editorWrapperFor: editorElement);
						yourself ])
]

{ #category : #accessing }
GtSmaCCPreviewElement >> newPreviewOutputSourceElement [
	| tabGroup |
	(previewResult isNil or: [ previewResult outputSource isNil ])
		ifTrue: [ ^ BlElement new ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 5);
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: self previewOutputFilename;
				stencil: [ | editorElement |
					editorElement := self
							editorFor: previewResult outputSource
							parser: previewResult validationParserClass
							scrollToError: true.
					self
						whenCursorEventsIn: editorElement editor
						do: [ :intervals | self updatePreviewAnnotations: (self annotationsInNewRanges: intervals) ].
					BrVerticalPane new
						matchParent;
						addChild: editorElement asScrollableElement as: #outputSource;
						addChild: (self editorWrapperFor: editorElement);
						yourself ]).
	previewResult additionalFiles
		keysAndValuesDo: [ :key :value | 
			tabGroup
				addTab: (BrTab new
						aptitude: BrGlamorousTabAptitude new;
						label: key asFileReference basename;
						stencil: [ | editorElement |
							editorElement := self
									editorFor: value asString
									parser: previewResult validationParserClass
									scrollToError: true.
							BrVerticalPane new
								matchParent;
								addChild: editorElement asScrollableElement;
								addChild: (self editorWrapperFor: editorElement);
								yourself ]) ].
	^ tabGroup
]

{ #category : #accessing }
GtSmaCCPreviewElement >> newPreviewRulesElement [
	| list phlowList |
	phlowList := GtPhlowView new columnedList.
	phlowList column
		title: 'Rewrite';
		cellStencil: [ BrHorizontalPane new
				fitContent;
				addChild: (BrButton new
							aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
							label: '';
							action: [ :label | self gotoRewrite: (label userData at: #rewrite) ])
					as: #label;
				addChild: (BrButton new
							beSmallSize;
							aptitude: BrGlamorousButtonWithIconAptitude;
							label: 'Debug';
							icon: BrGlamorousVectorIcons debug asElement;
							margin: (BlInsets all: 2);
							action: [ :button | 
								| result |
								result := button userData at: #result.
								self
									debugRewrite: result rewrite
									forNode: result nodeClass
									at: result nodeInterval ])
					as: #button ];
		dataBinder: [ :pane :each | 
			| label |
			label := pane childNamed: #label.
			label label: each rewrite displayString.
			label userData at: #rewrite put: each rewrite.
			(pane childNamed: #button) userData at: #result put: each ].
	phlowList column: 'Node' text: [ :each | each nodeClass displayString ].
	list := (phlowList
			column: 'Location'
			text: [ :each | each nodeInterval first printString , '-' , each nodeInterval last printString ])
			asElement.
	list padding: (BlInsets all: 5).
	list border: (BlBorder paint: Color lightGray width: 1).
	(list childWithId: GtPhlowColumnedListId)
		when: BrSelectionChanged
		do: [ :event | 
			self
				updateEditorsForAnnotation: (event selectedInterval ifNotNil: [ :each | event target items at: each first ]) ].
	^ BlElement new
		height: 200;
		aptitude: BrGlamorousWithVerticalResizerAptitude new beTop;
		margin: (BlInsets
				top: 0
				left: 10
				bottom: 10
				right: 10);
		constraintsDo: [ :c | c horizontal matchParent ];
		addChild: list as: #previewRewrites;
		yourself
]

{ #category : #accessing }
GtSmaCCPreviewElement >> openResultFor: aFilename before: beforeBlock after: afterBlock [
	aFilename ifNil: [ ^ self ].
	[ | result |
	result := previewResult model
			previewResultFor: aFilename
			before: beforeBlock
			after: afterBlock
			onException: [  ].
	self previewResult: result ] fork
]

{ #category : #accessing }
GtSmaCCPreviewElement >> previewInputFilename [
	^ (previewResult notNil and: [ previewResult filename notNil ])
		ifTrue: [ previewResult filename asFileReference basename ]
		ifFalse: [ 'Input' ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> previewOutputFilename [
	^ (previewResult notNil and: [ previewResult outputFilename notNil ])
		ifTrue: [ previewResult outputFilename asFileReference basename ]
		ifFalse: [ 'Output' ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> previewResult [
	^ previewResult
]

{ #category : #accessing }
GtSmaCCPreviewElement >> previewResult: anObject [
	previewResult := anObject.
	self updateResult
]

{ #category : #accessing }
GtSmaCCPreviewElement >> updateEditorsForAnnotation: annotation [
	self
		childNamed: #inputSource
		ifFound: [ :element | 
			element editor text
				clearAttributes: [ :each | each class = GtSmaCCTransformedAttribute ].
			annotation
				ifNotNil: [ element editor text
						attributes: {GtSmaCCTransformedAttribute new}
						from: annotation nodeInterval first
						to: annotation nodeInterval last.
					element
						scrollToPosition: (self lineNumberFor: annotation nodeInterval first in: previewResult inputSource) ] ].
	self
		childNamed: #outputSource
		ifFound: [ :element | 
			element editor text
				clearAttributes: [ :each | each class = GtSmaCCTransformedAttribute ].
			annotation
				ifNotNil: [ | firstIndex |
					firstIndex := SmallInteger maxVal.
					(previewResult transformedString annotationRangesFor: annotation)
						do: [ :each | 
							firstIndex := firstIndex min: each first.
							element editor text
								attributes: {GtSmaCCTransformedAttribute new}
								from: each first
								to: each last ].
					firstIndex < SmallInteger maxVal
						ifTrue: [ element
								scrollToPosition: (self lineNumberFor: firstIndex in: previewResult outputSource) ] ] ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> updatePreviewAnnotations: aCollection [
	self
		childNamed: #previewRewrites
		ifFound: [ :element | 
			element children last
				deselectAll;
				items: aCollection ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> updateResult [
	self
		inUIProcessDo: [ self removeChildren.
			self addChild: self newPreviewFilesElement as: #previewFiles.
			self addChild: self newPreviewRulesElement ]
]

{ #category : #accessing }
GtSmaCCPreviewElement >> whenCursorEventsIn: editor do: aBlock [
	editor
		when: BrTextEditorEvent
		do: [ :event | 
			| intervals |
			intervals := OrderedCollection new.
			editor selection
				do: [ :each | each isNotEmpty ifTrue: [ intervals add: (each from + 1 to: each to) ] ].
			intervals isEmpty
				ifTrue: [ editor cursors
						do: [ :each | intervals add: (each position to: each position) ] ].
			aBlock value: intervals ]
]
