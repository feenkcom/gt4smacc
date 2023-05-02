Class {
	#name : #GtYAMLCompletionExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLCompletionExamples >> completeStringValues [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    isHome: f' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'false'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completionInsideOfFlowList [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
test: [one, f ]' asRopedText.
	position := text size - 2.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'four'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completionInsideOfList [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
phones:
  - num' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'number:'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completionInsideOfPattern [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    isH' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'isHome:'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completionOfLookupValue [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
name: something
addresses:
  aaa:
    city: someplace
  aba:
    state: NY
  aac:
    zip: 11111
primary: aa' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 2.
	self
		assert: (items collect: #label) asSortedCollection asArray
		equals: #('aaa' 'aac').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completionWithParseError [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
name: Testing
add' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'addresses:'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completionWithParseErrorInMiddle [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
name: something
addresses:
  foo:
    isHome: true
    st
    city: someplace' asRopedText.
	position := (text asString indexOfSubCollection: 'st') + 1.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 2.
	self
		assert: (items collect: #label) asSortedCollection asArray
		equals: #('state:' 'street:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> initialCompletion [
	<gtExample>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := 'add' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'addresses:'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> loadingCompletions [
	<gtExample>
	| strategy |
	strategy := GtYAMLCompletionStrategy new.
	strategy
		loadCompleterFrom: '
name:
addresses:
  <address>:
    isHome: true,false
    street:
    city:
    state:
    zip:
phones: - number:
          isPrimary: true,false
primary: <address>?
test: - one,two,three,four
'.
	^ strategy
]
