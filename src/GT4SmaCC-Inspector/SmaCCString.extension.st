Extension { #name : #SmaCCString }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCString >> gtIntervalListFor: aView [
	<gtView>

	^ aView mondrian
		title: 'Interval list';
		painting: [ :aMondrian | 
			aMondrian nodes
				stencil: [ :each | 
					BrLabel new
						aptitude: BrGlamorousLabelAptitude;
						text: (each printString allButFirst: 21);
						fitContent;
						border: (BlBorder paint: Color black) ];
				with: self safeAllIntervals.
			aMondrian edges
				stencil: [ :each | 
					BlParabollaArcElement new
						curvatureFraction: 0.3;
						border: (BlBorder paint: Color red);
						toHead: (BlArrowheadSimpleArrow new border: (BlBorder paint: Color red)) ];
				connectTo: #next.
			aMondrian edges
				stencil: [ :each | 
					BlParabollaArcElement new
						curvatureFraction: 0.3;
						border: (BlBorder paint: Color blue);
						toHead: (BlArrowheadSimpleArrow new border: (BlBorder paint: Color blue)) ];
				connectTo: #previous.
			aMondrian layout horizontal cellSpacing: 40  ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCString >> gtIntervalsFor: aView [
	<gtView>

	^ aView list 
		title: 'Intervals';
		items: self safeAllIntervals
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCString >> gtSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'String';
		stencil: [ | editor source |
			source := self asString asRopedText.
			editor := BrEditor new
				text: source;
				aptitude: BrGlamorousCodeEditorAptitude new.
			editor ]
]
