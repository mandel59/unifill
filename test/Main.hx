package test;

import unifill.CodePoint;
import unifill.InternalEncoding;
import unifill.Surrogate;
import unifill.Unicode;

using unifill.Unifill;

class TestUnifill extends haxe.unit.TestCase {

	public function test_Surrogate_decodeSurrogate() {
		assertEquals(0x10000, Surrogate.decodeSurrogate(cast Unicode.minHighSurrogate, cast Unicode.minLowSurrogate));
		assertEquals(0x10FFFF, Surrogate.decodeSurrogate(cast Unicode.maxHighSurrogate, cast Unicode.maxLowSurrogate));
		assertEquals(0x29E3D, Surrogate.decodeSurrogate(0xD867, 0xDE3D));
	}

	public function test_InternalEncoding_newStringFromCodePoints() {
		assertEquals("𩸽あëa", InternalEncoding.newStringFromCodePoints([0x29E3D, 0x03042, 0x000EB, 0x00061]));
	}

	public function test_Unifill_uLength() {
		assertEquals(4, "𩸽あëa".uLength());
	}

	public function test_Unifill_uCharAt() {
		assertEquals("𩸽", "𩸽あëa".uCharAt(0));
		assertEquals("あ", "𩸽あëa".uCharAt(1));
		assertEquals("ë", "𩸽あëa".uCharAt(2));
		assertEquals("a", "𩸽あëa".uCharAt(3));
	}

	public function test_Unifill_uCodePointAt() {
		assertEquals(cast 0x29E3D, "𩸽あëa".uCodePointAt(0));
		assertEquals(cast 0x03042, "𩸽あëa".uCodePointAt(1));
		assertEquals(cast 0x000EB, "𩸽あëa".uCodePointAt(2));
		assertEquals(cast 0x00061, "𩸽あëa".uCodePointAt(3));
	}

	public function test_Unifill_uIndexOf() {
		assertEquals(0, "𩸽あëa".uIndexOf("𩸽"));
		assertEquals(1, "𩸽あëa".uIndexOf("あ"));
		assertEquals(2, "𩸽あëa".uIndexOf("ë"));
		assertEquals(3, "𩸽あëa".uIndexOf("a"));
		assertEquals(-1, "𩸽あëa".uIndexOf("z"));
		assertEquals(-1, "𩸽あëa".uIndexOf("𩸽", 1));
		assertEquals(1, "𩸽あëa".uIndexOf("あ", 1));
	}

	public function test_Unifill_uLastIndexOf() {
		assertEquals(0, "𩸽あëa".uLastIndexOf("𩸽"));
		assertEquals(1, "𩸽あëa".uLastIndexOf("あ"));
		assertEquals(2, "𩸽あëa".uLastIndexOf("ë"));
		assertEquals(3, "𩸽あëa".uLastIndexOf("a"));
		assertEquals(-1, "𩸽あëa".uLastIndexOf("z"));
		assertEquals(0, "𩸽あëa".uLastIndexOf("𩸽", 1));
		assertEquals(1, "𩸽あëa".uLastIndexOf("あ", 1));
		assertEquals(-1, "𩸽あëa".uLastIndexOf("ë", 1));
	}

	public function test_Unifill_uToString() {
		//assertEquals("𩸽あëa", (cast [0x29E3D, 0x03042, 0x000EB, 0x00061] : Array<CodePoint>).uToString());
		assertEquals("𩸽あëa", [cast 0x29E3D, cast 0x03042, cast 0x000EB, cast 0x00061].uToString());
	}

}

class Main {

	static function main() {
		var r = new haxe.unit.TestRunner();
		r.add(new TestUnifill());
		r.run();
	}

}

