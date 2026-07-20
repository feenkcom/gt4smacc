Class {
	#name : #GtJSParserExamples,
	#superclass : #GtSmaCCParserExamples,
	#category : #'GT4SmaCC-Examples-Parser'
}

{ #category : #'examples - semicolons' }
GtJSParserExamples >> adjacentAsyncFunctionDeclarationsExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'async function a() {}async function b() {}'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSAsyncFunctionNode.
	self assert: ast items second class equals: JSAsyncFunctionNode.
	^ ast
]

{ #category : #'examples - semicolons' }
GtJSParserExamples >> adjacentAsyncGeneratorDeclarationsExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'async function* a() {}async function* b() {}'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSAsyncGeneratorFunctionNode.
	self assert: ast items second class equals: JSAsyncGeneratorFunctionNode.
	^ ast
]

{ #category : #'examples - semicolons' }
GtJSParserExamples >> adjacentClassDeclarationsExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'class A {}class B {}'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSClassExpressionNode.
	self assert: ast items second class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - semicolons' }
GtJSParserExamples >> adjacentFunctionDeclarationsExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'function a() {}function b() {}'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSFunctionNode.
	self assert: ast items second class equals: JSFunctionNode.
	^ ast
]

{ #category : #'examples - semicolons' }
GtJSParserExamples >> adjacentGeneratorDeclarationsExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'function* a() {}function* b() {}'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSGeneratorFunctionNode.
	self assert: ast items second class equals: JSGeneratorFunctionNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> arrayDestructuringAssignmentExpressionExample [
	<gtExample>
	^ self parse: '([a, ...rest] = value)'
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> arrayDestructuringWithHolesExample [
	<gtExample>
	| ast |
	ast := self parse: 'const [a, , b, ...rest] = value;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> arrayLiteralExpressionExample [
	<gtExample>
	^ self parse: '[1, 2, 3].map(x => x * 2)'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> assignmentExpressionExample [
	<gtExample>
	^ self parse: 'a = 1'
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> asyncArrowDestructuredParamExample [
	<gtExample>
	| ast |
	ast := self parse: 'const f = async ({a, b}) => a + b;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> asyncArrowRestParamExample [
	<gtExample>
	^ self parse: 'async (...args) => args.length'
]

{ #category : #'examples - generators and async' }
GtJSParserExamples >> asyncGeneratorDeclarationExample [
	<gtExample>
	| ast |
	ast := self parse: 'async function* g() { yield await value; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSAsyncGeneratorFunctionNode.
	^ ast
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> asyncGeneratorMethodExample [
	<gtExample>
	| ast |
	ast := self parse: 'class A { async *g() { yield await value; } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #examples }
GtJSParserExamples >> asyncMethodComputedNameExample [
	<gtExample>
	| ast classNode |
	ast := self parse: 'class A { async [name]() { await work(); } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	classNode := ast items first.
	self assert: classNode elements size equals: 1.
	self assert: classNode elements first class equals: JSAsyncMethodDefinitionNode.
	self assert: classNode elements first name class equals: JSComputedPropertyNameNode.
	self assert: classNode elements first statements size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> bareImportAssertionExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import "./x.json" assert { type: "json" };'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> bareImportAttributesExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import "./x.json" with { type: "json" };'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> bigIntLiteralExample [
	<gtExample>
	^ self parse: 'const n = 123n;'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> binaryExpressionExample [
	<gtExample>
	^ self parse: '1 + 2 * 3'
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> breakWithAutomaticSemicolonInsertion [
	<gtExample>
	| ast block |
	ast := JSParser parse: 'while (true) { break
label: x = 1 }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSWhileStatementNode.
	block := ast items first statement.
	self assert: block class equals: JSBlockStatementNode.
	self assert: block statements size equals: 2.
	self assert: block statements first class equals: JSBreakStatementNode.
	self assert: block statements second class equals: JSLabelledStatementNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> callExpressionExample [
	<gtExample>
	^ self parse: 'foo(1, 2)'
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> classFieldsExample [
	<gtExample>
	^ self parse: 'class A { x = 1; static y = 2; }'
]

{ #category : #examples }
GtJSParserExamples >> computedFieldNameExample [
	<gtExample>
	| ast classNode |
	ast := self parse: 'class A { [name] = 1; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	classNode := ast items first.
	self assert: classNode elements size equals: 1.
	self assert: classNode elements first class equals: JSFieldDefinitionNode.
	self assert: classNode elements first variable class equals: JSComputedPropertyNameNode.
	self assert: classNode elements first value class equals: JSNumericLiteralNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> conditionalExpressionExample [
	<gtExample>
	^ self parse: 'a ? b : c'
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> continueWithAutomaticSemicolonInsertion [
	<gtExample>
	| ast block |
	ast := JSParser parse: 'while (true) { continue
label: x = 1 }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSWhileStatementNode.
	block := ast items first statement.
	self assert: block class equals: JSBlockStatementNode.
	self assert: block statements size equals: 2.
	self assert: block statements first class equals: JSContinueStatementNode.
	self assert: block statements second class equals: JSLabelledStatementNode.
	^ ast
]

{ #category : #'examples - decorators' }
GtJSParserExamples >> decoratedClassExample [
	<gtExample>
	| ast classNode |
	ast := self parse: '@sealed class A {}'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	classNode := ast items first.
	self assert: classNode decorators size equals: 1.
	^ ast
]

{ #category : #'examples - decorators' }
GtJSParserExamples >> decoratedFieldExample [
	<gtExample>
	| ast classNode |
	ast := self parse: 'class A { @tracked x = 1; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	classNode := ast items first.
	self assert: classNode elements size equals: 1.
	self assert: classNode elements first class equals: JSFieldDefinitionNode.
	self assert: classNode elements first decorators size equals: 1.
	self assert: classNode elements first decorators first class equals: JSDecoratorExpressionNode.
	^ ast
]

{ #category : #'examples - decorators' }
GtJSParserExamples >> decoratedMethodExample [
	<gtExample>
	| ast classNode |
	ast := self parse: 'class A { @logged m() {} }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	classNode := ast items first.
	self assert: classNode elements size equals: 1.
	self assert: classNode elements first class equals: JSMethodDefinitionNode.
	self assert: classNode elements first decorators size equals: 1.
	^ ast
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> defaultRestDestructuredParamsExample [
	<gtExample>
	| ast |
	ast := self parse: 'function f({a = 1}, ...rest) { return a; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSFunctionNode.
	^ ast
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> destructuredArrowWithDefaultsExample [
	<gtExample>
	^ self parse: '({a = 1, b: {c}}) => a + c'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> destructuringAssignmentExpressionExample [
	<gtExample>
	^ self parse: '({a, b} = value)'
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> destructuringForOfExample [
	<gtExample>
	| ast |
	ast := self parse: 'for (const [a, b] of values) { use(a, b); }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSForOfStatementNode.
	^ ast
]

{ #category : #'examples - statements' }
GtJSParserExamples >> doWhileExample [
	<gtExample>
	^ self parse: 'do { i++; } while (i < 10);'
]

{ #category : #'examples - modules' }
GtJSParserExamples >> exportDefaultAnonymousClassExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'export default class { static x = 1; }'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> exportDefaultArrowExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'export default (a, b) => a + b;'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> exportDefaultAsyncFunctionExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'export default async function f() { await g(); }'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> exportDefaultTaggedTemplateExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'export default tag`hello ${name}`;'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> exportNamedFromExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'export { foo as bar } from "./m.js";'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> exportNamespaceFromExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'export * as ns from "./m.js";'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - generators and async' }
GtJSParserExamples >> forAwaitDestructuringExample [
	<gtExample>
	| ast |
	ast := self parse: 'async function f() { for await (const [a, b] of values) { use(a, b); } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSAsyncFunctionNode.
	^ ast
]

{ #category : #'examples - generators and async' }
GtJSParserExamples >> forAwaitOfExample [
	<gtExample>
	^ self parse: 'async function f() { for await (const x of xs) { console.log(x) } }'
]

{ #category : #'examples - statements' }
GtJSParserExamples >> forExample [
	<gtExample>
	^ self parse: 'for (let i = 0; i < 10; i++) { console.log(i); }'
]

{ #category : #examples }
GtJSParserExamples >> generatorMethodComputedNameExample [
	<gtExample>
	| ast classNode |
	ast := self parse: 'class A { *[Symbol.iterator]() { yield 1; } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	classNode := ast items first.
	self assert: classNode elements size equals: 1.
	self assert: classNode elements first class equals: JSGeneratorMethodDefinitionNode.
	self assert: classNode elements first name class equals: JSComputedPropertyNameNode.
	self assert: classNode elements first statements size equals: 1.
	^ ast
]

{ #category : #'examples - statements' }
GtJSParserExamples >> ifExample [
	<gtExample>
	^ self parse: 'if (a) b(); else c();'
]

{ #category : #'examples - modules' }
GtJSParserExamples >> importAssertionExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import data from "./x.json" assert { type: "json" };'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> importAttributesExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import data from "./x.json" with { type: "json" };'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - imports' }
GtJSParserExamples >> importCallWithTrailingCommaExample [
	<gtExample>
	^ self parse: 'import("./m",)'
]

{ #category : #'examples - modules' }
GtJSParserExamples >> importDefaultAndNamedExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import def, { a as b, c } from "./m.js";'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> importMetaExample [
	<gtExample>
	^ JSParser parse: 'const url = import.meta.url;' startingAt: JSParser startingStateForModule
]

{ #category : #'examples - modules' }
GtJSParserExamples >> importNamespaceAliasExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import * as ns from "./m.js";'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
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

{ #category : #'examples - statements' }
GtJSParserExamples >> labeledLoopBreakContinueExample [
	<gtExample>
	| ast |
	ast := self parse: 'outer: for (const x of xs) { continue outer; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLabelledStatementNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> logicalAssignmentExample [
	<gtExample>
	^ self parse: 'a ||= b; c &&= d; e ??= f;'
]

{ #category : #'examples - modules' }
GtJSParserExamples >> multipleImportAssertionsExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import data from "./x.json" assert { type: "json", mode: "full" };'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> multipleImportAttributesExample [
	<gtExample>
	| ast |
	ast := JSParser
		parse: 'import data from "./x.json" with { type: "json", mode: "full" };'
		startingAt: JSParser startingStateForModule.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> multipleUsingDeclarationsExample [
	<gtExample>
	| ast |
	ast := self parse: 'using a = openA(), b = openB();'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> nestedArrayObjectDestructuringExample [
	<gtExample>
	| ast |
	ast := self parse: 'const [{a}, [b, ...rest]] = value;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> nestedObjectDestructuringExample [
	<gtExample>
	| ast |
	ast := self parse: 'const { a: { b }, c = 1 } = value;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> nestedTemplateInterpolationExample [
	<gtExample>
	^ self parse: '`${a + `${b}`}`'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> newMemberCallPrecedenceExample [
	<gtExample>
	^ self parse: 'new Foo().bar(baz)'
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> newTargetInFunctionExample [
	<gtExample>
	| ast |
	ast := self parse: 'function F() { return new.target; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSFunctionNode.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> noSemicolonInsertedBeforeArithmetic [
	<gtExample>
	| ast |
	ast := JSParser parse: 'total = 3
+ 4'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSExpressionStatementNode.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> noSemicolonInsertedBeforeCall [
	<gtExample>
	| ast |
	ast := JSParser parse: 'let func = Math.max
(1, 2)'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> noSemicolonInsertedBeforeSquareBracket [
	<gtExample>
	| ast |
	ast := JSParser parse: 'let user = { name: "Alice" }
["name"]'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> noSemicolonInsertedBeforeTemplateLiteral [
	<gtExample>
	| ast |
	ast := JSParser parse: 'v = String.raw
`Hello`'.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSExpressionStatementNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> nullishCoalescingExample [
	<gtExample>
	^ self parse: 'const result = value ?? fallback;'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> nullishWithConditionalExample [
	<gtExample>
	^ self parse: 'a ?? b ? c : d'
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> numericSeparatorBinaryExample [
	<gtExample>
	| ast |
	ast := self parse: 'const n = 0b1010_0101;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> numericSeparatorExample [
	<gtExample>
	| ast |
	ast := self parse: 'const n = 1_000_000;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> numericSeparatorHexExample [
	<gtExample>
	| ast |
	ast := self parse: 'const n = 0xFF_FF;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> numericSeparatorOctalExample [
	<gtExample>
	| ast |
	ast := self parse: 'const n = 0o12_34;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - destructuring' }
GtJSParserExamples >> objectDestructuringRestExample [
	<gtExample>
	| ast |
	ast := self parse: 'const {a, ...rest} = value;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> objectLiteralExpressionExample [
	<gtExample>
	^ self parse: '({ name: "Ada", id: 1 })'
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> optionalCatchBindingExample [
	<gtExample>
	^ self parse: 'try { work() } catch { recover() }'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> optionalChainCallIndexExample [
	<gtExample>
	^ self parse: 'obj?.foo?.(1)?.[key]'
]

{ #category : #examples }
GtJSParserExamples >> optionalChainNewTargetMixExample [
	<gtExample>
	| ast statement expression |
	ast := self parse: 'new foo?.bar?.baz()'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSExpressionStatementNode.
	statement := ast items first.
	expression := statement expression.
	self assert: expression class equals: JSNewExpressionNode.
	self assert: expression expression class equals: JSOptionalExpressionNode.
	self assert: expression arguments class equals: OrderedCollection.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> optionalChainingExample [
	<gtExample>
	^ self parse: 'const city = user?.address?.city;'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> optionalTaggedTemplateChainExample [
	<gtExample>
	^ self parse: 'tag?.`hello ${name}`'
]

{ #category : #'examples - parser class' }
GtJSParserExamples >> parserClass [
	^ JSParser
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> postfixDecrementLineBreakExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'i
--
j'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSExpressionStatementNode.
	self assert: ast items second class equals: JSExpressionStatementNode.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> postfixIncrementLineBreakExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'i
++
j'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSExpressionStatementNode.
	self assert: ast items second class equals: JSExpressionStatementNode.
	^ ast
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> privateFieldAccessChainExample [
	<gtExample>
	^ self parse: 'this.#x.y?.z'
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> privateFieldsExample [
	<gtExample>
	^ self parse: 'class A { #x = 1; getX() { return this.#x; } }'
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> privateMethodExample [
	<gtExample>
	| ast |
	ast := self parse: 'class A { #m() { return 1; } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> privateStaticMethodExample [
	<gtExample>
	| ast |
	ast := self parse: 'class A { static #m() { return 1; } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> regexpSetNotationExample [
	<gtExample>
	^ self parse: 'const re = /[a&&b]/v;'
]

{ #category : #'examples - statements' }
GtJSParserExamples >> returnExample [
	<gtExample>
	^ self parse: 'function add(a, b) { return a + b; }'
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> returnObjectLiteralNeedsAutomaticSemicolonInsertion [
	<gtExample>
	| ast |
	ast := JSParser parse: 'function f() { return
{ value: 1 } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSFunctionNode.
	^ ast
]

{ #category : #'examples - semicolon insertion' }
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

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> staticAsyncGeneratorMethodExample [
	<gtExample>
	| ast |
	ast := self parse: 'class A { static async *m() { yield 1; } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> staticBlockExample [
	<gtExample>
	^ self parse: 'class A { static { this.value = 1; } }'
]

{ #category : #'examples - classes and fields' }
GtJSParserExamples >> staticPrivateFieldExample [
	<gtExample>
	| ast |
	ast := self parse: 'class A { static #x = 1; }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> superComputedPropertyExample [
	<gtExample>
	| ast |
	ast := self parse: 'class B extends A { m() { return super[key]; } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> superMethodCallWithSpreadExample [
	<gtExample>
	| ast |
	ast := self parse: 'class B extends A { m() { return super.m(...args); } }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSClassExpressionNode.
	^ ast
]

{ #category : #'examples - statements' }
GtJSParserExamples >> switchExample [
	<gtExample>
	^ self parse: 'switch (value) { case 1: break; default: value = 0; }'
]

{ #category : #'examples - expressions' }
GtJSParserExamples >> taggedTemplateExample [
	<gtExample>
	^ self parse: 'tag`hello ${name}`'
]

{ #category : #'examples - semicolon insertion' }
GtJSParserExamples >> throwLineBreakRestrictionExample [
	<gtExample>
	| ast |
	ast := JSParser parse: 'function f() { throw
error }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSFunctionNode.
	^ ast
]

{ #category : #'examples - modules' }
GtJSParserExamples >> topLevelAwaitExample [
	<gtExample>
	^ JSParser parse: 'await fetch(url);' startingAt: JSParser startingStateForModule
]

{ #category : #'examples - statements' }
GtJSParserExamples >> tryCatchFinallyExample [
	<gtExample>
	^ self parse: 'try { work(); } catch (e) { recover(); } finally { cleanup(); }'
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> usingDeclarationExample [
	<gtExample>
	| ast |
	ast := self parse: 'using resource = open();'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - javascript' }
GtJSParserExamples >> usingDeclarationFollowedByConstExample [
	<gtExample>
	| ast |
	ast := self parse: 'using resource = open(); const x = 1;'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 2.
	self assert: ast items first class equals: JSLexicalDeclarationNode.
	self assert: ast items second class equals: JSLexicalDeclarationNode.
	^ ast
]

{ #category : #'examples - statements' }
GtJSParserExamples >> whileExample [
	<gtExample>
	^ self parse: 'while (i < 10) { i++; }'
]

{ #category : #'examples - generators and async' }
GtJSParserExamples >> yieldDelegationExample [
	<gtExample>
	| ast |
	ast := self parse: 'function* g() { yield* other(); }'.
	self assert: ast class equals: JSModuleNode.
	self assert: ast items size equals: 1.
	self assert: ast items first class equals: JSGeneratorFunctionNode.
	^ ast
]
