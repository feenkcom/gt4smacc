Class {
	#name : #GtTokenCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #accessing }
GtTokenCoder >> completionStrategy [
	^ owner tokenCompletionStrategy
]

{ #category : #accessing }
GtTokenCoder >> definitionName [
	^ originalAST isNil
		ifTrue: [ '' ]
		ifFalse: [ originalAST name source ]
]

{ #category : #ui }
GtTokenCoder >> gtSimulatorFor: aView [
	<gtView>
	^ aView explicit
		title: 'Simulator';
		priority: 1;
		stencil: [ self simulatorElement ]
]

{ #category : #testing }
GtTokenCoder >> isTokenRuleCoder [
	^ true
]

{ #category : #private }
GtTokenCoder >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForRegexRule
]

{ #category : #elements }
GtTokenCoder >> simulateUsing: simulator from: testerEditor index: anIndex [
	self sourceEditor
		styleTextAndAfterDo: [ testerEditor text
				clearAttributes: [ :each | each isKindOf: BlTextBackgroundAttribute ].
			simulator
				matchesOn: testerEditor text asString
				do: [ :index :nodes | 
					nodes isNil
						ifTrue: [ (testerEditor text from: index to: testerEditor text size)
								background: Color lightRed ]
						ifFalse: [ (index = anIndex and: [ nodes notEmpty ])
								ifTrue: [ | start |
									start := (nodes asArray first nodeOfType: SmaCCTokenRuleNode)
										startPosition - 1.
									nodes
										do: [ :each | 
											each
												testTokensDo: [ :token | 
													(self sourceEditor text
														from: token startPosition - start
														to: token stopPosition - start) background: Color green ] ] ] ] ].
			testerEditor text: testerEditor text ]
]

{ #category : #accessing }
GtTokenCoder >> simulator [
	^ self
		attributeNamed: #simulator
		ifAbsentPut: [ | definitionAST |
			definitionAST := owner sourceAST.
			SmaCCRegexSimulator
				on: definitionAST
				tokenName: self definitionName ]
]

{ #category : #elements }
GtTokenCoder >> simulatorElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element
		addChild:
			(BrLabel new
				text: 'Input:';
				look: BrGlamorousLabelLook new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	element addChild: self testElement.
	element
		addChild:
			(self asElement
				expand;
				yourself).
	^ element
]

{ #category : #'event handling' }
GtTokenCoder >> sourceChanged [
	super sourceChanged.
	owner updateTokenCompletions
]

{ #category : #ui }
GtTokenCoder >> styledName [
	| text |
	text := super styledName.
	GtSmaCCStyler formatTokenDefinition: text.
	^ text
]

{ #category : #elements }
GtTokenCoder >> testElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorDeletedEvent
			do: [ :anEvent | 
			self
				simulateUsing: self simulator
				from: editor
				index: anEvent fromIndex - 1 ];
		when: BrTextEditorInsertedEvent
			do: [ :anEvent | 
			self
				simulateUsing: self simulator
				from: editor
				index: anEvent index + 1 ].
	element := BrEditorElement new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element editor: editor.
	^ element
]
