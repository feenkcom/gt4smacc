Class {
	#name : #GtKotlinParserExamples,
	#superclass : #GtSmaCCParserExamples,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #examples }
GtKotlinParserExamples >> abstractClassExample [
	<gtExample>
	^ self parse: 'abstract class Base { abstract fun render(): String }'
]

{ #category : #examples }
GtKotlinParserExamples >> actualDeclarationExample [
	<gtExample>
	^ self parse: 'actual class Platform actual constructor()'
]

{ #category : #examples }
GtKotlinParserExamples >> annotatedDelegationSpecifierExample [
	<gtExample>
	^ self parse: 'annotation class Fancy
	interface Base
	class Derived : @Fancy Base'
]

{ #category : #examples }
GtKotlinParserExamples >> annotatedExtensionFunctionExample [
	<gtExample>
	^ self parse: '@Fancy
	fun String.decorate(): String = this'
]

{ #category : #examples }
GtKotlinParserExamples >> annotatedNullableReceiverExtensionFunctionExample [
	<gtExample>
	^ self parse: 'fun @ReceiverAnn String?.tag(): String = this ?: "missing"'
]

{ #category : #examples }
GtKotlinParserExamples >> annotatedPrimaryConstructorExample [
	<gtExample>
	^ self parse: 'class Service @Inject constructor(val repository: Repository)'
]

{ #category : #examples }
GtKotlinParserExamples >> annotatedTypeParameterExample [
	<gtExample>
	^ self parse: 'fun <@A T> id(value: T): T = value'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationBeforeAndAfterModifierExample [
	<gtExample>
	^ self parse: '@Fancy public class Sample'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationClassExample [
	<gtExample>
	^ self parse: 'annotation class Fancy'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationClassWithUseSiteExample [
	<gtExample>
	^ self parse: 'class Sample(@receiver:Fancy val value: String)'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationCombinationExample [
	<gtExample>
	^ self parse: '@Deprecated("old")
class Person'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnFunctionReturnTypeExample [
	<gtExample>
	^ self parse: 'fun parse(): @Fancy String = "ok"'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnFunctionTypeExample [
	<gtExample>
	^ self parse: 'val f: @Fancy (Int) -> String = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnFunctionTypeParameterExample [
	<gtExample>
	^ self parse: 'val f: (@Fancy Int) -> String = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnNestedTypeArgumentExample [
	<gtExample>
	^ self parse: 'val xs: Map<String, List<@Fancy Int>> = emptyMap()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnNullableFunctionTypeExample [
	<gtExample>
	^ self parse: 'val f: (@Fancy (Int) -> String)? = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnNullableReturnTypeExample [
	<gtExample>
	^ self parse: 'fun parse(): @Fancy String? = null'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnParenthesizedTypeExample [
	<gtExample>
	^ self parse: 'val f: @Fancy ((Int) -> String) = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnReceiverTypeExample [
	<gtExample>
	^ self parse: 'fun @ReceiverAnn String.decorate(): String = this'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnTypeArgumentExample [
	<gtExample>
	^ self parse: 'val xs: List<@Fancy String> = emptyList()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> annotationOnTypeConstraintExample [
	<gtExample>
	^ self parse: 'fun <T> take(value: T) where T : @Fancy CharSequence = value.toString()'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetDelegateExample [
	<gtExample>
	^ self parse: 'class Example {
		@delegate:Fancy
		val lazyValue by lazy { 1 }
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetExample [
	<gtExample>
	^ self parse: 'class Person(@param:Inject val name: String)'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetFieldExample [
	<gtExample>
	^ self parse: 'class Example {
		@field:Fancy
		val name: String = "x"
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetGetExample [
	<gtExample>
	^ self parse: 'class Example {
		@get:Fancy
		val name: String = "x"
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetPropertySetterExample [
	<gtExample>
	^ self parse: 'class Person {
		@set:Inject
		var name: String = ""
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> annotationUseSiteTargetSetParamExample [
	<gtExample>
	^ self parse: 'class Example {
		var name: String = ""
			@setparam:Fancy set(value) { field = value }
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> anonymousFunctionExample [
	<gtExample>
	^ self parse: 'val f = fun(x: Int): Int = x + 1' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> anonymousObjectWithConstructorInvocationExample [
	<gtExample>
	^ self parse: 'open class Base(val x: Int)
	val obj = object : Base(1) {}' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> anonymousObjectWithSuperTypesExample [
	<gtExample>
	^ self parse: 'val obj = object : Runnable, AutoCloseable {
		override fun run() {}
		override fun close() {}
	}' startingAt: KotlinParser startingStateForscript
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
GtKotlinParserExamples >> callChainWithTypeArgumentsExample [
	<gtExample>
	^ self parse: 'val s = values.map<Int> { it }.first()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callWithNamedArgumentAndTrailingLambdaExample [
	<gtExample>
	^ self parse: 'val result = build(size = 1) { 42 }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callWithTrailingLambdaExample [
	<gtExample>
	^ self parse: 'val result = run { 1 }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callWithTypeArgumentsExample [
	<gtExample>
	^ self parse: 'val xs = listOf<Int>(1, 2)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceAfterSafeCallChainExample [
	<gtExample>
	^ self parse: 'val ref = String::length' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToBoundExpressionExample [
	<gtExample>
	^ self parse: 'val ref = (person)::toString' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToClassPropertyExample [
	<gtExample>
	^ self parse: 'data class Person(val name: String)
	val ref = Person::name' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToCompanionMemberExample [
	<gtExample>
	^ self parse: 'class Holder { companion object { fun create(): Holder = Holder() } }
	val ref = Holder::create' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToConstructorExample [
	<gtExample>
	^ self parse: 'val ref = ::Regex' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToExtensionFunctionExample [
	<gtExample>
	^ self parse: 'val ref = String::trim' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToGenericClassMemberExample [
	<gtExample>
	^ self parse: 'class Box<T>(val value: T)
	val ref = Box<String>::value' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToInvokeExample [
	<gtExample>
	^ self parse: 'val ref = Function1<Int, String>::invoke' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToMemberExample [
	<gtExample>
	^ self parse: 'val ref = String::length' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceToTopLevelFunctionExample [
	<gtExample>
	^ self parse: 'val ref = ::println' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceWithFunctionTypeReceiverExample [
	<gtExample>
	^ self parse: 'val ref = ((Int) -> String)::invoke' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceWithNestedNullableFunctionTypeReceiverExample [
	<gtExample>
	^ self parse: 'val ref = (((Int) -> String)?)::hashCode' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceWithNullableReceiverTypeExample [
	<gtExample>
	^ self parse: 'val ref = (String?)::length' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> callableReferenceWithReceiverExample [
	<gtExample>
	^ self parse: 'val ref = Regex::matches' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> classBodyWithOnlySemicolonsExample [
	<gtExample>
	^ self parse: 'class Empty { ;;; }'
]

{ #category : #examples }
GtKotlinParserExamples >> classDeclarationExample [
	<gtExample>
	^ self parse: 'class Person(val name: String, var age: Int)'
]

{ #category : #examples }
GtKotlinParserExamples >> classLiteralExample [
	<gtExample>
	^ self parse: 'val type = String::class' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> classWithSemicolonsBetweenMembersExample [
	<gtExample>
	^ self parse: 'class Sample { val x: Int = 1; fun y(): Int = x }'
]

{ #category : #examples }
GtKotlinParserExamples >> companionObjectExample [
	<gtExample>
	^ self parse: 'class Person { companion object { } }'
]

{ #category : #examples }
GtKotlinParserExamples >> compoundAssignmentExample [
	<gtExample>
	^ self parse: 'var total = 0
	total += 1' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> constPropertyExample [
	<gtExample>
	^ self parse: 'const val answer: Int = 42' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> constructorDelegationExample [
	<gtExample>
	^ self parse: 'class Child() : Parent(1), Runnable { }'
]

{ #category : #examples }
GtKotlinParserExamples >> constructorParameterAnnotationExample [
	<gtExample>
	^ self parse: 'class Person(@param:Named("full") val name: String)'
]

{ #category : #examples }
GtKotlinParserExamples >> dataClassExample [
	<gtExample>
	^ self parse: 'data class Person(val name: String, val age: Int)'
]

{ #category : #examples }
GtKotlinParserExamples >> deeplyNestedTypeArgumentExample [
	<gtExample>
	^ self parse: 'val value: Map<String, List<Set<(Int) -> String>>> = emptyMap()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> definitelyNonNullableTypeExample [
	<gtExample>
	^ self parse: 'fun <T> requireDefinitelyNonNull(value: T & Any): T & Any = value'
]

{ #category : #examples }
GtKotlinParserExamples >> delegatedPropertyExample [
	<gtExample>
	^ self parse: 'val name by lazy { "x" }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> delegationSpecifierExample [
	<gtExample>
	^ self parse: 'interface Base { fun print() }
	class BaseImpl : Base { override fun print() {} }
	class Derived(b: Base) : Base by b'
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

{ #category : #examples }
GtKotlinParserExamples >> doWhileWithSemicolonExample [
	<gtExample>
	^ self parse: 'do println(x) while (x > 0)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> elvisWithThrowExample [
	<gtExample>
	^ self parse: 'fun requireName(name: String?): String = name ?: throw IllegalArgumentException()'
]

{ #category : #examples }
GtKotlinParserExamples >> emptyClassBodyExample [
	<gtExample>
	^ self parse: 'class Empty {}'
]

{ #category : #examples }
GtKotlinParserExamples >> emptyCompanionObjectExample [
	<gtExample>
	^ self parse: 'class Holder { companion object {} }'
]

{ #category : #examples }
GtKotlinParserExamples >> enumClassWithTrailingCommaExample [
	<gtExample>
	^ self parse: 'enum class Direction { NORTH, SOUTH, }'
]

{ #category : #examples }
GtKotlinParserExamples >> enumDeclarationExample [
	<gtExample>
	^ self parse: 'enum class Direction { NORTH, SOUTH, EAST, WEST }'
]

{ #category : #examples }
GtKotlinParserExamples >> enumEntryBodyExample [
	<gtExample>
	^ self parse: 'enum class Direction { NORTH { override fun label(): String = "N" }; abstract fun label(): String }'
]

{ #category : #examples }
GtKotlinParserExamples >> enumWithMembersExample [
	<gtExample>
	^ self parse: 'enum class Color(val rgb: Int) { RED(0xFF0000), GREEN(0x00FF00), BLUE(0x0000FF); fun isPrimary(): Boolean = true }'
]

{ #category : #examples }
GtKotlinParserExamples >> expectDeclarationExample [
	<gtExample>
	^ self parse: 'expect class Platform()'
]

{ #category : #examples }
GtKotlinParserExamples >> extensionPropertyExample [
	<gtExample>
	^ self parse: 'val String.firstChar: Char
		get() = this[0]'
]

{ #category : #examples }
GtKotlinParserExamples >> extensionPropertyWithSetterExample [
	<gtExample>
	^ self parse: 'var StringBuilder.lastChar: Char
		get() = this[length - 1]
		set(value) { this.setCharAt(length - 1, value) }'
]

{ #category : #examples }
GtKotlinParserExamples >> externalFunctionExample [
	<gtExample>
	^ self parse: 'external fun nativeCall(x: Int): Int'
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
GtKotlinParserExamples >> fileAnnotationWithMultipleAnnotationsExample [
	<gtExample>
	^ self parse: '@file:[JvmName("Sample") Suppress("unused")]
	class Sample'
]

{ #category : #examples }
GtKotlinParserExamples >> finalClassExample [
	<gtExample>
	^ self parse: 'final class Closed'
]

{ #category : #examples }
GtKotlinParserExamples >> forLoopExample [
	<gtExample>
	^ self parse: 'for (x in items) { println(x) }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> funInterfaceExample [
	<gtExample>
	^ self parse: 'fun interface IntPredicate { fun accept(i: Int): Boolean }'
]

{ #category : #examples }
GtKotlinParserExamples >> functionBodyWithLabeledReturnExample [
	<gtExample>
	^ self parse: 'fun test(): Int { run label@ { return@label }; return 1 }'
]

{ #category : #examples }
GtKotlinParserExamples >> functionTypeInsideTypeArgumentExample [
	<gtExample>
	^ self parse: 'val handlers: List<(Int) -> String> = emptyList()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> functionTypeParameterExample [
	<gtExample>
	^ self parse: 'fun apply(f: (Int, String) -> Boolean): Boolean = f(1, "a")'
]

{ #category : #examples }
GtKotlinParserExamples >> functionTypeParameterWithTrailingCommaExample [
	<gtExample>
	^ self parse: 'fun use(block: (x: Int, y: String,) -> Unit) { block(1, "a") }'
]

{ #category : #examples }
GtKotlinParserExamples >> functionTypeReturningNullableTypeExample [
	<gtExample>
	^ self parse: 'val f: (Int) -> String? = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> functionTypeWithNamedParametersExample [
	<gtExample>
	^ self parse: 'fun use(block: (x: Int, y: String) -> Unit) { block(1, "a") }'
]

{ #category : #examples }
GtKotlinParserExamples >> functionWithIfExpressionExample [
	<gtExample>
	^ self parse: 'fun choose(ready: Boolean): Int = if (ready) { 1 } else { 2 }'
]

{ #category : #examples }
GtKotlinParserExamples >> functionWithSemicolonInBlockExample [
	<gtExample>
	^ self parse: 'fun test(): Int { val x = 1; return x }'
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
GtKotlinParserExamples >> getterAndSetterWithAnnotationsExample [
	<gtExample>
	^ self parse: 'class Person {
		var name: String = ""
			@get:Fancy get
			@set:Fancy set
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> getterSetterExample [
	<gtExample>
	^ self parse: 'var name: String
	get() = field
	set(value) { field = value }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> getterWithBodyExample [
	<gtExample>
	^ self parse: 'class Person {
		val name: String
			get() { return field }
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> ifExpressionAsArgumentExample [
	<gtExample>
	^ self parse: 'val result = consume(if (flag) 1 else 2)' startingAt: KotlinParser startingStateForscript
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
GtKotlinParserExamples >> indexedAssignmentExample [
	<gtExample>
	^ self parse: 'var list = mutableListOf(1, 2, 3)
	list[0] += 1' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> infixExtensionFunctionExample [
	<gtExample>
	^ self parse: 'infix fun Int.combine(other: Int): Int = this + other'
]

{ #category : #examples }
GtKotlinParserExamples >> infixFunctionCallExample [
	<gtExample>
	^ self parse: 'a to b' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> inlineNoinlineCrossinlineExample [
	<gtExample>
	^ self parse: 'inline fun runAll(noinline first: () -> Unit, crossinline second: () -> Unit) { first(); second() }'
]

{ #category : #examples }
GtKotlinParserExamples >> innerClassExample [
	<gtExample>
	^ self parse: 'class Outer { inner class Inner { fun owner(): Outer = this@Outer } }'
]

{ #category : #examples }
GtKotlinParserExamples >> interfaceDeclarationExample [
	<gtExample>
	^ self parse: 'interface Named { val name: String
	fun display(): String }'
]

{ #category : #examples }
GtKotlinParserExamples >> internalClassExample [
	<gtExample>
	^ self parse: 'internal class Service'
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
GtKotlinParserExamples >> labeledLambdaExample [
	<gtExample>
	^ self parse: 'val f = label@ { x: Int -> return@label x + 1 }' startingAt: KotlinParser startingStateForscript
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
GtKotlinParserExamples >> lambdaWithTrailingCommaParametersExample [
	<gtExample>
	^ self parse: 'val f = { a: Int, b: Int, -> a + b }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> lateinitPropertyExample [
	<gtExample>
	^ self parse: 'class Holder { lateinit var value: String }'
]

{ #category : #examples }
GtKotlinParserExamples >> multiAnnotationExample [
	<gtExample>
	^ self parse: '@[A B] class Example'
]

{ #category : #examples }
GtKotlinParserExamples >> multiCatchStyleSequenceExample [
	<gtExample>
	^ self parse: 'try { work() } catch (e: IllegalStateException) { recover() } catch (e: IllegalArgumentException) { recover() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> multiLineStringExample [
	<gtExample>
	^ self parse: 'val text = """hello
world"""' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> multiVariableLambdaParameterExample [
	<gtExample>
	^ self parse: 'val f: (Pair<Int, Int>) -> Int = { (a, b) -> a + b }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> multilineStringInterpolationExample [
	<gtExample>
	^ self parse: 'val text = """Hello, ${name.uppercase()}!"""' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> multipleDelegationSpecifiersExample [
	<gtExample>
	^ self parse: 'interface A
	interface B
	open class Base
	class Derived : Base(), A, B'
]

{ #category : #examples }
GtKotlinParserExamples >> multipleModifierOrderExample [
	<gtExample>
	^ self parse: 'public open class Sample'
]

{ #category : #examples }
GtKotlinParserExamples >> multipleReceiverLikeFunctionTypesExample [
	<gtExample>
	^ self parse: 'val f: (String.() -> Int) -> Unit = consumer' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> multipleTypeConstraintExample [
	<gtExample>
	^ self parse: 'fun <T, R> combine(value: T, other: R): String where T : CharSequence, R : Appendable = value.toString()'
]

{ #category : #examples }
GtKotlinParserExamples >> nestedFunctionTypeExample [
	<gtExample>
	^ self parse: 'val transform: ((Int) -> String) -> Unit = consumer' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> nestedIfExpressionExample [
	<gtExample>
	^ self parse: 'fun classify(x: Int): String = if (x > 0) if (x > 10) "large" else "small" else "non-positive"'
]

{ #category : #examples }
GtKotlinParserExamples >> nestedNullableFunctionTypeExample [
	<gtExample>
	^ self parse: 'val f: (((Int) -> String)?) -> Unit = consumer' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> nestedTypeAliasExample [
	<gtExample>
	^ self parse: 'class Outer {
		typealias Name = String
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> nestedWhenExpressionExample [
	<gtExample>
	^ self parse: 'fun classify(x: Any): String = when (x) { is Int -> when (x) { 0 -> "zero" else -> "int" } else -> "other" }'
]

{ #category : #examples }
GtKotlinParserExamples >> newlineAfterAssignmentExample [
	<gtExample>
	^ self parse: 'val result =
		compute()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> newlineBeforeElvisRightOperandExample [
	<gtExample>
	^ self parse: 'val result = value ?: 
		fallback()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> newlineElvisExample [
	<gtExample>
	^ self parse: 'val name = person.name
		?: "unknown"' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> newlineSafeCallExample [
	<gtExample>
	^ self parse: 'val city = person
		?.address
		?.city' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> notNullAssertionExample [
	<gtExample>
	^ self parse: 'val name = person!!.name' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> nullableFunctionTypeExample [
	<gtExample>
	^ self parse: 'val callback: ((Int) -> String)? = null' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> nullableFunctionTypeInsideTypeArgumentExample [
	<gtExample>
	^ self parse: 'val handlers: List<((Int) -> String)?> = emptyList()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> nullableGenericTypeExample [
	<gtExample>
	^ self parse: 'fun names(): List<String?> = listOf()'
]

{ #category : #examples }
GtKotlinParserExamples >> nullableReceiverExtensionFunctionExample [
	<gtExample>
	^ self parse: 'fun String?.orEmptyValue(): String = this ?: ""'
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
GtKotlinParserExamples >> openClassExample [
	<gtExample>
	^ self parse: 'open class Base'
]

{ #category : #examples }
GtKotlinParserExamples >> operatorExtensionFunctionExample [
	<gtExample>
	^ self parse: 'operator fun String.times(n: Int): String = this.repeat(n)'
]

{ #category : #examples }
GtKotlinParserExamples >> operatorFunctionExample [
	<gtExample>
	^ self parse: 'class Vector(val x: Int) { operator fun plus(other: Vector): Vector = Vector(x + other.x) }'
]

{ #category : #examples }
GtKotlinParserExamples >> overridePropertyExample [
	<gtExample>
	^ self parse: 'interface Named { val name: String }
	class Person(override val name: String) : Named'
]

{ #category : #examples }
GtKotlinParserExamples >> packageAndImportExample [
	<gtExample>
	^ self parse: 'package demo
import kotlin.collections.List
class Person'
]

{ #category : #examples }
GtKotlinParserExamples >> parenthesizedAssignableExample [
	<gtExample>
	^ self parse: '(items[0]) = value' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> parenthesizedCallableReferenceReceiverExample [
	<gtExample>
	^ self parse: 'val ref = (String)::class' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> parenthesizedExpressionCallExample [
	<gtExample>
	^ self parse: 'val value = (factory)()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> parenthesizedExpressionIndexingExample [
	<gtExample>
	^ self parse: 'val value = (items)[0]' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> parenthesizedExpressionNavigationExample [
	<gtExample>
	^ self parse: 'val value = (person).name' startingAt: KotlinParser startingStateForscript
]

{ #category : #accessing }
GtKotlinParserExamples >> parserClass [
	^ KotlinParser
]

{ #category : #examples }
GtKotlinParserExamples >> postfixChainExample [
	<gtExample>
	^ self parse: 'val result = items.first().values[0].toString()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> privateSetterExample [
	<gtExample>
	^ self parse: 'class Person {
		var name: String = ""
			private set
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> privateTopLevelFunctionExample [
	<gtExample>
	^ self parse: 'private fun helper(): Int = 1'
]

{ #category : #examples }
GtKotlinParserExamples >> propertyAccessorModifiersExample [
	<gtExample>
	^ self parse: 'class Person {
		@get:Fancy
		val name: String = ""
			private get
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> propertyDeclarationExample [
	<gtExample>
	^ self parse: 'val answer: Int = 42'
]

{ #category : #examples }
GtKotlinParserExamples >> propertyWithReceiverAndTypeParametersExample [
	<gtExample>
	^ self parse: 'val <T> List<T>.head: T
		get() = this[0]'
]

{ #category : #examples }
GtKotlinParserExamples >> propertyWithTypeConstraintExample [
	<gtExample>
	^ self parse: 'val <T> List<T>.firstItem: T where T : Any
		get() = this[0]'
]

{ #category : #examples }
GtKotlinParserExamples >> protectedMemberFunctionExample [
	<gtExample>
	^ self parse: 'open class Base { protected fun helper(): Int = 1 }'
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
GtKotlinParserExamples >> receiverFunctionLiteralExample [
	<gtExample>
	^ self parse: 'val f: String.() -> Int = { length }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> receiverFunctionTypeExample [
	<gtExample>
	^ self parse: 'val f: String.() -> Int = { 1 }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> reifiedTypeParameterExample [
	<gtExample>
	^ self parse: 'inline fun <reified T> isInstance(value: Any): Boolean = value is T'
]

{ #category : #examples }
GtKotlinParserExamples >> returnAtLabelInsideAnonymousFunctionExample [
	<gtExample>
	^ self parse: 'val f = fun(x: Int): Int { return x }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> safeNavigationAndCallableReferenceExample [
	<gtExample>
	^ self parse: 'val name = person?.name
val ref = String::class' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> safeNavigationChainExample [
	<gtExample>
	^ self parse: 'val city = person?.address?.city' startingAt: KotlinParser startingStateForscript
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
GtKotlinParserExamples >> scriptWithChainedSemicolonAndNewlineExample [
	<gtExample>
	^ self parse: 'val x = 1;
	val y = 2;
	val z = x + y' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithDoWhileExample [
	<gtExample>
	^ self parse: 'do x++ while (x < 10)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithEmptyStatementExample [
	<gtExample>
	^ self parse: 'val x = 1;
	;' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithExtraSemicolonsExample [
	<gtExample>
	^ self parse: 'val x = 1;;
	val y = 2' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithLambdaCallExample [
	<gtExample>
	^ self parse: 'val result = run {
		42
	}' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithLoopExample [
	<gtExample>
	^ self parse: 'var total = 0
	for (x in items) total += x' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithTryExample [
	<gtExample>
	^ self parse: 'val value = try { read() } catch (e: Exception) { defaultValue() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> scriptWithWhenExample [
	<gtExample>
	^ self parse: 'val label = when (x) { 1 -> "one" else -> "other" }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> sealedClassExample [
	<gtExample>
	^ self parse: 'sealed class Result {
	data class Success(val value: String) : Result()
	object Failure : Result()
}'
]

{ #category : #examples }
GtKotlinParserExamples >> secondaryConstructorExample [
	<gtExample>
	^ self parse: 'class Person(val name: String) { constructor(): this("unknown") { } }'
]

{ #category : #examples }
GtKotlinParserExamples >> secondaryConstructorWithDelegationAndBodyExample [
	<gtExample>
	^ self parse: 'class Person(val name: String) {
		constructor() : this("unknown") {
			println(name)
		}
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> setterWithBodyExample [
	<gtExample>
	^ self parse: 'class Person {
		var name: String = ""
			set(value) { field = value }
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> simpleFunctionExample [
	<gtExample>
	^ self parse: 'fun add(a: Int, b: Int): Int = a + b'
]

{ #category : #examples }
GtKotlinParserExamples >> starProjectionExample [
	<gtExample>
	^ self parse: 'val items: List<*> = listOf(1, 2, 3)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> stringInterpolationExample [
	<gtExample>
	^ self parse: 'fun greet(name: String) = "Hello ${name}"'
]

{ #category : #examples }
GtKotlinParserExamples >> superAtLabelExample [
	<gtExample>
	^ self parse: 'class Outer {
	inner class Inner {
		fun test(): String = super@Outer.toString()
	}
}'
]

{ #category : #examples }
GtKotlinParserExamples >> superAtOuterInInnerClassExample [
	<gtExample>
	^ self parse: 'open class Base {
		override fun toString(): String = "base"
	}
	class Outer : Base() {
		inner class Inner {
			fun value(): String = super@Outer.toString()
		}
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> superTypeCallWithTypeArgumentExample [
	<gtExample>
	^ self parse: 'open class Base<T>
	class Derived : Base<String>()'
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
GtKotlinParserExamples >> superTypeQualifierWithFunctionCallExample [
	<gtExample>
	^ self parse: 'open class Base { open fun render(): String = "base" }
	class Derived : Base() {
		override fun render(): String = super<Base>.render()
	}'
]

{ #category : #examples }
GtKotlinParserExamples >> suspendAnonymousFunctionExample [
	<gtExample>
	^ self parse: 'val f = suspend fun(x: Int): Int = x + 1' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> suspendExtensionFunctionExample [
	<gtExample>
	^ self parse: 'suspend fun String.fetch(): String = this'
]

{ #category : #examples }
GtKotlinParserExamples >> suspendFunctionTypeExample [
	<gtExample>
	^ self parse: 'val action: suspend (Int) -> String = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> suspendReceiverFunctionTypeExample [
	<gtExample>
	^ self parse: 'val f: suspend String.() -> Int = worker' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> tailrecFunctionExample [
	<gtExample>
	^ self parse: 'tailrec fun sum(n: Int, acc: Int): Int = if (n == 0) acc else sum(n - 1, acc + n)'
]

{ #category : #examples }
GtKotlinParserExamples >> thisAtOuterInAnonymousObjectExample [
	<gtExample>
	^ self parse: 'class Outer {
		inner class Inner {
			fun make() = object {
				fun owner(): Outer = this@Outer
			}
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
GtKotlinParserExamples >> trailingCommaArgumentsExample [
	<gtExample>
	^ self parse: 'val value = listOf(
	1,
	2,
)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> trailingCommaParametersExample [
	<gtExample>
	^ self parse: 'fun sum(
	a: Int,
	b: Int,
): Int = a + b'
]

{ #category : #examples }
GtKotlinParserExamples >> trailingCommaTypeArgumentsExample [
	<gtExample>
	^ self parse: 'val pair: Map<String, Int,> = mapOf()' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> tryCatchFinallyExample [
	<gtExample>
	^ self parse: 'try { work() } catch (e: Exception) { handle(e) } finally { cleanup() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> tryExpressionInCallExample [
	<gtExample>
	^ self parse: 'val result = consume(try { produce() } catch (e: Exception) { fallback() })' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> tryWithFinallyOnlyExample [
	<gtExample>
	^ self parse: 'try { work() } finally { cleanup() }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> typeAliasExample [
	<gtExample>
	^ self parse: 'typealias Name = String'
]

{ #category : #examples }
GtKotlinParserExamples >> typeConstraintExample [
	<gtExample>
	^ self parse: 'fun <T> requireComparable(value: T): T where T : Comparable<T> = value'
]

{ #category : #examples }
GtKotlinParserExamples >> typeProjectionWithAnnotationExample [
	<gtExample>
	^ self parse: 'val xs: Box<@UnsafeVariance out String> = source' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> typeUseAnnotationExample [
	<gtExample>
	^ self parse: 'fun parse(value: @UnsafeVariance String): @UnsafeVariance String = value'
]

{ #category : #examples }
GtKotlinParserExamples >> unaryOperatorExample [
	<gtExample>
	^ self parse: 'var i = 0
	++i
	i--
	val ok = !false' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> valueArgumentNameAndSpreadExample [
	<gtExample>
	^ self parse: 'val result = f(values = *items)' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> valueClassExample [
	<gtExample>
	^ self parse: 'value class UserId(val value: String)'
]

{ #category : #examples }
GtKotlinParserExamples >> varargParameterExample [
	<gtExample>
	^ self parse: 'fun join(vararg parts: String): String = parts[0]'
]

{ #category : #examples }
GtKotlinParserExamples >> varianceProjectionExample [
	<gtExample>
	^ self parse: 'val producer: Source<out String> = factory' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> whenExpressionAsArgumentExample [
	<gtExample>
	^ self parse: 'val result = consume(when (x) { 0 -> "zero" else -> "other" })' startingAt: KotlinParser startingStateForscript
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
GtKotlinParserExamples >> whenWithMultipleConditionsExample [
	<gtExample>
	^ self parse: 'fun describe(x: Int): String = when (x) { 0, 1 -> "small" else -> "other" }'
]

{ #category : #examples }
GtKotlinParserExamples >> whenWithRangeConditionExample [
	<gtExample>
	^ self parse: 'fun describe(x: Int): String = when (x) { in 1..10 -> "small" else -> "other" }'
]

{ #category : #examples }
GtKotlinParserExamples >> whenWithTypeTestExample [
	<gtExample>
	^ self parse: 'fun describe(x: Any): String = when (x) { is String -> x else -> "other" }'
]

{ #category : #examples }
GtKotlinParserExamples >> whileLoopExample [
	<gtExample>
	^ self parse: 'while (x < 10) { x += 1 }' startingAt: KotlinParser startingStateForscript
]

{ #category : #examples }
GtKotlinParserExamples >> whileWithSemicolonBodyExample [
	<gtExample>
	^ self parse: 'while (flag);' startingAt: KotlinParser startingStateForscript
]
