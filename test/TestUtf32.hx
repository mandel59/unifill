package test;

import unifill.CodePoint;
import unifill.Utf32;
using unifill.UtfTools;

class TestUtf32 extends haxe.unit.TestCase {

	public function test_length() {
		assertEquals(4, Utf32.fromString("𩸽あëa").length);
	}

	public function test_compare() {
		var s0 = Utf32.fromString("𩸽あëa");
		var s1 = Utf32.fromString("𩸽あëaa");
		var s2 = Utf32.fromString("𩸽あëb");
		var s3 = Utf32.fromString("𩸽");
		var s4 = Utf32.fromString("�");
		assertTrue(s0.compare(s0) == 0);
		assertTrue(s0.compare(s1) < 0);
		assertTrue(s1.compare(s0) > 0);
		assertTrue(s0.compare(s2) < 0);
		assertTrue(s2.compare(s0) > 0);
		assertTrue(s3.compare(s4) > 0);
	}

#if false

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

	public function test_lt() {
		assertFalse(Utf32.fromString("𩸽あëa") < Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽あëaa") < Utf32.fromString("𩸽あëa"));
		assertTrue(Utf32.fromString("𩸽あëa") < Utf32.fromString("𩸽あëaa"));
		assertTrue(Utf32.fromString("𩸽あëa") < Utf32.fromString("𩸽あëb"));
		assertFalse(Utf32.fromString("𩸽あëb") < Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽") < Utf32.fromString("�"));
	}

	public function test_lte() {
		assertTrue(Utf32.fromString("𩸽あëa") <= Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽あëaa") <= Utf32.fromString("𩸽あëa"));
		assertTrue(Utf32.fromString("𩸽あëa") <= Utf32.fromString("𩸽あëaa"));
		assertTrue(Utf32.fromString("𩸽あëa") <= Utf32.fromString("𩸽あëb"));
		assertFalse(Utf32.fromString("𩸽あëb") <= Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽") <= Utf32.fromString("�"));
	}

	public function test_gt() {
		assertFalse(Utf32.fromString("𩸽あëa") > Utf32.fromString("𩸽あëa"));
		assertTrue(Utf32.fromString("𩸽あëaa") > Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽あëa") > Utf32.fromString("𩸽あëaa"));
		assertFalse(Utf32.fromString("𩸽あëa") > Utf32.fromString("𩸽あëb"));
		assertTrue(Utf32.fromString("𩸽あëb") > Utf32.fromString("𩸽あëa"));
		assertTrue(Utf32.fromString("𩸽") > Utf32.fromString("�"));
	}

	public function test_gte() {
		assertTrue(Utf32.fromString("𩸽あëa") >= Utf32.fromString("𩸽あëa"));
		assertTrue(Utf32.fromString("𩸽あëaa") >= Utf32.fromString("𩸽あëa"));
		assertFalse(Utf32.fromString("𩸽あëa") >= Utf32.fromString("𩸽あëaa"));
		assertFalse(Utf32.fromString("𩸽あëa") >= Utf32.fromString("𩸽あëb"));
		assertTrue(Utf32.fromString("𩸽あëb") >= Utf32.fromString("𩸽あëa"));
		assertTrue(Utf32.fromString("𩸽") >= Utf32.fromString("�"));
	}

	public function test_cons_and_snoc() {
		var c = new CodePoint(0x29E3D);
		assertTrue(Utf32.fromString("𩸽あëa") == c + Utf32.fromString("あëa"));
		assertTrue(Utf32.fromString("あëa𩸽") == Utf32.fromString("あëa") + c);
	}

#end

}