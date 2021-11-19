module Series1

import IO;
import Map;

/*
 * Documentation: http://docs.rascal-mpl.org 
 *  or button with wasp with hat)
 */

/*
 * Hello world
 *
 * - Import IO, write a function that prints out Hello World!
 * - open the console (right-click in the editor, "Start console"
 * - import this module and invoke helloWorld.
 */
 
void helloWorld() {
	println("Hello World");
} 


/*
 * FizzBuzz (https://en.wikipedia.org/wiki/Fizz_buzz)
 * - implement imperatively
 * - implement as list-returning function
 */
 
void fizzBuzz() {
   for (int n <- [1 .. 101]){
      fb = ((n % 3 == 0) ? "Fizz " : "") + ((n % 5 == 0) ? "Buzz" : "");
      println((fb == "") ?"<n>" : fb);
   }
}

list[str] fizzBuzz() {
	str msg(int i) {
		return ((i % 3 == 0) ? "Fizz " : "") + ((i % 5 == 0) ? "Buzz" : "") + ((i % 15 != 0) ? "<i>" : "");
	}
	return [msg(i) | int i <- [1..101]];
}

/*
 * Factorial
 * - first using ordinary recursion
 * - then using pattern-based dispatch 
 *  (complete the definition with a default case)
 */
 


int factorial(0) = 1;
int factorial(1) = 1;

default int factorial(int n) {
	return (n>=0) ? (n*factorial(n - 1)) : 1;
}




/*
 * Comprehensions
 * - use println to see the result
 */
 
void comprehensions() {

  // construct a list of squares of integer from 0 to 9 (use range [0..10])
  println([n*n | int n <- [0..10]]);
  
  // same, but construct a set
  println({n*n | int n <- [0..10]});
  
  // same, but construct a map
  println((n: n * n | int n <- [0..10]));
  
  // construct a list of factorials from 0 to 9
  println([factorial(n) | int n <- [0..10]]);
  
  // same, but no only for even numbers  
  println([n*n | int n <- [0..10], n%2 == 0]);
}
 

/*
 * Pattern matching
 * - fill in the blanks with pattern match expressions (using :=)
 */
 

void patternMatching() {
  str hello = "Hello World!";
  
  

  // print all splits of list
  list[int] aList = [1,2,3,4,5];
  for ([*x, *y] := aList) {
    println("x = <x> , y = <y>");
  }
  
  // print all partitions of a set
  set[int] aSet = {1,2,3,4,5};
  for ({*x, *y} := aSet) {
    println("x = <x> , y = <y>");
  } 

  

}  
 
 
 
/*
 * Trees
 * - complete the data type ColoredTree with
 *   constructors for binary red and black branches
 * - use the exampleTree() to test in the console
 */
 
data ColoredTree
  = leaf(int N) 
    | red(ColoredTree left, ColoredTree right)
    | black(ColoredTree left, ColoredTree right);
  

ColoredTree exampleTree()
  =  red(black(leaf(1), red(leaf(2), leaf(3))),
              black(leaf(4), leaf(5)));  
  
  
// write a recursive function summing the leaves
// (use switch or pattern-based dispatch)

int sumLeaves(ColoredTree t) {
	switch (t) {
		case leaf(int N): return N;
		case red(ColoredTree l, ColoredTree r):
			return sumLeaves(l) + sumLeaves(r);
		case black(ColoredTree l, ColoredTree r):
			return sumLeaves(l) + sumLeaves(r);
    	default: return 0; 
	}
}

// same, but now with visit
int sumLeavesWithVisit(ColoredTree t) {
   int count = 0;
   visit(t) {
     case leaf(int N): count = count + N; 
   };
   return count;
}

// same, but now with a for loop and deep match
int sumLeavesWithFor(ColoredTree t) {
	int count = 0;
	for (/leaf(int N) := t) {
		count += N;
	}
	return count;
}

// same, but now with a reducer and deep match
// Reducer = ( <initial value> | <some expression with `it` | <generators> )
int sumLeavesWithReducer(ColoredTree t) = 
	( 0 | it + N | /leaf(int N) := t); // TODO: Change this!


// add 1 to all leaves; use visit + =>
ColoredTree inc1(ColoredTree t) {
	return visit(t) {
    	case leaf(int N) => leaf(N+1)
	};
}

// write a test for inc1, run from console using :test
test bool testInc1() = 
	inc1(exampleTree()) ==
		red(black(leaf(2), red(leaf(3), leaf(4))),
              black(leaf(5), leaf(6)));

// define a property for inc1, i.e. a boolean
// function that checks if one tree is inc1 of the other
// (without using inc1).
// Use switch on the tupling of t1 and t2 (`<t1, t2>`)
// or pattern based dispatch.
// Hint! The tree also needs to have the same shape!
bool isInc1(ColoredTree t1, ColoredTree t2) {
	switch (<t1, t2>) {
    case <leaf(int a), leaf(int b)>: 
      return b == a + 1;
    case <red(ColoredTree l, ColoredTree r), red(ColoredTree l2, ColoredTree r2)>:
      return isInc1(l, l2) && isInc1(r, r2); 
    case <black(ColoredTree l, ColoredTree r), black(ColoredTree l2, ColoredTree r2)>:
      return isInc1(l, l2) && isInc1(r, r2);
    default: return false; 
  }
}
 
// write a randomized test for inc1 using the property
// again, execute using :test
test bool testInc1Randomized(ColoredTree t1) = isInc1(t1, inc1(t1));


 

 
  
  
