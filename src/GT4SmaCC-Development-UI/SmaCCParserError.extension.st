Extension { #name : #SmaCCParserError }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParserError >> gtDisplayErrorIn: aBrTextEditor [
	| index |
	index := (self tag position - 1 max: 1) min: aBrTextEditor text size.
	(aBrTextEditor text from: index to: index)
		attributes: { (GtSourceCoderErrorAttribute for: self description) }.
	aBrTextEditor moveCursorTo: index
]
