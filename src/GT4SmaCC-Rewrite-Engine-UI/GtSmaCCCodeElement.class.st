Class {
	#name : #GtSmaCCCodeElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'model'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #accessing }
GtSmaCCCodeElement >> connectToModel [
	model ifNil: [ ^ self ].
	model announcer weak
		when: #code
		send: #updateCode
		to: self
]

{ #category : #accessing }
GtSmaCCCodeElement >> disconnectFromModel [
	model ifNil: [ ^ self ].
	model announcer unsubscribe: self
]

{ #category : #private }
GtSmaCCCodeElement >> format: aString [
	| ast |
	ast := RBParser parseExpression: aString onError: [ :e :p | ^ aString ].
	^ ast formattedCode
]

{ #category : #initialization }
GtSmaCCCodeElement >> initialize [
	| editor completionStrategy completionController |
	super initialize.
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		aptitude: BrGlamorousCodeEditorAptitude new;
		beEditable;
		padding: (BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
		matchParent.
	editor editor styler: self sourceStyler.
	editor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | self updateSourceFrom: editor ].
	editor
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryShiftF;
				action: [ | source |
					source := self format: editor editor text asString.
					model code: source.
					editor editor text: source asRopedText ]).
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: SmaCCRewriteMatchContext.
	completionStrategy isMethod: false.
	completionController := GtCompletionController
			on: editor
			strategy: completionStrategy.
	completionController install.
	self padding: (BlInsets all: 5).
	self matchParent.
	self addChild: editor as: #code
]

{ #category : #accessing }
GtSmaCCCodeElement >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCCodeElement >> model: anObject [
	self disconnectFromModel.
	model := anObject.
	self connectToModel.
	self updateUI
]

{ #category : #private }
GtSmaCCCodeElement >> sourceStyler [
	^ (GtCompositeSmaCCASTStyler forParser: GtPharoParser)
		startingState: GtPharoParser startingStateForMethodSequence;
		stylers:
				{GtSmaCCPharoStyler new.
						GtPharoDynamicHighlightStyler new};
		yourself
]

{ #category : #accessing }
GtSmaCCCodeElement >> updateCode [
	self
		inUIProcessDo: [ self
				childNamed: #code
				ifFound: [ :editor | editor text: model code asRopedText ] ]
]

{ #category : #private }
GtSmaCCCodeElement >> updateSourceFrom: editor [
	model ifNil: [ ^ self ].
	model code: editor editor text asString
]

{ #category : #accessing }
GtSmaCCCodeElement >> updateUI [
	self updateCode
]
