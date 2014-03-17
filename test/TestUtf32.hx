package test;

import unifill.CodePoint;
import unifill.Utf32;

class TestUtf32 extends haxe.unit.TestCase {

	public function test_length() {
		assertEquals(4, new Utf32("𩸽あëa").length);
	}

	public function test_concat() {
		//assertEquals("𩸽あëa𩸽あëa", (new Utf32("𩸽あëa") + new Utf32("𩸽あëa")).toString());
		var s = new Utf32("𩸽あëa");
		assertEquals("𩸽あëa𩸽あëa", (s + s).toString());
	}

	public function test_eq() {
		assertTrue(new Utf32("𩸽あëa") == new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëaa") == new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëa") == new Utf32("𩸽あëaa"));
		assertFalse(new Utf32("𩸽あëa") == new Utf32("𩸽あëb"));
		assertFalse(new Utf32("𩸽あëb") == new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽") == new Utf32("�"));
	}

	public function test_lt() {
		assertFalse(new Utf32("𩸽あëa") < new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëaa") < new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëa") < new Utf32("𩸽あëaa"));
		assertTrue(new Utf32("𩸽あëa") < new Utf32("𩸽あëb"));
		assertFalse(new Utf32("𩸽あëb") < new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽") < new Utf32("�"));
	}

	public function test_lte() {
		assertTrue(new Utf32("𩸽あëa") <= new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëaa") <= new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëa") <= new Utf32("𩸽あëaa"));
		assertTrue(new Utf32("𩸽あëa") <= new Utf32("𩸽あëb"));
		assertFalse(new Utf32("𩸽あëb") <= new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽") <= new Utf32("�"));
	}

	public function test_gt() {
		assertFalse(new Utf32("𩸽あëa") > new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëaa") > new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëa") > new Utf32("𩸽あëaa"));
		assertFalse(new Utf32("𩸽あëa") > new Utf32("𩸽あëb"));
		assertTrue(new Utf32("𩸽あëb") > new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽") > new Utf32("�"));
	}

	public function test_gte() {
		assertTrue(new Utf32("𩸽あëa") >= new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëaa") >= new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëa") >= new Utf32("𩸽あëaa"));
		assertFalse(new Utf32("𩸽あëa") >= new Utf32("𩸽あëb"));
		assertTrue(new Utf32("𩸽あëb") >= new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽") >= new Utf32("�"));
	}

	public function test_cons_and_snoc() {
		var c = new CodePoint(0x29E3D);
		assertTrue(new Utf32("𩸽あëa") == c + new Utf32("あëa"));
		assertTrue(new Utf32("あëa𩸽") == new Utf32("あëa") + c);
	}

}