package test;

import unifill.InternalEncodingIter;

class TestInternalEncodingIter extends haxe.unit.TestCase {

	public function test_InternalEncodingIter() {
		var s = "𩸽あëa";
		var itr = new InternalEncodingIter(s, 0, s.length);
	#if (neko || php || cpp || macro)
		var index = [0, 4, 7, 9, 10];
	#elseif python
		var index = [0, 1, 2, 3, 4];
	#else
		var index = [0, 2, 3, 4, 5];
	#end
		assertTrue(itr.hasNext());
		assertEquals(index[0], itr.next());
		assertTrue(itr.hasNext());
		assertEquals(index[1], itr.next());
		assertTrue(itr.hasNext());
		assertEquals(index[2], itr.next());
		assertTrue(itr.hasNext());
		assertEquals(index[3], itr.next());
		assertFalse(itr.hasNext());
		assertEquals(index[4], itr.index);
	}

}
