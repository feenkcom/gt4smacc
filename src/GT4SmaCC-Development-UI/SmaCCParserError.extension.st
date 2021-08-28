Extension { #name : 'SmaCCParserError' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCParserError >> gtDisplayErrorIn: aBrTextEditor [
	| index text string offset |
	index := (self tag position - 1 max: 1) min: aBrTextEditor text size.
	text := aBrTextEditor text.
	string := text asString.
	offset := 0.
	1 to: index - 1 do: [ :i | 
		((string at: i) = Character cr
			and: [ (string at: i + 1) = Character lf ])
			ifTrue: [ offset := offset + 1 ] ].
	index := index - offset.
	text
		clearAttributes: [ :each | each isKindOf: GtSourceCoderErrorAttribute ].
	(text from: index to: index)
		attributes: {(GtSourceCoderErrorAttribute for: self description)}.
	aBrTextEditor moveCursorTo: index
]
