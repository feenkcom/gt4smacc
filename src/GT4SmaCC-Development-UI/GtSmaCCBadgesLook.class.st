Class {
	#name : #GtSmaCCBadgesLook,
	#superclass : #BrLook,
	#instVars : [
		'definitionList',
		'badgeList'
	],
	#category : #'GT4SmaCC-Development-UI-Looks'
}

{ #category : #initialization }
GtSmaCCBadgesLook >> badgeToggles [
	| toggles |
	toggles := OrderedCollection new.
	widget coder badgeTypes
		do: [ :each | 
			(widget coder grammarItem perform: each last)
				ifTrue: [ toggles
						add:
							(BrToggle new
								margin: (BlInsets all: 2);
								constraintsDo: [ :c | 
									c frame horizontal alignRight.
									c frame vertical alignTop ];
								activated: (definitionList includesBadge: each last);
								label:
									(each first asRopedText
										attributes:
											{(BlFontSizeAttribute size: 12).
											(BlFontFamilyAttribute named: 'Source Sans Pro')});
								look: GtCategoryToggleLook;
								when: BrToggleActivatedEvent
									do: [ :anEvent | definitionList addBadgeFilter: each last ];
								when: BrToggleDeactivatedEvent
									do: [ :anEvent | definitionList removeBadgeFilter: each last ];
								yourself) ] ].
	^ toggles
]

{ #category : #accessing }
GtSmaCCBadgesLook >> definitionList: anObject [
	definitionList := anObject
]

{ #category : #initialization }
GtSmaCCBadgesLook >> initialize [
	super initialize.
	badgeList := BlElement new.
	badgeList layout: BlLinearLayout horizontal.
	badgeList margin: (BlInsets all: 0).
	badgeList
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent.
			c frame horizontal alignRight.
			c frame vertical alignTop ].
	changes
		add:
			(#(widget badges)
				asBrLookChildAddAsChangeWithValue: [ badgeList
						removeChildren;
						addChildren: self badgeToggles;
						yourself ])
]
