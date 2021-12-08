import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * A simple class that transform CSV data into insert-ready SQL query string
 * @author Hung Tran
 *
 */
public class CSVTransformer {
	public static enum Type {
		INT, STRING
	}	
	private Scanner s;
	private Type[] types;
	private static final Type[] DEF_TYPES = 
			new Type[] {Type.INT, Type.STRING, Type.INT, Type.STRING,
			Type.INT, Type.INT, Type.INT, Type.INT,
			Type.INT, Type.INT, Type.INT, Type.INT};
	
	public CSVTransformer(Scanner s, Type[] types) {
		this.s = s;
		this.types = types;
	}
	public CSVTransformer(Scanner s) {
		this(s, DEF_TYPES);
	}
	public CSVTransformer(String csvFile) throws FileNotFoundException {
		this(new Scanner(new File(csvFile)), DEF_TYPES);
	}
	static String clean(String str) {
		String filtered = str.replaceAll("[^\\p{Alnum}\\p{Blank}\\p{Punct}]", "");
		// now escape
		String escaped = filtered.replaceAll("\'","\'\'");
		return escaped;
	}
	String nextString(String[] splited, int[] i) {
		String out = clean(splited[i[0]]);
		StringBuilder str = new StringBuilder(out);
		if(str.charAt(0) == '\"') {
			if(str.charAt(str.length()-1) != '\"') {
				// only do the for loop if this string does not end in literal opening
				++i[0];
				// iteratively add into string builder the fields separated by ,
				for(; ; i[0]+=1) {
					str.append(',');
					str.append(clean(splited[i[0]]));
					if(splited[i[0]].endsWith("\"")) {
						break;
					}
				}
			}
			// output except the first and last '\"'
			out = str.substring(1, str.length()-1);
		}
		// move to next token
		i[0]+=1;
		return out;
	}
	Integer nextInt(String[] splited, int[] i) {
		String nextStr = nextString(splited, i);
		if(nextStr.equals("NULL")) {
			return null;
		}
		try {
			// prettify entries like "1, 029" -> "1029"
			nextStr = nextStr.replaceAll("[\\p{Blank}\\p{Punct}]", "");
			Integer x = Integer.parseInt(nextStr);
			return x;
		} catch (NumberFormatException e) {
			System.err.println("splited: " + String.join(", ", splited));
			e.printStackTrace();
			System.exit(-1);
		}
		return null;
	}
	String next(Type type, String[] splited, int[] i) {
		switch(type) {
		case INT:
			Integer val = nextInt(splited, i);
			return val == null? "NULL": String.valueOf(val);
		case STRING:
			return "\'"+nextString(splited, i)+"\'";
		default:
			throw new RuntimeException("Error type");
		}
	}
	/**
	 * Get the next line transformed to sql insert-ready string
	 * @return next line in s being transformed to sql insert-ready string
	 */
	public String nextTransformedLine() {
		if(!s.hasNext()) {return null;}
		// read the line
		String line = s.nextLine();
		// split the line by ','
		String[] splited = line.split(",");
		// sneaky java way to pass-by-reference. This is needed to increment index of splited
		int[] ix = {0};
		StringBuilder builder = new StringBuilder();
		for(int i = 0; i < types.length; ++i) {
			// iteratively parse next values based on types declared
			String nextStr = next(types[i], splited, ix); 
			builder.append(nextStr);
			if(i < types.length-1) {
				// append ',' only if it is not the last string
				builder.append(',');
			}
		}
		return builder.toString();
	}
	/**
	 * @return Whether the scanner has next entry in the csv database
	 */
	public boolean hasNextEntry() {
		return s.hasNextLine();
	}
	/**
	 * Minimal edge case testing code
	 * @param args ignored args
	 * @throws FileNotFoundException 
	 */
	public static void main(String[] args) throws FileNotFoundException {
		String testString = 
				"66,\"WALTON\",1111,\"WALTON\'s ACADEMY, INC.\",33,464,12,NULL,21,12,0,0";
		CSVTransformer trans = new CSVTransformer(new Scanner(testString));
		System.out.println(trans.nextTransformedLine());
		
		System.out.println("Parsing csv");
		CSVTransformer tr = new CSVTransformer("40Sp17GeoSRS.csv");
		final int heads = 50;
		int i = 0;
		while(tr.hasNextEntry()) {
			++i;
			System.out.println(tr.nextTransformedLine());
			if(i >= heads) {break;}
		}
		System.out.println("nlines: " + i);
	}

}
