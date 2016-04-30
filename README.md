# Unifill

Shim your code to support Unicode across all platforms.

## Usage

The declaration `using unifill.Unifill;` introduces the methods whose
name starts with `u` into `String` instances. Replace all methods of
`String`s in your code with `Unifill`'s methods, and your code will be
able to deal with Unicode strings across all platforms.

```haxe
using unifill.Unifill;
import unifill.CodePoint;

class Main {
  public static function main() : Void {
    trace("日本語".uLength()); // ==> 3
    trace("русский".uCharAt(5)); // ==> и
    trace("🍺".uCodePointAt(0).toInt()); // ==> 127866
    trace(CodePoint.fromInt(0x1F37B)); // ==> 🍻
    for (c in "♠♡♢♣".uIterator()) {
      trace(c);
      trace(c + 4);
    }
  }
}
```

## Iteration

You might write `for` loops like this:

```haxe
function f(s : String) : Void {
  for (i in s.uLength()) {
    trace(s.uCharAt(i));
  }
}
```

But this way may be inefficient because `f(s)` has order of the square
of the length of `s`.

Instead, you can use `uIterator` to make the function linear time:

```haxe
function f(s : String) : Void {
  for (c in s.uIterator()) {
    trace(c.toString());
  }
}
```

`uIterator` iterates over each code point in the string.

## InternalEncoding

For advanced usage, you can use `InternalEncoding`, which provides methods
treating variable-length encoding without considering which encoding form
is practically used.

These methods index by code units. That is, the value of
`InternalEncoding.charAt("эюя", 2)` varies depending the tar
environment: the UTF-8 environments (Haxe macro, C++, Neko, PHP and
Lua) give `"ю"`, while the UTF-16 environments (Flash, C#, Java and
JavaScript) and the UTF-32 environment (Python) give `"я"`.

`InternalEncoding.codePointWidthAt` returns the number of code units
the code point is consist of, so any platform gives `"ю"` for the
following expression:

```haxe
InternalEncoding.charAt("эюя", InternalEncoding.codePointWidthAt("эюя", 0))
```
