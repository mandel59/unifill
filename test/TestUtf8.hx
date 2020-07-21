package test;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import unifill.Exception;
import unifill.Utf8;

class TestUtf8 extends haxe.unit.TestCase {

	public function test_fromString() {
		var u = Utf8.fromString("𩸽あëa");
		assertEquals("𩸽".code, u.codePointAt(0));
		assertEquals("あ".code, u.codePointAt(4));
		assertEquals("ë".code, u.codePointAt(7));
		assertEquals("a".code, u.codePointAt(9));
	}

	public function test_fromCodePoints() {
		var u = Utf8.fromCodePoints([
			"𩸽".code, "あ".code, "ë".code, "a".code]);
		assertEquals("𩸽".code, u.codePointAt(0));
		assertEquals("あ".code, u.codePointAt(4));
		assertEquals("ë".code, u.codePointAt(7));
		assertEquals("a".code, u.codePointAt(9));
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
		function isValid(b : Bytes) : Bool {
			try {
				var s = Utf8.fromBytes(b); // some targets natively implement proper check and throw exceptions here
				s.validate();
			} catch (e : Exception) {
				return false;
			}
			return true;
		}
		/* each of false_cases is well-formed UTF-8 */
		var true_cases = [
			/* "𩸽あëa" */
			[0xf0, 0xa9, 0xb8, 0xbd, 0xe3, 0x81, 0x82, 0xc3, 0xab, 0x61],
			/* U+D7FF */
			[0xed, 0x9f, 0xbf],
			/* U+E000 */
			[0xee, 0x80, 0x80],
			/* U+10FFFF, the last code point of Unicode. */
			[0xf4, 0x8f, 0xbf, 0xbf]
		];
		/* each of false_cases is ill-formed UTF-8 */
		var false_cases = [
			/* a byte is missing */
			[0xf0, 0xa9, 0xb8, 0xbd, 0xe3, 0x81, /* 0x82 is missing here */ 0xc3, 0xab, 0x61],
			/* redundant UTF-8 encoding of "/" U+002F SOLIDUS */
			[0xc0, 0xaf],
			/* U+D800, which is the first high (lead) surrogate, in WTF-8.
				See: https://simonsapin.github.io/wtf-8/#surrogate-byte-sequence */
			[0xed, 0xa0, 0x80],
			/* U+DFFF, which is the last low (trail) surrogate, in WTF-8. */
			[0xed, 0xbf, 0xbf],
			/* U+110000, the first code point of Plane 17 in obsolete UCS-4. */
			[0xf4, 0x90, 0x80, 0x80]
		];
		for (c in true_cases) {
			assertTrue(isValid(a2b(c)));
		}
		for (c in false_cases) {
			assertFalse(isValid(a2b(c)));
		}
	}

}
