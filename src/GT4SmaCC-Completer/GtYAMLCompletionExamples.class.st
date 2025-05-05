Class {
	#name : #GtYAMLCompletionExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLCompletionExamples >> completeAtStartOfFile [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    street: 123 abc
' asRopedText.
	position := 0.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items size equals: 5.
	self
		assert: (items collect: #label) asSortedCollection asArray
				= #('addresses:' 'name:' 'phones:' 'primary:' 'test:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyFile [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items size equals: 5.
	self
		assert: (items collect: #label) asSortedCollection asArray
				= #('addresses:' 'name:' 'phones:' 'primary:' 'test:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyKey [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    street: 123 abc
' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items size > 0.
	self assert: ((items collect: #label) includes: 'phones:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyKeyAfterList [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
phones:
  - 
  ' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items size equals: 2.
	self
		assert: (items collect: #label) asSortedCollection asArray
		equals: #('isPrimary:' 'number:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyKeyInMiddle [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position endText |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    street: 123 abc
  ' asRopedText.
	endText := '
test: - one' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text , endText
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items isEmpty.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyKeyIndent [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position endText |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    ' asRopedText.
	endText := '
test: - one' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text , endText
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items size equals: 5.
	self assert: ((items collect: #label) includes: 'zip:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyKeyUnder [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position endText |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    street: 123 abc
    ' asRopedText.
	endText := '
test: - one' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text , endText
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items notEmpty.
	self assert: ((items collect: #label) includes: 'zip:').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyListValue [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
test:
  - 
  ' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 20) toArray wait.
	self assert: items size equals: 4.
	self assert: ((items collect: #label) includes: 'one').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeEmptyStringValues [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    isHome: ' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 5) toArray wait.
	self assert: items size equals: 2.
	self
		assert: (items collect: #label) asSortedCollection asArray
		equals: #('false' 'true').
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeInitialKey [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    str' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'street:'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeKeyBeforeOtherKeyValues [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position endText |
	strategy := self loadingCompletions.
	text := '
addresses:
  foo:
    is' asRopedText.
	endText := '
    street: 123 abc' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text , endText
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'isHome:'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> completeStringValues [
	<gtExample>
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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

{ #category : #'as yet unclassified' }
GtYAMLCompletionExamples >> keyMatchExample [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self loadingCompletions.
	strategy
		completer: (GtYAMLKeyMatchCompleter new defaultCompleter: strategy completer).
	strategy completer
		add: (GtYAMLBlockCompleter new
				name: '<something>';
				block: [ :string :pos | 
					{GtInsertTextCompletionAction
							labeled: string , '1'
							completion: '1'
							position: pos
							from: pos - string size + 1} ])
		forKey: 'something'.
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
	text := '
name: Testing
something: asdf' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: 'asdf1'.
	^ result
]

{ #category : #accessing }
GtYAMLCompletionExamples >> loadingCompletions [
	<gtExample>
	<return: #GtYAMLCompletionStrategy>
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
