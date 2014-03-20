package unifill;

/**
   Utf32 provides a UTF-32-encoded string.
 **/
class Utf32 {

	public static inline function fromCharCode(code : Int) : Utf32 {
		return new Utf32([code]);
	}

	public static inline function fromString(string : String) : Utf32 {
		var u = [for (c in new InternalEncodingIter(string, 0, string.length)) InternalEncoding.codePointAt(string, c)];
		return new Utf32(u);
	}

	public static inline function fromArray(a : Array<Int>) : Utf32 {
		return new Utf32(a.copy());
	}

	public var length(get, never) : Int;

	public inline function charAt(index : Int) : Utf32 {
		if (0 <= index && index < this.array.length) {
			return new Utf32([this.array[index]]);
		} else {
			return new Utf32([]);
		}
	}

	public inline function charCodeAt(index : Int) : Null<Int> {
		if (0 <= index && index < this.array.length) {
			return this.array[index];
		}
		return null;
	}

	public inline function codeUnitAt(index : Int) : Int {
		return this.array[index];
	}

	public inline function codePointAt(index : Int) : Int {
		return this.array[index];
	}

	public inline function codePointWidthAt(index : Int) : Int {
		return 1;
	}

	public inline function codePointWidthBefore(index : Int) : Int {
		return 1;
	}

	public inline function toString() : String {
		return InternalEncoding.fromCodePoints(this.array);
	}

	public inline function toArray() : Array<Int> {
		return this.array.copy();
	}

	public function validate() : Void {
		var i = 0;
		var len = this.array.length;
		while (i < len) {
			if (!Unicode.isCodePoint(this.array[i++])) {
				throw Exception.InvalidCodeUnitSequence(i);
			}
		}
	}

	@:op(A + B)
	static inline function concat(a : Utf32, b : Utf32) : Utf32 {
		var s : Array<Int> = a.array;
		return new Utf32(s.concat(b.array));
	}

	static inline function cmp(a : Utf32, b : Utf32) : Int {
		return UtfTools.compare(a, b);
	}

	@:op(A == B)
	static inline function eq(a : Utf32, b : Utf32) : Bool {
		return if (a.array.length != b.array.length) false;
		else cmp(a, b) == 0;
	}

	@:op(A != B)
	static inline function ne(a : Utf32, b : Utf32) : Bool {
		return !eq(a, b);
	}

	@:op(A < B)
	static inline function lt(a : Utf32, b : Utf32) : Bool {
		return cmp(a, b) < 0;
	}

	@:op(A <= B)
	static inline function lte(a : Utf32, b : Utf32) : Bool {
		return cmp(a, b) <= 0;
	}

	@:op(A > B)
	static inline function gt(a : Utf32, b : Utf32) : Bool {
		return cmp(a, b) > 0;
	}

	@:op(A >= B)
	static inline function gte(a : Utf32, b : Utf32) : Bool {
		return cmp(a, b) >= 0;
	}

	@:op(A + B)
	static inline function cons(a : CodePoint, b : Utf32) : Utf32 {
		var c : Array<Int> = b.array;
		var d = c.copy();
		d.unshift(a.toInt());
		return new Utf32(d);
	}

	@:op(A + B)
	static inline function snoc(a : Utf32, b : CodePoint) : Utf32 {
		var c : Array<Int> = a.array;
		var d = c.copy();
		d.push(b.toInt());
		return new Utf32(d);
	}

	var array : Array<Int>;

	inline function get_length() : Int {
		return this.array.length;
	}

	inline function new(a : Array<Int>) {
		this.array = a;
	}

}
