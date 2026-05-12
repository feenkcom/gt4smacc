Class {
	#name : #GtKotlinParserExamples,
	#superclass : #GtSmaCCParserExamples,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #examples }
GtKotlinParserExamples >> annotationCombinationExample [
	<gtExample>
	^ self parse: '@Deprecated("old")
class Person'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetExample [
	<gtExample>
	^ self parse: 'class Person(@param:Inject val name: String)'
]

{ #category : #examples }
GtKotlinParserExamples >> asAndAsSafeExample [
	<gtExample>
	^ self parse: 'val a = x as String
val b = x as? String' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> blockBodiedFunctionExample [
	<gtExample>
	^ self parse: 'fun add(a: Int, b: Int): Int { return a + b }'
]

{ #category : #examples }
GtKotlinParserExamples >> classDeclarationExample [
	<gtExample>
	^ self parse: 'class Person(val name: String, var age: Int)'
]

{ #category : #examples }
GtKotlinParserExamples >> companionObjectExample [
	<gtExample>
	^ self parse: 'class Person { companion object { } }'
]

{ #category : #examples }
GtKotlinParserExamples >> constructorDelegationExample [
	<gtExample>
	^ self parse: 'class Child() : Parent(1), Runnable { }'
]

{ #category : #examples }
GtKotlinParserExamples >> delegatedPropertyExample [
	<gtExample>
	^ self parse: 'val name by lazy { "x" }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> destructuringForLoopExample [
	<gtExample>
	^ self parse: 'for ((a, b) in pairs) { println(a) }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> doWhileLoopExample [
	<gtExample>
	^ self parse: 'do { x += 1 } while (x < 10)' startingAt: KotlinParser startingStateForscript
]

{ #category : #private }
GtKotlinParserExamples >> fail: aString startingAt: aStartingState [
	^ [ self parserClass parse: aString startingAt: aStartingState.
	self assert: 'No error was raised' ]
		on: SmaCCParserError
		do: [ :ex | ^ ex freeze ]
]

{ #category : #examples }
GtKotlinParserExamples >> fileAnnotationExample [
	<gtExample>
	^ self parse: '@file:JvmName("Demo")
class Person'
]

{ #category : #examples }
GtKotlinParserExamples >> forLoopExample [
	<gtExample>
	^ self parse: 'for (x in items) { println(x) }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> functionWithIfExpressionExample [
	<gtExample>
	^ self parse: 'fun choose(ready: Boolean): Int = if (ready) { 1 } else { 2 }'
]

{ #category : #examples }
GtKotlinParserExamples >> functionWithWhenExpressionExample [
	<gtExample>
	^ self parse: 'fun describe(x: Int): String = when (x) { 1 -> "one" else -> "other" }'
]

{ #category : #examples }
GtKotlinParserExamples >> genericNestingExample [
	<gtExample>
	^ self parse: 'fun values(): Map<String, List<Int?>> = mapOf()'
]

{ #category : #examples }
GtKotlinParserExamples >> getterSetterExample [
	<gtExample>
	^ self parse: 'var name: String
	get() = field
	set(value) { field = value }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> ifExpressionExample [
	<gtExample>
	^ self parse: 'if (ready) { work() } else { rest() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> importAliasExample [
	<gtExample>
	^ self parse: 'import kotlin.collections.List as KList
class Person'
]

{ #category : #examples }
GtKotlinParserExamples >> infixFunctionCallExample [
	<gtExample>
	^ self parse: 'a to b' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> invalidAsExpressionExample [
	<gtExample>
	^ self fail: 'val x = y as' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> invalidFunctionExample [
	<gtExample>
	^ self fail: 'fun add(a: Int, b: Int): Int = '
]

{ #category : #examples }
GtKotlinParserExamples >> invalidGenericExample [
	<gtExample>
	^ self fail: 'fun bad(): List<String = listOf()'
]

{ #category : #examples }
GtKotlinParserExamples >> invalidIfExample [
	<gtExample>
	^ self fail: 'if (ready) { work() else { rest() }'
]

{ #category : #examples }
GtKotlinParserExamples >> invalidMultiLineStringExample [
	<gtExample>
	^ self fail: 'val text = """hello' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> isAndInOperatorsExample [
	<gtExample>
	^ self parse: 'if (x is String) { }
if (x !is String) { }
if (x in items) { }
if (x !in items) { }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> labeledBreakAndContinueExample [
	<gtExample>
	^ self parse: 'outer@ while (ready) {
	continue@outer
	break@outer
}' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> labeledReturnExample [
	<gtExample>
	^ self parse: 'run loop@ {
	return@loop
}' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> lambdaExample [
	<gtExample>
	^ self parse: 'val increment: (Int) -> Int = { x -> x + 1 }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> multiLineStringExample [
	<gtExample>
	^ self parse: 'val text = """hello
world"""' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> nullableGenericTypeExample [
	<gtExample>
	^ self parse: 'fun names(): List<String?> = listOf()'
]

{ #category : #examples }
GtKotlinParserExamples >> objectDeclarationExample [
	<gtExample>
	^ self parse: 'object Singleton { }'
]

{ #category : #examples }
GtKotlinParserExamples >> objectLiteralExample [
	<gtExample>
	^ self parse: 'val listener = object : Listener { }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> packageAndImportExample [
	<gtExample>
	^ self parse: 'package demo
import kotlin.collections.List
class Person'
]

{ #category : #accessing }
GtKotlinParserExamples >> parserClass [
	^ KotlinParser
]

{ #category : #examples }
GtKotlinParserExamples >> propertyDeclarationExample [
	<gtExample>
	^ self parse: 'val answer: Int = 42'
]

{ #category : #examples }
GtKotlinParserExamples >> qualifiedThisAndSuperExample [
	<gtExample>
	^ self parse: 'class Child : Parent() {
	fun test() {
		this@Child.toString()
		super.toString()
	}
}'
]

{ #category : #examples }
GtKotlinParserExamples >> receiverFunctionTypeExample [
	<gtExample>
	^ self parse: 'val f: String.() -> Int = { 1 }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> safeNavigationAndCallableReferenceExample [
	<gtExample>
	^ self parse: 'val name = person?.name
val ref = String::class' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptExample [
	<gtExample>
	^ self parse: 'val x = 1
x += 2
println(x)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptMultipleStatementsExample [
	<gtExample>
	^ self parse: 'val x = 1
x += 2
println(x)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptMultipleStatementsFailExample [
	<gtExample>
	^ self fail: 'val x = 1
x += 2
println(x)'
]

{ #category : #examples }
GtKotlinParserExamples >> scriptSinglePropertyExample [
	<gtExample>
	^ self parse: 'val x = 1' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> secondaryConstructorExample [
	<gtExample>
	^ self parse: 'class Person(val name: String) { constructor(): this("unknown") { } }'
]

{ #category : #examples }
GtKotlinParserExamples >> simpleFunctionExample [
	<gtExample>
	^ self parse: 'fun add(a: Int, b: Int): Int = a + b'
]

{ #category : #examples }
GtKotlinParserExamples >> stringInterpolationExample [
	<gtExample>
	^ self parse: 'fun greet(name: String) = "Hello ${name}"'
]

{ #category : #examples }
GtKotlinParserExamples >> superTypeQualifierExample [
	<gtExample>
	^ self parse: 'class Child : Parent() {
	fun test() {
		super<Parent>.toString()
	}
}'
]

{ #category : #examples }
GtKotlinParserExamples >> topLevelIfFailsExample [
	<gtExample>
	^ self fail: 'if (ready) { work() } else { rest() }'
]

{ #category : #examples }
GtKotlinParserExamples >> topLevelWhenFailsExample [
	<gtExample>
	^ self fail: 'when (x) { 1 -> one() else -> other() }'
]

{ #category : #examples }
GtKotlinParserExamples >> tryCatchFinallyExample [
	<gtExample>
	^ self parse: 'try { work() } catch (e: Exception) { handle(e) } finally { cleanup() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> typeAliasExample [
	<gtExample>
	^ self parse: 'typealias Name = String'
]

{ #category : #examples }
GtKotlinParserExamples >> whenExpressionExample [
	<gtExample>
	^ self parse: 'when (x) { 1 -> one() else -> other() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> whenSubjectDeclarationExample [
	<gtExample>
	^ self parse: 'when (val y = x) { else -> y }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> whileLoopExample [
	<gtExample>
	^ self parse: 'while (x < 10) { x += 1 }' startingAt: KotlinParser startingStateForscript
]
