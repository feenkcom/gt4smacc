Class {
	#name : #GtSmaCCDropDownList,
	#superclass : #BrDropdown,
	#instVars : [
		'labelBlock',
		'selectedItem',
		'items'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #private }
GtSmaCCDropDownList >> buttonLabel [
	^ self labelFor: self selectedItem
]

{ #category : #private }
GtSmaCCDropDownList >> dropDownButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		padding:
			(BlInsets
				top: 3
				left: 5
				bottom: 3
				right: 5);
		constraintsDo: [ :c | c minWidth: 150 ];
		label: self buttonLabel;
		yourself
]

{ #category : #'initialize-release' }
GtSmaCCDropDownList >> initialize [
	super initialize.
	items := #().
	labelBlock := [ :each | each displayString ].
	self layout: BlLinearLayout horizontal.
	self
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	self toggle: self toggleStencil.
	self popup: self popupStencil.
	self
		look:
			(BrDropdownLook new
				outskirtsEmbellisher: [ :e | e look: BrDropdownOutskirtsLook new ])
]

{ #category : #accessing }
GtSmaCCDropDownList >> items [
	^ items
]

{ #category : #accessing }
GtSmaCCDropDownList >> items: aCollection [
	items := aCollection.
	self popup: self popupStencil
]

{ #category : #accessing }
GtSmaCCDropDownList >> labelBlock [
	^ labelBlock
]

{ #category : #accessing }
GtSmaCCDropDownList >> labelBlock: aBlock [
	labelBlock := aBlock
]

{ #category : #private }
GtSmaCCDropDownList >> labelFor: anObject [
	^ anObject ifNil: [ '' ] ifNotNil: labelBlock
]

{ #category : #private }
GtSmaCCDropDownList >> popupList [
	| list |
	list := BrSimpleList new.
	list vExact: 200.
	list hFitContent.
	list
		stencil: [ :each :index | 
			BrLabel new
				look: BrGlamorousLabelLook new;
				padding: (BlInsets all: 5);
				text: (self labelFor: each);
				hMatchParent;
				when: BlClickEvent
					do: [ :anEvent | 
					anEvent consumed: true.
					self selectedItem: each.
					list selectOne: index.
					self collapse ];
				yourself ].
	list
		when: BrSelectionChanged
		do: [ :event | self dispatchEvent: event ].
	list items: self items.
	^ list
]

{ #category : #'initialize-release' }
GtSmaCCDropDownList >> popupStencil [
	^ [ self popupList ]
]

{ #category : #accessing }
GtSmaCCDropDownList >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtSmaCCDropDownList >> selectedItem: anObject [
	selectedItem := anObject.
	self toggle: self toggleStencil
]

{ #category : #'initialize-release' }
GtSmaCCDropDownList >> toggleStencil [
	^ [ self dropDownButton action: [ self toggle ] ]
]
