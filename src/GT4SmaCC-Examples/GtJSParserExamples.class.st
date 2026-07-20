Class {
	#name : #GtJSParserExamples,
	#superclass : #GtSmaCCParserExamples,
	#category : #'GT4SmaCC-Examples-Parser'
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
GtJSParserExamples >> insertedSemicolonsAfterDeclarations [
	<gtExample>
	| ast |
	ast := JSParser parse: 'let a = 1
let b = 2'.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	self assert: ast items last class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #examples }
GtJSParserExamples >> invalidWhileExample [
	<gtExample>
	^ self fail: 'while (i < 10'
]

{ #category : #examples }
GtJSParserExamples >> noSemicolonInsertedBeforeArithmetic [
	<gtExample>
	| ast |
	ast := JSParser parse: 'total = 3
+ 4'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSExpressionStatementNode.
	^ ast
]

{ #category : #examples }
GtJSParserExamples >> noSemicolonInsertedBeforeCall [
	<gtExample>
	| ast |
	ast := JSParser parse: 'let func = Math.max
(1, 2)'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #examples }
GtJSParserExamples >> noSemicolonInsertedBeforeSquareBracket [
	<gtExample>
	| ast |
	ast := JSParser parse: 'let user = { name: "Alice" }
["name"]'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #examples }
GtJSParserExamples >> noSemicolonInsertedBeforeTemplateLiteral [
	<gtExample>
	| ast |
	ast := JSParser parse: 'v = String.raw
`Hello`'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSExpressionStatementNode.
	^ ast
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
GtJSParserExamples >> returnWithInsertedSemicolon [
	<gtExample>
	| ast |
	ast := self
			parse: 'if (a == 1) return
console.log(a)'.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSIfStatementNode.
	^ ast
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
