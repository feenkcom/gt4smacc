Class {
	#name : #GtSmaCCGrammarCoderElement,
	#superclass : #GtSmaCCListCoderElement,
	#category : 'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCGrammarCoderElement >> coderListElementClass [
	^ GtSmaCCCoderListElement
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> compilationBar [
	| element |
	element := super compilationBar.
	element addChild: self flagsElement.
	^ element
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> flagsElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element margin: (BlInsets top: 3).
	element
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	element
		addChild: (self toggleButton: 'GLR' activated: #isGLR)
		as: #glr.
	element
		addChild:
			(self toggleButton: 'Case insentive' activated: #isCaseInsensitive)
		as: #caseInsensitive.
	element
		addChild: (self toggleButton: 'Unicode' activated: #isUnicode)
		as: #unicode.
	^ element
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> group [
	^ grammarCoder group
]

{ #category : #private }
GtSmaCCGrammarCoderElement >> showErrors [
	| list |
	list := self childNamed: #list.
	list filterErrors
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> toggleButton: aString activated: aSymbol [
	| toggle |
	toggle := BrToggle new
		layout: BlLinearLayout horizontal alignCenter;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical exact: 20.
			c padding: (BlInsets all: 6) ];
		activated: (grammarCoder perform: aSymbol);
		margin:
			(BlInsets
				top: 0
				left: 2
				bottom: 0
				right: 2);
		constraintsDo: [ :c | 
			c frame horizontal alignRight.
			c frame vertical alignTop ];
		label:
			(aString asRopedText
				attributes:
					{(BlFontSizeAttribute size: 12).
					(BlFontFamilyAttribute named: 'Source Sans Pro')});
		aptitude: BrGlamorousButtonLabelAptitude + BrGlamorousToggleBackgroundAptitude;
		when: BrToggleActivatedEvent
			do:
				[ :anEvent | grammarCoder perform: (aSymbol , ':') asSymbol with: true ];
		when: BrToggleDeactivatedEvent
			do:
				[ :anEvent | grammarCoder perform: (aSymbol , ':') asSymbol with: false ].
	^ toggle
]
