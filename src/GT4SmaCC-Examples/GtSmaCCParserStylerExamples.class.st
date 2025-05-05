Class {
	#name : #GtSmaCCParserStylerExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #styling }
GtSmaCCParserStylerExamples >> csharpStyler [
	<gtExample>
	<return: #GtSmaCCParserStyler>
	^ CSharpParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> csvStyler [
	<gtExample>
	<return: #GtSmaCCParserStyler>
	^ CSVParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> javaExpressionStyler [
	<gtExample>
	<return: #GtSmaCCParserStyler>
	^ self javaStyler startingState: JavaParser startingStateForexpression
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> javaStyler [
	<gtExample>
	<return: #GtSmaCCParserStyler>
	^ JavaParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> jsStyler [
	<gtExample>
	<return: #GtSmaCCParserStyler>
	^ JSParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> jsStylerTextElement [
	<gtExample>
	<return: #BrEditorElement>
	| editorElement textEditor |
	textEditor := BrTextEditorModel new.
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
GtSmaCCParserStylerExamples >> jsonStyler [
	<gtExample>
	<return: #GtSmaCCParserStyler>
	^ JSONParser gtStyler
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledCSV [
	<gtExample>
	<return: #BlRunRopedText>
	| text |
	text := '1,a,!
2,b,@
3,c,#
4,"error
5,e,''error' asRopedText.
	self csvStyler style: text.
	^ text
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledCSharp [
	<gtExample>
	<return: #BlRunRopedText>
	| text |
	text := 'using System;
	
namespace Foo.Bar {
	public class Baz {
		MyClass inst = new MyClass();
		
		[TestMethod]
		public void TestFunction() { 
			Assert.AreEqual(inst.Value, 1);
		}
	}
}' asRopedText.
	self csharpStyler style: text.
	^ text
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJS [
	<gtExample>
	<return: #BlRunRopedText>
	| text |
	text := '// This is a comment
for (var i = 0; i < 10; i++)
	this.write(i);' asRopedText.
	self jsStyler style: text.
	^ text
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJSON [
	<gtExample>
	<return: #BlRunRopedText>
	| text |
	text := '{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": [
      {"value": "New", "onclick": "CreateNewDoc()"},
      {"value": "Open", "onclick": "OpenDoc()"},
      {"value": "Close", "onclick": "CloseDoc()"}
    ]
  }
}}' asRopedText.
	self jsonStyler style: text.
	^ text
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJSONWithError [
	<gtExample>
	<return: #BlRunRopedText>
	| text |
	text := '{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": [
      {"value": "New", "onclick": "CreateNewDoc()"}
      {"value": "Open", "onclick": "OpenDoc()"},
      {"value": "Close", "onclick": "CloseDoc()"}
    ]
  }
}}' asRopedText.
	self jsonStyler style: text.
	^ text
]

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJava [
	<gtExample>
	<return: #BlRunRopedText>
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

{ #category : #styling }
GtSmaCCParserStylerExamples >> styledJavaWithStartingState [
	<gtExample>
	<return: #BlRunRopedText>
	| text |
	text := 'this.foo(3 + 4 /* 7 */)' asRopedText.
	self javaExpressionStyler style: text.
	^ text
]
