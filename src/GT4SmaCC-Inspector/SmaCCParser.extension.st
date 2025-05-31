Extension { #name : #SmaCCParser }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParser >> buildMondrian: mondrian forStack: stack [
	| nodes root |
	root := self graphForStack: stack.
	nodes := root allNodes.
	mondrian nodes
		shape: [ :each | 
			BrLabel new
				padding: (BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10);
				text: each name asRopedText;
				aptitude: BrGlamorousLabelAptitude new;
				background: BrGlamorousColors neutralBackgroundColor;
				geometry: (BlRoundedRectangleGeometry cornerRadius: 8);
				border: (BlBorder
						paint: (each success
								ifTrue: [ Color green ]
								ifFalse: [ each isFollowed ifTrue: [ Color black ] ifFalse: [ Color lightGray ] ])
						width: 2) ];
		with: nodes.
	mondrian edges
		shape: [ :each | 
			BlManhattanLineElement new
				zIndex: 0;
				beFixedTo;
				fixedDistance: 10;
				cornerRadius: 10;
				border: (BlBorder paint: (Color black alpha: 0.5) width: 2) ];
		fromRightCenter;
		toLeftCenter;
		connectTo: [ :each | each followed ].
	mondrian edges
		shape: [ :each | 
			BlManhattanLineElement new
				zIndex: 0;
				beFixedTo;
				fixedDistance: 10;
				cornerRadius: 10;
				border: (BlBorder paint: (Color gray alpha: 0.5) width: 1) ];
		fromRightCenter;
		toLeftCenter;
		connectToAll: [ :each | each directLinks ].
	^ mondrian layout horizontalDominanceTree
		nodeDistance: 20;
		levelDistance: 30;
		reverse: false
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParser >> gtGraphViewIn: aView [
	<gtView>
	((self class class whichClassIncludesSelector: #transitionTable)
		>> #transitionTable) methodClass = SmaCCParser class ifTrue: [ ^ nil ].
	^ aView mondrian
		title: 'Graph';
		painting: [ :mondrian | 
			| stack |
			stack := stateStack ifNil: [ Array with: self class defaultStartingState ].
			self buildMondrian: mondrian forStack: stack ]
]
