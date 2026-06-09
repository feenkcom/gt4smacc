Class {
	#name : #GtSmaCCTransformationExampleScanner,
	#superclass : #SmaCCScanner,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #'generated-initialization' }
GtSmaCCTransformationExampleScanner class >> initializeKeywordMap [
	keywordMap := Dictionary new.
	#(#(29 'BEGIN' 18) #(29 'DO' 19) #(29 'ELSE' 20) #(29 'END' 21) #(29 'FUNCTION' 22) #(29 'IF' 23) #(29 'INPUT' 24) #(29 'PRINT' 25) #(29 'RETURN' 26) #(29 'THEN' 27) #(29 'WHILE' 28))
		do: [ :each | 
			(keywordMap at: each first ifAbsentPut: [ Dictionary new ])
				at: (each at: 2)
				put: each last ].
	^ keywordMap
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> emptySymbolTokenId [
	^ 60
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> errorTokenId [
	^ 61
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> keywordFor: aString [
	^ aString asUppercase
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scan1 [
	[ self step.
	currentCharacter == $'
		ifTrue: [ self recordMatch: #(33).
			self step.
			currentCharacter == $' ifTrue: [ ^ self scan1 ].
			^ self reportLastMatch ].
	true ] whileTrue
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scan2 [
	[ self step.
	currentCharacter == $`
		ifTrue: [ self recordMatch: #(34).
			self step.
			currentCharacter == $` ifTrue: [ ^ self scan2 ].
			^ self reportLastMatch ].
	true ] whileTrue
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForToken [
	self step.
	currentCharacter == $' ifTrue: [ ^ self scan1 ].
	currentCharacter == $( ifTrue: [ ^ self recordAndReportMatch: #(1) ].
	currentCharacter == $) ifTrue: [ ^ self recordAndReportMatch: #(2) ].
	currentCharacter == $* ifTrue: [ ^ self recordAndReportMatch: #(3) ].
	currentCharacter == $+ ifTrue: [ ^ self recordAndReportMatch: #(4) ].
	currentCharacter == $, ifTrue: [ ^ self recordAndReportMatch: #(5) ].
	currentCharacter == $- ifTrue: [ ^ self recordAndReportMatch: #(6) ].
	currentCharacter == $. ifTrue: [ ^ self recordAndReportMatch: #(7) ].
	currentCharacter == $/ ifTrue: [ ^ self scanForTokenX1 ].
	currentCharacter == $: ifTrue: [ ^ self scanForTokenX8 ].
	^ self scanForTokenX9
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX1 [
	self recordMatch: #(8).
	self step.
	currentCharacter == $/
		ifTrue: [ [ self recordMatch: #(30).
			self step.
			currentCharacter <= Character tab
				or: [ (currentCharacter between: Character pageUp and: Character newPage)
						or: [ currentCharacter >= (Character value: 14) ] ] ] whileTrue ].
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX2 [
	[ self recordMatch: #(29).
	self step.
	(currentCharacter between: $0 and: $9)
		or: [ (currentCharacter between: $A and: $Z)
				or: [ currentCharacter == $_ or: [ currentCharacter between: $a and: $z ] ] ] ]
		whileTrue
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX3 [
	self recordMatch: #(11).
	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #(12) ].
	currentCharacter == $> ifTrue: [ ^ self recordAndReportMatch: #(13) ].
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX4 [
	[ self recordMatch: #(31).
	self step.
	currentCharacter isSeparator or: [ currentCharacter == Character pageUp ] ]
		whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX5 [
	[ self recordMatch: #(32).
	self step.
	currentCharacter == $.
		ifTrue: [ self step.
			currentCharacter isDigit
				ifTrue: [ [ self recordMatch: #(32).
					self step.
					currentCharacter isDigit ] whileTrue ].
			^ self reportLastMatch ].
	currentCharacter isDigit ] whileTrue.
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX6 [
	self recordMatch: #(15).
	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #(16) ].
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX7 [
	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #(14) ].
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX8 [
	self step.
	currentCharacter == $= ifTrue: [ ^ self recordAndReportMatch: #(9) ].
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> scanForTokenX9 [
	currentCharacter == $; ifTrue: [ ^ self recordAndReportMatch: #(10) ].
	currentCharacter == $< ifTrue: [ ^ self scanForTokenX3 ].
	currentCharacter == $= ifTrue: [ ^ self scanForTokenX7 ].
	currentCharacter == $> ifTrue: [ ^ self scanForTokenX6 ].
	currentCharacter == $^ ifTrue: [ ^ self recordAndReportMatch: #(17) ].
	currentCharacter == $` ifTrue: [ ^ self scan2 ].
	currentCharacter isDigit ifTrue: [ ^ self scanForTokenX5 ].
	(currentCharacter isSeparator or: [ currentCharacter == Character pageUp ])
		ifTrue: [ ^ self scanForTokenX4 ].
	((currentCharacter between: $A and: $Z)
		or: [ currentCharacter between: $_ and: $z ]) ifTrue: [ self scanForTokenX2 ].
	^ self reportLastMatch
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> tokenActions [
	^ #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #comment #whitespace nil nil #patternToken)
]

{ #category : #generated }
GtSmaCCTransformationExampleScanner >> tokenClass [
	^SmaCCCaseInsensitiveToken
]
