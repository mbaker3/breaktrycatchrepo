package com.breaktrycatch.collection.util 
{
	import flash.utils.Dictionary;
	/**
	 * @author plemarquand
	 */
	public class DictionaryExtensions 
	{
		/**
		 * Joins the contents of n dictionaries and returns a new one. If a duplicate key is found,
		 * a warning trace is output and the value in the Dictionary passed in
		 * last is used. If all of supplied arguments are not Dictionaries an
		 * error is thrown.
		 * @param args A list of dictionarys to join.
		 * @return A new dictionary containing the elements of the supplied Dictionaries.
		 */
		public static function join(...args) : Dictionary
		{
			var dict : Dictionary = new Dictionary( );
			var combine : Function = function(item : *, key : *,...args):void
			{
				if(dict[key])
				{
					trace( "Warning: Duplicate key found. ", key );
				}
				dict[key] = item;
			};
			
			var len : int = args.length;
			for ( var i : Number = 0; i < len ; i++ ) 
			{
				if(args[i] is Dictionary)
				{
					forEach( args[i], combine );
				}
				else
				{
					throw new ArgumentError( "All supplied arguments must be a Dictionary" );
				}
			}
			return dict;
		}
		/**
		 * Iterates over every element in a dictionary and runs the supplied function
		 * on it. It is the Dictionary equivalent of Array.forEach(). 
		 * The supplied function must have the signature: <code>function(item : *, key : *, dict : Dictionary):void;</code>.
		 * @param dict A dictionary to run the function on.
		 * @param closure A function to be run on each element in the dictionary.
		 */
		public static function forEach(dict : Dictionary, callback : Function) : void
		{
			for (var i : * in dict) 
			{
				callback( dict[i], i, dict );
			}
		}
		/**
		 * Combines two arrays, using the first one's values as they Dictionary's
		 * keys and the second one's values as the values. Both arrays must be
		 * of equal length.
		 * @param keyArr An array of keys to use in the Dictionary.
		 * @param valueArr An array of values to use in the Dictionary.
		 * @return A dictionary composed of the keyArr for keys, and the valueArr for values.
		 */
		public static function arrayCombine(keyArr : Array, valueArr : Array, weakKeys : Boolean = false) : Dictionary
		{
			if(keyArr.length != valueArr.length || keyArr.length == 0)
			{
				throw new ArgumentError( "Key array and value array must be of the same length and not empty." );
			}
			
			var dict : Dictionary = new Dictionary( weakKeys );
			var len : int = keyArr.length;
			for ( var i : Number = 0; i < len ; i++ ) 
			{
				dict[keyArr[i]] = valueArr[i];
			}
			return dict;
		}
		/**
		 * Deletes all values in a dictionary.
		 * @param dict A dictionary to clear.
		 */
		public static function clear(dict : Dictionary) : void
		{
			for (var key: * in dict)
			{
				delete dict[key];
			}
		}
		/**
		 * Creates a new array from the keys in a dictionary.
		 * @param dict A Dictionary from which to draw the keys.
		 * @return An array of the Dictionary's keys.
		 */
		public static function keys(dict : Dictionary) : Array
		{
			var arr : Array = [];
			for (var i : * in dict) 
			{
				arr.push( i );
			}
			return arr;
		}
		/**
		 * Creates a new array from the values in a dictionary.
		 * @param dict A Dictionary from which to draw the values.
		 * @return An array of the Dictionary's values.
		 */
		public static function values(dict : Dictionary) : Array
		{
			var arr : Array = [];
			for (var i : * in dict) 
			{
				arr.push( dict[i] );
			}
			return arr;
		}
		/**
		 * Converts the supplied array to a dictionary. Keys can be generated by
		 * a key function, which returns a string. If no key function is supplied,
		 * the integer index of the item is used as its key.
		 * @param arr The array to convert to a dictionary.
		 * @param keyFunc A function used to generate keys based on the contents of the array.
		 * @param weakKeys If the dictionary should use weakly referenced keys.
		 * @return A dictionary contianing the elements of the array.
		 */
		public static function toDictionary(arr : Array, keyFunc : Function = null, weakKeys : Boolean = false) : Dictionary
		{
			var dict : Dictionary = new Dictionary( weakKeys );
			for (var i : * in arr) 
			{
				dict[(keyFunc != null) ? (keyFunc( arr[i], i, arr )) : (i)] = arr[i];
			}
			return dict;
		}
		/**
		 * Calculates the number of elements in a dictionary.
		 * @param dict A Dictionary whose length you wish to know.
		 * @return The length of the Dictionary.
		 */
		public static function length(dict : Dictionary) : int
		{
			return keys( dict ).length;
		}
		
		/**
		 * Determines if the Dictionary is empty.
		 * @param dict A dictionary to check.
		 * @return If the dictionary has any elements in it.
		 */
		public static function hasValues(dict : Dictionary) : Boolean
		{
			for (var i : * in dict) 
			{
				return true;
			}
			return false;
		}
	}
}
