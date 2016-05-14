using System.Collections.Generic;

namespace com.finegamedesign.utils
{
	public sealed class DataUtil
	{
		// http://stackoverflow.com/questions/222598/how-do-i-clone-a-generic-list-in-c
		public static List<T> CloneList<T>(List<T> original)
		{
			return new List<T>(original);
		}
	}
}
