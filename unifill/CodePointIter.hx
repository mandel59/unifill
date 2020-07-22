package unifill;

class CodePointIter {

	var string : String;
	var index : Int;
	var endIndex : Int;

	public inline function new(s : String) {
		string = s;
		index = 0;
		endIndex = InternalEncoding.length(s);
	}

	public inline function hasNext() : Bool {
		return index < endIndex;
	}

	var i = 0; // FIXME: blocked by HaxeFoundation/haxe#4353
	public inline function next() : CodePoint {
		i = index;
		index += InternalEncoding.codePointWidthAt(string, index);
		return cast InternalEncoding.codePointAt(string, i);
	}

}
