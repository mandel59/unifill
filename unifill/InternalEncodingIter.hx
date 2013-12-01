package unifill;

class InternalEncodingIter {

	public var string : String;
	public var index : Int;

	public function new(s : String, i : Int) {
		string = s;
		index = i;
	}

	public inline function hasNext() : Bool {
		return index < string.length;
	}

	public inline function next() : Int {
	#if (neko || php || cpp || macro)
		var i = index;
		var c = string.charCodeAt(index);
		if(c < 0x80) {
			++index;
		} else if(c < 0xE0) {
			index += 2;
		} else if(c < 0xF0) {
			index += 3;
		} else {
			index += 4;
		}
		return i;
	#elseif java
		var i = index;
		var c = string.charCodeAt(index);
		++index;
		if ((cast c : CodePoint) > Unicode.maxBMP) {
			++index;
		}
		return i;
	#else
		var i = index;
		var c = string.charCodeAt(index);
		++index;
		if (Surrogate.isHighSurrogate(c)) {
			++index;
		}
		return i;
	#end
	}

}
