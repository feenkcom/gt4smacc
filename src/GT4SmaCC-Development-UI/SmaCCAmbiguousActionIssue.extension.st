Extension { #name : #SmaCCAmbiguousActionIssue }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCAmbiguousActionIssue >> displayText [
	| stream glr |
	stream := BlTextStream new.
	glr := action grammar isGLR.
	action actions
		do: [ :each | 
			((glr not and: [ each == self preferredAction ])
				ifTrue: [ stream next bold ]
				ifFalse: [ stream next ]) print: each lr1Item printString.
			stream cr ].
	stream cr.
	self printPathOn: stream.
	^ stream contents
]
