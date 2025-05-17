Class {
	#name : #GtSmaCCPatternElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'model'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-UI'
}

{ #category : #private }
GtSmaCCPatternElement >> connectToModel [
	model ifNil: [ ^ self ].
	model announcer weak
		when: #source
		send: #updatePattern
		to: self
]

{ #category : #private }
GtSmaCCPatternElement >> disconnectFromModel [
	model ifNil: [ ^ self ].
	model announcer unsubscribe: self
]

{ #category : #initalization }
GtSmaCCPatternElement >> initialize [
	| editor |
	super initialize.
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		aptitude: BrGlamorousCodeEditorAptitude + BrGlamorousEditorSearchTextAptitude;
		beEditable;
		padding: (BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
		matchParent.
	editor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | model ifNotNil: [ model source: editor editor text asString ] ].
	self padding: (BlInsets all: 5).
	self matchParent.
	self addChild: editor as: #pattern
]

{ #category : #accessing }
GtSmaCCPatternElement >> model [
	^ model
]

{ #category : #accessing }
GtSmaCCPatternElement >> model: anObject [
	self disconnectFromModel.
	model := anObject.
	self connectToModel.
	self updateUI
]

{ #category : #'as yet unclassified' }
GtSmaCCPatternElement >> patternStyler [
	^ (GtSmaCCParserStyler forParser: SmaCCReplaceExpressionParser)
		stylerRules: {GtSmaCCNodeStylerRule
					nodeClassName: #SmaCCNodeReplaceExpression
					styleBlock: [ :s | 
						s
							foreground: BrGlamorousColors linkColor;
							bold ]}
]

{ #category : #private }
GtSmaCCPatternElement >> updatePattern [
	self
		inUIProcessDo: [ self
				childNamed: #pattern
				ifFound: [ :editor | 
					self patternStyler ifNotNil: [ :styler | editor styler: styler ].
					editor text: model source asRopedText ] ]
]

{ #category : #private }
GtSmaCCPatternElement >> updateUI [
	self updatePattern
]
