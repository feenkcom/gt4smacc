Class {
	#name : #GtJSParserExamples,
	#superclass : #GtSmaCCParserExamples,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #examples }
GtJSParserExamples >> arrayLiteralExpressionExample [
	<gtExample>
	^ self parse: '[1, 2, 3].map(x => x * 2)'
]

{ #category : #examples }
GtJSParserExamples >> assignmentExpressionExample [
	<gtExample>
	^ self parse: 'total = subtotal + tax'
]

{ #category : #examples }
GtJSParserExamples >> binaryExpressionExample [
	<gtExample>
	^ self parse: 'count * (size - 1)'
]

{ #category : #examples }
GtJSParserExamples >> callExpressionExample [
	<gtExample>
	^ self parse: 'console.log("ready")'
]

{ #category : #examples }
GtJSParserExamples >> conditionalExpressionExample [
	<gtExample>
	^ self parse: 'ready ? start() : stop()'
]

{ #category : #examples }
GtJSParserExamples >> doWhileExample [
	<gtExample>
	^ self parse: 'do { i++; } while (i < 10);'
]

{ #category : #examples }
GtJSParserExamples >> forExample [
	<gtExample>
	^ self parse: 'for (let i = 0; i < 3; i++) console.log(i)'
]

{ #category : #examples }
GtJSParserExamples >> ifExample [
	<gtExample>
	^ self parse: 'if (ready) { doWork(); } else { handleError(); }'
]

{ #category : #examples }
GtJSParserExamples >> invalidWhileExample [
	<gtExample>
	^ self fail: 'while (i < 10'
]

{ #category : #examples }
GtJSParserExamples >> objectLiteralExpressionExample [
	<gtExample>
	^ self parse: '({ name: "Ada", id: 1 })'
]

{ #category : #private }
GtJSParserExamples >> parserClass [
	^ JSParser
]

{ #category : #examples }
GtJSParserExamples >> returnExample [
	<gtExample>
	^ self parse: 'function add(a, b) { return a + b; }'
]

{ #category : #examples }
GtJSParserExamples >> switchExample [
	<gtExample>
	^ self parse: 'switch (value) { case 1: break; default: value = 0; }'
]

{ #category : #examples }
GtJSParserExamples >> tryCatchFinallyExample [
	<gtExample>
	^ self parse: 'try { risky(); } catch (e) { handle(e); } finally { cleanup(); }'
]

{ #category : #examples }
GtJSParserExamples >> whileExample [
	<gtExample>
	^ self parse: 'while (i++ < 10) console.log("i < 10")'
]
