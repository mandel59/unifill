# Unifill

Library for Unicode string support

## Usage

```
using unifill.Unifill;
import unifill.CodePoint;

class Main {
  public static function main() : Void {
    trace("日本語".uLength()); // ==> 3
    trace("русский".uCharAt(5)); // ==> и
    trace("☃".uCodePointAt(0).toInt()); // ==> 9731
    trace(new CodePoint(0x2600)); // ==> ☀
    for (c in "♠♡♢♣".uIterator()) {
      trace(c);
      trace(c + 4);
    }
  }
}
```
