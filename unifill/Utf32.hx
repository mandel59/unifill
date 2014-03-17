package unifill;

/**
   Utf32 provides a UTF-32-encoded string.
 **/
abstract Utf32(Array<Int>) {

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
		if (0 <= index && index < this.length) {
			return new Utf32([this[index]]);
		} else {
			return new Utf32([]);
		}
	}

	public inline function charCodeAt(index : Int) : Null<Int> {
		if (0 <= index && index < this.length) {
			return this[index];
		}
		return null;
	}

	public inline function toUpperCase() : Utf32 {
		return new Utf32([for (c in this) if ("a".code <= c && c <= "z".code) c - ("a".code - "A".code) else c]);
	}

	public inline function toLowerCase() : Utf32 {
		return new Utf32([for (c in this) if ("A".code <= c && c <= "Z".code) c - ("A".code - "a".code) else c]);
	}

	public inline function toString() : String {
		return InternalEncoding.fromCodePoints(this);
	}

	public inline function toArray() : Array<Int> {
		return this.copy();
	}

	@:op(A + B)
	static inline function concat(a : Utf32, b : Utf32) : Utf32 {
		var s : Array<Int> = cast a;
		return new Utf32(s.concat(cast b));
	}

	static function cmp(a : Array<Int>, b : Array<Int>) : Int {
		var alen = a.length;
		var blen = b.length;
		var len = if (alen < blen) blen else alen;
		var i = 0;
		while (i < len) {
			if (i == alen)
				return -1;
			if (i == blen)
				return 1;
			if (a[i] < b[i])
				return -1;
			if (a[i] > b[i])
				return 1;
			++i;
		}
		return 0;
	}

	@:op(A == B)
	static inline function eq(a : Utf32, b : Utf32) : Bool {
		return if (a.length != b.length) false;
		else cmp(cast a, cast b) == 0;
	}

	@:op(A != B)
	static inline function ne(a : Utf32, b : Utf32) : Bool {
		return !eq(a, b);
	}

	@:op(A < B)
	static inline function lt(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) < 0;
	}

	@:op(A <= B)
	static inline function lte(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) <= 0;
	}

	@:op(A > B)
	static inline function gt(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) > 0;
	}

	@:op(A >= B)
	static inline function gte(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) >= 0;
	}

	@:op(A + B)
	static inline function cons(a : CodePoint, b : Utf32) : Utf32 {
		var c : Array<Int> = cast b;
		var d = c.copy();
		d.unshift(a.toInt());
		return cast d;
	}

	@:op(A + B)
	static inline function snoc(a : Utf32, b : CodePoint) : Utf32 {
		var c : Array<Int> = cast a;
		var d = c.copy();
		d.push(b.toInt());
		return cast d;
	}

	inline function get_length() : Int {
		return this.length;
	}

	inline function new(a : Array<Int>) {
		this = a;
	}

}
