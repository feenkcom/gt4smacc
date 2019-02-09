Class {
	#name : #GtSmaCCParserStylerExamples,
	#superclass : #Object,
	#category : #'GT-SmaCC-Examples'
}

{ #category : #styling }
GtSmaCCParserStylerExamples >> javaStyler [
	<gtExample>
	^ JavaParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> jsStyler [
	<gtExample>
	^ JSParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> jsStylerTextElement [
	<gtExample>
	| editorElement textEditor |
	textEditor := BrTextEditor new.
	textEditor styler: self jsStyler.
	editorElement := BrEditorElement new.
	editorElement editor: textEditor.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ editorElement
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJS [
	<gtExample>
	| text |
	text := '// This is a comment
for (var i = 0; i < 10; i++)
	this.write(i);' asRopedText.
	self jsStyler style: text.
	^ text
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJava [
	<gtExample>
	| text |
	text := 'package test;
	
import org.junit.Text;

public class Something { 
	MyClass inst = new MyClass();
	
	@Test
	public void testFunction() { 
		Assert.assertTrue(inst.getValue() == 1);
	}
}
	' asRopedText.
	self javaStyler style: text.
	^ text
]
