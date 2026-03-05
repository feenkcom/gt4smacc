Class {
	#name : #GtSmaCCScannerExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #examples }
GtSmaCCScannerExamples >> anyCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : .;'.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: '1') equals: true.
	self assert: (simulator matchesString: Character lf asString) equals: true.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> boundedRepetition [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : 0{1,2};'.
	self assert: (simulator matchesString: '0') equals: true.
	self assert: (simulator matchesString: '00') equals: true.
	self assert: (simulator matchesString: '') equals: false.
	self assert: (simulator matchesString: '000') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> carriageReturnCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \r;'.
	self assert: (simulator matchesString: Character cr asString) equals: true.
	self assert: (simulator matchesString: 'r') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> characterIsMethod [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : <isLetter>;'.
	0
		to: 255
		do: [ :i | 
			self
				assert: (simulator matchesString: (Character value: i) asString)
				equals: (Character value: i) isLetter ].
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> characterRanges [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : [a-c];'.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: 'b') equals: true.
	self assert: (simulator matchesString: 'c') equals: true.
	self assert: (simulator matchesString: 'd') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> commentIgnored [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : a; # comment should be ignored'.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: 'b') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> controlCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \cA;'.
	self assert: (simulator matchesString: (Character value: 0) asString) equals: true.
	self assert: (simulator matchesString: 'A') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> digit [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \d;'.
	0
		to: 255
		do: [ :i | 
			self
				assert: (simulator matchesString: (Character value: i) asString)
				equals: ((Character value: i) between: $0 and: $9) ].
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> escapedDotCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \. ;'.
	self assert: (simulator matchesString: '.') equals: true.
	self assert: (simulator matchesString: 'a') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> formFeedCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \f;'.
	self assert: (simulator matchesString: Character newPage asString) equals: true.
	self assert: (simulator matchesString: 'f') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> hexCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \x20;'.
	self assert: (simulator matchesString: Character space asString) equals: true.
	self assert: (simulator matchesString: 'a') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> hexCharacterLong [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \x1FFF;'.
	self assert: (simulator matchesString: (Character value: 16r1FFF) asString) equals: true.
	self assert: (simulator matchesString: (Character value: 16r1FFE) asString) equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> lineFeedCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \n;'.
	self assert: (simulator matchesString: Character lf asString) equals: true.
	self assert: (simulator matchesString: 'n') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> negatedCharacterSet [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : [^a];'.
	self assert: (simulator matchesString: 'b') equals: true.
	self assert: (simulator matchesString: 'a') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> nonDigit [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \D;'.
	0
		to: 255
		do: [ :i | 
			self
				assert: (simulator matchesString: (Character value: i) asString)
				equals: ((Character value: i) between: $0 and: $9) not ].
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> nonWhitespaceCharacters [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \S;'.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: '1') equals: true.
	self assert: (simulator matchesString: ' ') equals: false.
	self assert: (simulator matchesString: Character tab asString) equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> nonWordCharacters [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \W;'.
	self assert: (simulator matchesString: '-') equals: true.
	self assert: (simulator matchesString: ' ') equals: true.
	self assert: (simulator matchesString: '_') equals: false.
	self assert: (simulator matchesString: 'a') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> optionalRepetition [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : a?;'.
	self assert: (simulator matchesString: '') equals: true.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: 'aa') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> repetitionAndAlternation [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : (ab|c)+;'.
	self assert: (simulator matchesString: 'ab') equals: true.
	self assert: (simulator matchesString: 'c') equals: true.
	self assert: (simulator matchesString: 'abc') equals: true.
	self assert: (simulator matchesString: 'ababc') equals: true.
	self assert: (simulator matchesString: '') equals: false.
	self assert: (simulator matchesString: 'ac') equals: false.
	^ simulator
]

{ #category : #private }
GtSmaCCScannerExamples >> simulatorFor: ruleString [
	| ast ruleName |
	ast := SmaCCDefinitionParser parse: ruleString.
	ast rules
		do: [ :each | each isTokenRule ifTrue: [ ruleName := each name value ] ].
	^ SmaCCRegexSimulator on: ast tokenName: ruleName
]

{ #category : #examples }
GtSmaCCScannerExamples >> tabCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \t;'.
	self assert: (simulator matchesString: Character tab asString) equals: true.
	self assert: (simulator matchesString: 't') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> tokenSubstitution [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<digit> : \d; <token> : <digit>+;'.
	self assert: (simulator matchesString: '1') equals: true.
	self assert: (simulator matchesString: '123') equals: true.
	self assert: (simulator matchesString: 'a') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> verticalTabCharacter [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \v;'.
	self assert: (simulator matchesString: (Character value: 11) asString) equals: true.
	self assert: (simulator matchesString: 'v') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> whitespaceCharacters [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \s;'.
	self assert: (simulator matchesString: ' ') equals: true.
	self assert: (simulator matchesString: Character tab asString) equals: true.
	self assert: (simulator matchesString: Character lf asString) equals: true.
	self assert: (simulator matchesString: Character cr asString) equals: true.
	self assert: (simulator matchesString: 'a') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> wordCharacters [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : \w;'.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: 'Z') equals: true.
	self assert: (simulator matchesString: '0') equals: true.
	self assert: (simulator matchesString: '_') equals: true.
	self assert: (simulator matchesString: '-') equals: false.
	^ simulator
]

{ #category : #examples }
GtSmaCCScannerExamples >> zeroOrMoreRepetition [
	<gtExample>
	| simulator |
	simulator := self simulatorFor: '<token> : a*;'.
	self assert: (simulator matchesString: '') equals: true.
	self assert: (simulator matchesString: 'a') equals: true.
	self assert: (simulator matchesString: 'aaa') equals: true.
	self assert: (simulator matchesString: 'b') equals: false.
	^ simulator
]
