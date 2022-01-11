Class {
	#name : #GtSmaCCDropDownList,
	#superclass : #BrButton,
	#instVars : [
		'selectedItem',
		'items',
		'withDropdownLook'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'initialize-release' }
GtSmaCCDropDownList >> initialize [
	super initialize.
	items := #().
	self
		aptitude:
			BrGlamorousButtonWithLabelAptitude
				+
					(withDropdownLook := BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
								padding:
									(BlInsets
										top: 3
										left: 5
										bottom: 3
										right: 5);
								constraintsDo: [ :c | c minWidth: 150 ];
								label: (self labelFor: self selectedItem);
								yourself ]
						content: [ self popupList ]);
		padding:
			(BlInsets
				top: 3
				left: 5
				bottom: 3
				right: 5);
		constraintsDo: [ :c | c minWidth: 150 ];
		label: (self labelFor: self selectedItem)
]

{ #category : #accessing }
GtSmaCCDropDownList >> items [
	^ items
]

{ #category : #accessing }
GtSmaCCDropDownList >> items: aCollection [
	items := aCollection
]

{ #category : #private }
GtSmaCCDropDownList >> labelFor: anObject [
	^ anObject ifNil: [ '' ] ifNotNil: #displayString
]

{ #category : #private }
GtSmaCCDropDownList >> popupList [
	| list |
	list := BrSimpleList new.
	list vExact: 204.
	list hFitContent.
	list
		stencil:
			[ :each :index | 
			(BrLabel new)
				aptitude: BrGlamorousLabelAptitude new + BrGlamorousListItemAptitude;
				padding:
						(BlInsets
								top: 3
								left: 3
								bottom: 3
								right: 8);
				text: (self labelFor: each);
				hMatchParent;
				when: BlClickEvent
					do:
						[ :anEvent | 
							anEvent consumed: true.
							self selectedItem: each.
							list selectOne: index.
							withDropdownLook hide ];
				yourself ].
	list when: BrSelectionChanged do: [ :event | self dispatchEvent: event ].
	list items: self items.
	selectedItem notNil
		ifTrue:
			[ (list viewModel itemsProvider preloadUntilFoundSuchThat: [ :each | each = selectedItem ])
				then:
					[ :index | 
					index > 0
						ifTrue:
							[ self
								enqueueTask:
									(BlTaskAction new
										action:
											[ list selectOne: index.
											list scrollToIndex: index ]) ] ] ].
	^ list
]

{ #category : #accessing }
GtSmaCCDropDownList >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtSmaCCDropDownList >> selectedItem: anObject [
	selectedItem := anObject.
	self label: (self labelFor: selectedItem)
]
