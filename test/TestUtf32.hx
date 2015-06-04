package test;

import unifill.CodePoint;
import unifill.Utf32;

class TestUtf32 extends haxe.unit.TestCase {

	public function test_length() {
		assertEquals(4, Utf32.fromString("𩸽あëa").length);
	}

	public function test_concat() {
		var s = Utf32.fromString("𩸽あëa");
		assertEquals("𩸽あëa𩸽あëa", (s + s).toString());
	}

	public function test_eq() {
		assertTrue(Utf32.fromString("𩸽あëa") == Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽あëaa") == Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽あëa") == Utf32.fromString("𩸽あëaa"));
		assertFalse(Utf32.fromString("𩸽あëa") == Utf32.fromString("𩸽あëb"));
		assertFalse(Utf32.fromString("𩸽あëb") == Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽") == Utf32.fromString("�"));
	}

	public function test_cons_and_snoc() {
		var c = new CodePoint(0x29E3D);
		assertTrue(Utf32.fromString("𩸽あëa") == c + Utf32.fromString("あëa"));
		assertTrue(Utf32.fromString("あëa𩸽") == Utf32.fromString("あëa") + c);
	}

}
