package unifill;

/**
   Utf32 provides a UTF-32-encoded string.
 **/
abstract Utf32(Array<CodePoint>) {

	public var length(get, never) : Int;

	inline function get_length() : Int {
		return this.length;
	}

	public inline function new(string : String) : Void {
		InternalEncoding.validate(string);
		this = [for (c in new InternalEncodingIter(string, 0, string.length)) cast InternalEncoding.codePointAt(string, c)];
	}

	public inline function toUpperCase() : Utf32 {
		return cast [for (c in this) if ("a".code <= c.toInt() && c.toInt() <= "z".code) c - ("a".code - "A".code) else c];
	}

	public inline function toLowerCase() : Utf32 {
		return cast [for (c in this) if ("A".code <= c.toInt() && c.toInt() <= "Z".code) c - ("A".code - "a".code) else c];
	}

	public inline function charAt(index : Int) : Utf32 {
		if (0 <= index && index < this.length) {
			return cast [this[index]];
		} else {
			return cast [];
		}
	}

	public inline function charCodeAt(index : Int) : Null<Int> {
		if (0 <= index && index < this.length) {
			return this[index].toInt();
		}
		return null;
	}

	public inline function toString() : String {
		return InternalEncoding.fromCodePoints(cast this);
	}

	public static inline function fromCharCode(code : Int) : Utf32 {
		return cast [new CodePoint(code)];
	}

	@:op(A + B)
	public static inline function concat(a : Utf32, b : Utf32) : Utf32 {
		var s : Array<CodePoint> = cast a;
		return cast s.concat(cast b);
	}

	static function cmp(a : Array<CodePoint>, b : Array<CodePoint>) : Int {
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
	public static inline function eq(a : Utf32, b : Utf32) : Bool {
		return if (a.length != b.length) false;
		else cmp(cast a, cast b) == 0;
	}

	@:op(A != B)
	public static inline function ne(a : Utf32, b : Utf32) : Bool {
		return !eq(a, b);
	}

	@:op(A < B)
	public static inline function lt(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) < 0;
	}

	@:op(A <= B)
	public static inline function lte(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) <= 0;
	}

	@:op(A > B)
	public static inline function gt(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) > 0;
	}

	@:op(A >= B)
	public static inline function gte(a : Utf32, b : Utf32) : Bool {
		return cmp(cast a, cast b) >= 0;
	}

	@:op(A + B)
	public static inline function cons(a : CodePoint, b : Utf32) : Utf32 {
		var c : Array<CodePoint> = cast b;
		var d = c.copy();
		d.unshift(a);
		return cast d;
	}

	@:op(A + B)
	public static inline function snoc(a : Utf32, b : CodePoint) : Utf32 {
		var c : Array<CodePoint> = cast a;
		var d = c.copy();
		d.push(b);
		return cast d;
	}

}
