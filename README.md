# Unifill

Shim your code to support Unicode across all platforms.

## Usage

`using unifill.Unifill` introduce the methods whose names start with u
into the String class. Replace all methods of String in your code with
Unifill's methods, and your code become able to deal with Unicode
strings across all platforms.

```haxe
using unifill.Unifill;
import unifill.CodePoint;

class Main {
  public static function main() : Void {
    trace("日本語".uLength()); // ==> 3
    trace("русский".uCharAt(5)); // ==> и
    trace("🍺".uCodePointAt(0).toInt()); // ==> 127866
    trace(new CodePoint(0x1F37B)); // ==> 🍻
    for (c in "♠♡♢♣".uIterator()) {
      trace(c);
      trace(c + 4);
    }
  }
}
```