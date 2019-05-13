package test;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import unifill.Exception;
import unifill.Utf8;

class TestUtf8 extends haxe.unit.TestCase {

	public function test_fromString() {
		var u = Utf8.fromString("𩸽あëa");
		// I expect having different indexes for different platforms is wrong.
		var index = 
		#if (neko || js || python || hl)
		[0, 4, 7, 9];
		#else
		[0, 1, 2, 3];
		#end
		assertEquals("𩸽".code, u.codePointAt(index[0]));
		assertEquals("あ".code, u.codePointAt(index[1]));
		assertEquals("ë".code, u.codePointAt(index[2]));
		assertEquals("a".code, u.codePointAt(index[3]));
	}

	public function test_fromCodePoints() {
		var codepoints = ["𩸽".code, "あ".code, "ë".code, "a".code];
		var u = Utf8.fromCodePoints(codepoints);
		var index = 
		#if (neko || js || python || hl)
		[0, 4, 7, 9];
		#else
		[0, 1, 2, 3];
		#end
		assertEquals("𩸽".code, u.codePointAt(index[0]));
		assertEquals("あ".code, u.codePointAt(index[1]));
		assertEquals("ë".code, u.codePointAt(index[2]));
		assertEquals("a".code, u.codePointAt(index[3]));
	}

	public function test_toString() {
		var buf = new BytesBuffer();
		for (x in [0xf0, 0xa9, 0xb8, 0xbd, 0xe3, 0x81, 0x82, 0xc3, 0xab, 0x61]) {
			buf.addByte(x);
		}
		var u = Utf8.fromBytes(buf.getBytes());
		assertEquals("𩸽あëa", u.toString());
	}

	public function test_validate() {
		function a2b(a : Array<Int>) : Bytes {
			var buf = Bytes.alloc(a.length);
			for (i in 0...a.length) {
				buf.set(i, a[i]);
			}
			return buf;
		}
		function isValid(s : Utf8) : Bool {
			try {
				s.validate();
			} catch (e : Exception) {
				return false;
			}
			return true;
		}
		var true_cases = [
			[0xf0, 0xa9, 0xb8, 0xbd, 0xe3, 0x81, 0x82, 0xc3, 0xab, 0x61],
			[0xed, 0x9f, 0xbf],
			[0xee, 0x80, 0x80],
			[0xf4, 0x8f, 0xbf, 0xbf]
		];
		var false_cases = [
			[0xf0, 0xa9, 0xb8, 0xbd, 0xe3, 0x81, 0xc3, 0xab, 0x61],
			[0xc0, 0xaf],
			[0xed, 0xa0, 0x80],
			[0xed, 0xbf, 0xbf],
			[0xf4, 0x90, 0x80, 0x80]
		];
		for (c in true_cases) {
			var u = Utf8.fromBytes(a2b(c));
			assertTrue(isValid(u));
		}
		for (c in false_cases) {
			var u = Utf8.fromBytes(a2b(c));
			assertFalse(isValid(u));
		}
	}

}
