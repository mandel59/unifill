package test;

import unifill.Exception;
import unifill.Unicode;
import unifill.Utf16;

class TestUtf16 extends haxe.unit.TestCase {

	public function test_Unicode_decodeSurrogate() {
		assertEquals(0x10000, Unicode.decodeSurrogate(Unicode.minHighSurrogate, Unicode.minLowSurrogate));
		assertEquals(0x10FFFF, Unicode.decodeSurrogate(Unicode.maxHighSurrogate, Unicode.maxLowSurrogate));
		assertEquals(0x29E3D, Unicode.decodeSurrogate(0xD867, 0xDE3D));
	}

	public function test_fromString() {
		var u = Utf16.fromString("𩸽あëa");
		assertEquals("𩸽".code, u.codePointAt(0));
		assertEquals("あ".code, u.codePointAt(2));
		assertEquals("ë".code, u.codePointAt(3));
		assertEquals("a".code, u.codePointAt(4));
	}

	public function test_fromCodePoints() {
		var u = Utf16.fromCodePoints([
			"𩸽".code, "あ".code, "ë".code, "a".code]);
		assertEquals("𩸽".code, u.codePointAt(0));
		assertEquals("あ".code, u.codePointAt(2));
		assertEquals("ë".code, u.codePointAt(3));
		assertEquals("a".code, u.codePointAt(4));
	}

	public function test_toString() {
		var u = Utf16.fromArray([0xD867, 0xDE3D, 0x3042, 0xEB, 0x61]);
		assertEquals("𩸽あëa", u.toString());
	}

	public function test_validate() {
		function isValid(s : Utf16) : Bool {
			try {
				s.validate();
			} catch (e : Exception) {
				return false;
			}
			return true;
		}
		var a = [Unicode.encodeHighSurrogate("𩸽".code),
		         Unicode.encodeLowSurrogate("𩸽".code),
		         "あ".code,
		         "ë".code,
		         "a".code];
		assertTrue(isValid(Utf16.fromArray(a)));
		assertFalse(isValid(Utf16.fromArray(a.slice(0, 1))));
		assertFalse(isValid(Utf16.fromArray(a.slice(1))));
	}

	public function test_SurrogatePairs() {
		assertEquals("𝌆", Utf16.fromCodePoints([0xD834, 0xDF06]).toString());
	}

}
