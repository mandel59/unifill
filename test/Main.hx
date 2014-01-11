package test;

import unifill.CodePoint;
import unifill.InternalEncoding;
import unifill.Surrogate;
import unifill.Unicode;

using unifill.Unifill;

class TestUnifill extends haxe.unit.TestCase {

	public function test_Surrogate_decodeSurrogate() {
		assertEquals(0x10000, Surrogate.decodeSurrogate(Unicode.minHighSurrogate, Unicode.minLowSurrogate));
		assertEquals(0x10FFFF, Surrogate.decodeSurrogate(Unicode.maxHighSurrogate, Unicode.maxLowSurrogate));
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

	public function test_Unifill_uSubstr() {
		assertEquals("𩸽", "𩸽あëa".uSubstr(0, 1));
		assertEquals("ë", "𩸽あëa".uSubstr(2, 1));
		assertEquals("a", "𩸽あëa".uSubstr(-1, 3));
		assertEquals("あë", "𩸽あëa".uSubstr(-3, 2));
		assertEquals("ëa", "𩸽あëa".uSubstr(2));
		assertEquals("", "𩸽あëa".uSubstr(4));
	}

	public function test_Unifill_uSubstring() {
		assertEquals("𩸽", "𩸽あëa".uSubstring(0, 1));
		assertEquals("あ", "𩸽あëa".uSubstring(2, 1));
		assertEquals("𩸽あë", "𩸽あëa".uSubstring(-1, 3));
		assertEquals("ëa", "𩸽あëa".uSubstring(2));
		assertEquals("", "𩸽あëa".uSubstring(4));
	}

	public function test_Unifill_uIterator() {
		var itr = "𩸽あëa".uIterator();
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x29E3D, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x03042, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x000EB, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x00061, itr.next());
		assertEquals(false, itr.hasNext());
	}

	public function test_Unifill_uToString() {
		//assertEquals("𩸽あëa", (cast [0x29E3D, 0x03042, 0x000EB, 0x00061] : Array<CodePoint>).uToString());
		assertEquals("𩸽あëa", [cast 0x29E3D, cast 0x03042, cast 0x000EB, cast 0x00061].uToString());
		assertEquals("𩸽あëa", {iterator: "𩸽あëa".uIterator}.uToString());
	}

}

class Main {

	static function main() {
		var r = new haxe.unit.TestRunner();
		r.add(new TestUnifill());
		r.run();
	}

}

