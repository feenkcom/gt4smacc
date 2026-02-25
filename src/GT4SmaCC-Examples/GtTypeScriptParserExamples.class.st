Class {
	#name : #GtTypeScriptParserExamples,
	#superclass : #GtSmaCCParserExamples,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #examples }
GtTypeScriptParserExamples >> enumDeclarationExample [
	<gtExample>
	^ self parse: 'enum Direction { Up, Down, Left, Right }'
]

{ #category : #examples }
GtTypeScriptParserExamples >> genericFunctionExample [
	<gtExample>
	^ self parse: 'function identity<T>(value: T): T { return value; }'
]

{ #category : #examples }
GtTypeScriptParserExamples >> implementsClauseExample [
	<gtExample>
	^ self parse: 'class Person implements Named { name: string; }'
]

{ #category : #examples }
GtTypeScriptParserExamples >> interfaceDeclarationExample [
	<gtExample>
	^ self parse: 'interface User { id: number; name?: string; readonly role: string }'
]

{ #category : #examples }
GtTypeScriptParserExamples >> namespaceDeclarationExample [
	<gtExample>
	^ self parse: 'namespace Geometry { export type Point = { x: number; y: number }; }'
]

{ #category : #accessing }
GtTypeScriptParserExamples >> parserClass [
	^ TypeScriptParser
]

{ #category : #examples }
GtTypeScriptParserExamples >> tupleTypeExample [
	<gtExample>
	^ self parse: 'let pair: [string, number] = ["age", 42]'
]

{ #category : #examples }
GtTypeScriptParserExamples >> typeAliasUnionExample [
	<gtExample>
	^ self parse: 'type Shape = Circle | Rectangle | Square'
]

{ #category : #examples }
GtTypeScriptParserExamples >> typeAssertionExample [
	<gtExample>
	^ self parse: 'let value = <string>someValue'
]
