Class {
	#name : 'GtSmaCCBadgesAptitude',
	#superclass : 'BrAptitude',
	#instVars : [
		'definitionList',
		'badgeList'
	],
	#category : 'GT4SmaCC-Development-UI-Looks'
}

{ #category : 'initialization' }
GtSmaCCBadgesAptitude >> badgeToggles [
	| toggles |
	toggles := OrderedCollection new.
	widget coder badgeTypes
		do: [ :each | 
			(widget coder grammarItem perform: each last)
				ifTrue: [ toggles
						add:
							(BrToggle new
								layout: BlLinearLayout horizontal alignCenter;
								constraintsDo: [ :c | 
									c horizontal fitContent.
									c vertical exact: 16.
									c padding: (BlInsets all: 6) ];
								margin:
									(BlInsets
										top: 0
										left: 2
										bottom: 0
										right: 2);
								activated: (definitionList includesBadge: each last);
								label:
									(each first asRopedText
										attributes:
											{(BlFontSizeAttribute size: 12).
											(BlFontFamilyAttribute named: 'Source Sans Pro')});
								aptitude: BrGlamorousButtonLabelAptitude + BrGlamorousToggleBackgroundAptitude;
								when: BrToggleActivatedEvent
									do: [ :anEvent | definitionList addBadgeFilter: each last ];
								when: BrToggleDeactivatedEvent
									do: [ :anEvent | definitionList removeBadgeFilter: each last ];
								yourself) ] ].
	^ toggles
]

{ #category : 'accessing' }
GtSmaCCBadgesAptitude >> definitionList: anObject [
	definitionList := anObject
]

{ #category : 'initialization' }
GtSmaCCBadgesAptitude >> initialize [
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
	self
		addChangeAddChildAs: #(badges)
		with: [ badgeList
				removeChildren;
				addChildren: self badgeToggles;
				yourself ]
]
