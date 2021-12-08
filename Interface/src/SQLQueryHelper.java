import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * A helper in making SQL queries.
 * This class helsp manage automatic creation of Statements.
 * @author Hung Tran
 *
 */
public class SQLQueryHelper implements AutoCloseable {
	public static class Errors {
		public static final int
			EXISTED = 955,
			VIOLATE_CONSTRAINTS = 1
			;
	}
	private Connection conn;
	private ArrayList<Statement> statements;
	public SQLQueryHelper(Connection dbConn) {
		conn = dbConn;
		statements = new ArrayList<>();
	}
	/**
	 * Prints the result set in a concise way
	 * @param query The query used to get the answer
	 * @param answer The answer from `query`
	 * @param ignoreCols The columns to be ignored in printing out (1-indexed)
	 * @throws SQLException
	 */
	public static void printAnswer(String query, ResultSet answer,
			Collection<Integer> ignoreCols) throws SQLException 
	{
		printAnswer(query, answer, ignoreCols, System.out);
	}
	/**
	 * Prints the result set in a concise way
	 * @author L. McCann (2008-11-19; updated 2015-10-28 and 2021-10-19)
	 * @author Hung Tran modified initial idea to fit in general case
	 * 
	 * @param query the query used to get the answer
	 * @param the answer
	 * @param ignoreCols the columns to be ignored in printing out.
	 * Note that the index from SQL API is 1-indexed
	 * @param out the print stream for output
	 * @throws SQLException 
	 */
	public static void printAnswer(String query, ResultSet answer,
			Collection<Integer> ignoreCols, PrintStream out) throws SQLException {

		out.println("==============================================");
		out.println("The results of the query [" + query 
				+ "] are:");
		out.println("==============================================");
		printResultSet(answer, ignoreCols, out);
	}
	
	public static void printResultSet(ResultSet answer,
									  Collection<Integer> ignoreCols,
									  PrintStream out) throws SQLException
	{
		if (answer != null) {
			// Get the data about the query result to learn
			// the attribute names and use them as column headers

			ResultSetMetaData answermetadata = answer.getMetaData();
			int colCount = answermetadata.getColumnCount();
			int renderCount = colCount - ignoreCols.size();
			List<String> meta = new ArrayList<String>(renderCount);
			List<List<String>> data = new ArrayList<>();
			
			// read metadata
			for (int i = 1; i <= answermetadata.getColumnCount(); i++) {
				if(ignoreCols.contains(i)) {continue;}
				meta.add(answermetadata.getColumnName(i));
			}
			
			// Use next() to advance cursor through the result
			// tuples and print their attribute values
			if(answer.isBeforeFirst()) {
				answer.next();
			}
			do {
				// read data
				List<String> entry = new ArrayList<>();
				for(int i = 0; i < colCount; ++i) {
					if(ignoreCols.contains(i+1)) {continue;}
					entry.add(answer.getObject(i+1).toString());
				}
				data.add(entry);
			} while (answer.next());
			render(meta, data, out);
		} else {
			out.println("null answer");
		}
	}
	private static void renderLine(int[] rowSize, PrintStream out) {
		for(int col = 0; col < rowSize.length; ++col) {
			out.print("+-");
			for(int i = 0; i < rowSize[col]+1; ++i) {
				out.print("-");
			}
		}
		out.println("+");		
	}
	private static void renderRow(int[] rowSize, List<String> row, PrintStream out) {
		for(int col = 0; col < rowSize.length; ++col) {
			out.print("| ");
			String field = row.get(col);
			out.print(field);
			for(int i = field.length(); i < rowSize[col]+1; ++i) {
				out.print(" ");
			}
		}
		out.println("|");
	}
	private static void render(List<String> meta, List<List<String>> data,
			PrintStream out) 
	{
		int[] rowSize = new int[meta.size()];
		for (int i = 0; i < meta.size(); ++i) {
			rowSize[i] = meta.get(i).length();
		}
		for(int i = 0; i < data.size(); ++i) {
			for(int j = 0; j < data.get(i).size(); ++j) {
				rowSize[j] = Math.max(rowSize[j], data.get(i).get(j).length());
			}
		}
		// meta line
		renderLine(rowSize, out);
		// meta
		renderRow(rowSize, meta, out);
		// line
		renderLine(rowSize, out);
		// data
		for(int row = 0; row < data.size(); ++row) {
			renderRow(rowSize, data.get(row), out);
		}
		renderLine(rowSize, out);
	}
	/**
	 * Prints the result set in a concise way
	 * @param query the query used to get the answer
	 * @param the answer
	 * @throws SQLException 
	 */
	public static void printAnswer(String query, ResultSet answer) throws SQLException {
		printAnswer(query, answer, List.of());
	}
	/**
	 * Prints the result set in a concise way 
	 * @param query the query used to get the answer
	 * @param the answer
	 * @param ignoreCols the columns to be ignored in printing out.
	 * Note that the index from SQL API is 1-indexed
	 * @throws SQLException 
	 */
	public static void printAnswer(String query, ResultSet answer, Integer... ignoreCols) throws SQLException {
		printAnswer(query, answer, List.of(ignoreCols));
	}
	
	/**
	 * Handles an update query
	 * @param query the sql-formatted string of update query. 
	 * This should be INSERT, DELETE, CREATE,...
	 * @return the exact pass-down of executeUpdate(query):
	 * <p>
	 * either (1) the row count for SQL Data Manipulation Language (DML) statements 
	 * or (2) 0 for SQL statements that return nothing
	 */
	public int[] update(Collection<String> queries) {
		return update(queries, null);
	}
	/**
	 * Handles an update query
	 * @param query the sql-formatted string of update query. 
	 * This should be INSERT, DELETE, CREATE,...
	 * @param stmt the Statement to execute update from. If stmt is null,
	 * create a new statement
	 * @return the exact pass-down of executeUpdate(query):
	 * <p>
	 * either (1) the row count for SQL Data Manipulation Language (DML) statements 
	 * or (2) 0 for SQL statements that return nothing
	 */
	public int[] update(Collection<String> queries, Statement stmt) {
		String q="nein";
		int retval = -1;
		try {
			// open statement & execute the query
			if(stmt == null) {
				stmt = conn.createStatement();
			}
			for(String query: queries) {
				q = query;
				retval = stmt.executeUpdate(q);
			}
			stmt.close();
			return new int[] {retval};
		} catch (SQLException e) {
			if(e.getErrorCode() == 955) {
				// name already used;
				return new int[] {955}; // similar to catch and rethrow
			}
			if(e.getErrorCode() == 1) {
				// violate constraints
				return new int[] {1};
			}
			printSQLException(e, q);
			return new int[]{-1};
		}		
	}
	private static void printSQLException(SQLException e, String q) {
		System.err.println("*** SQLException:  "
				+ "Could not fetch query results.");
		System.err.println("\tMessage:   " + e.getMessage());
		System.err.println("\tSQLState:  " + e.getSQLState());
		System.err.println("\tErrorCode: " + e.getErrorCode());
		System.err.println("\tQuery:     " + q);
		System.err.println("\tStacktrace:");
		e.printStackTrace();
	}
	/**
	 * Handles a given string of query on this connection
	 * @param query the SQL-formatted string of query
	 * @return the result set of the query (nullable),
	 * or a null value if query yields null result.
	 */
	public ResultSet query(String query) {
		Statement stmt = null;
		ResultSet answer = null;
		try {
			// open statement & execute the query
			stmt = conn.createStatement();
			answer = stmt.executeQuery(query);
			// add the statement to the statements stack to be closed later
			// this is because answer's lifetime is bounded to statement's lifetime
			statements.add(stmt);
			return answer;
		} catch (SQLException e) {
			printSQLException(e, query);
			return null;

		}
	}
	/**
	 * Shortcut to turn a string into collection of string 
	 * suitable for update() calls
	 * @param str single sql-query string
	 * @return collection containing only `str`
	 */
	public static Collection<String> batch(String... str) {
		return List.of(str);
	}
	/**
	 * Creates an empty table.
	 * @param tableName the name of the new table.
	 * @param tableDecl the string declaring the table
	 * @return the result of the new table query
	 */
	public int newTable(String tableName, String tableDecl) {
		int[] retval = update(batch(createTableQuery(tableName, tableDecl),
				grantQuery(tableName)));
		return retval[retval.length-1];
	}
	/**
	 * Creates a new table, migrate all data into it.
	 * @param tableName the name of the new table
	 * @param csv the csv file location
	 * @return the result of the last query in this function.
	 * @throws FileNotFoundException 
	 */
	public int[] newTable(String tableName, String tableDecl, String csv) throws FileNotFoundException {
		return newTable(tableName, tableDecl, csv, Integer.MAX_VALUE);
	}
	/**
	 * Creates a new table, migrate first head data into it.
	 * @param tableName the name of the new table
	 * @param csv the csv file location
	 * @param head # first elements to choose from csv file
	 * @return the result of the last query in this function.
	 * @throws FileNotFoundException 
	 */
	public int[] newTable(String tableName, String tableDecl, String csv, int head) 
			throws FileNotFoundException 
	{
		int newTableRes = newTable(tableName, tableDecl);
//		if(newTableRes == 955) {
//			// table name existed
//			System.out.println(tableName+" existed. Dropping and adding back again");
//			// drop the table and add it back again.
//			update(batch("DROP TABLE " +tableName));
//			return newTable(tableName, csv, head);
//		}
		CSVTransformer transformer = new CSVTransformer(csv);
		int retval = newTableRes;
		ArrayList<String> queries = new ArrayList<>();
		int line = 0;
		while(transformer.hasNextEntry()) {
			++line;
			String query = "INSERT INTO "+tableName+" values ("
					+ transformer.nextTransformedLine()+")";
			queries.add(query);
			if(line >= head) {break;}
		}
		return update(queries);
	}
	private static String grantQuery(String tableName) {
		return "GRANT SELECT ON "+tableName+" TO PUBLIC";
	}
	/**
	 * Helper method to generate a string for a new table sql-query
	 * @param tableName the name of the new table
	 * @param tableDecl the String of the table declaration
	 * @return the string sql-query to create a new table under `tableName`
	 */
	private static String createTableQuery(String tableName, String tableDecl) {
		return "CREATE TABLE "+tableName+" (" + tableDecl
				+ ")";
	}
	/**
	 * Simple example function for createTableQuery
	 * @param tableName
	 * @return
	 */
	private static String exampleTableQuery(String tableName) {
		String decl = 
				  "district_num     integer,\n"
				+ "district_name    varchar2(30),\n"
				+ "school_num       integer,\n"
				+ "school_name      varchar2(50),\n"
				+ "students_count   integer,\n"
				+ "mean_scale_score integer,\n"
				+ "ge_lvl_3_pct     integer,\n"
				+ "lvl_1_pct        integer,\n"
				+ "lvl_2_pct        integer,\n"
				+ "lvl_3_pct        integer,\n"
				+ "lvl_4_pct        integer,\n"
				+ "lvl_5_pct        integer,\n"
				+ "primary key (district_num, school_num)";
		return createTableQuery(tableName, decl);
	}
	/**
	 * Closes all connections
	 * @throws SQLException if there is any problem closing any statement or connection
	 */
	public void close() throws SQLException {
		while(!statements.isEmpty()) {
			Statement st = statements.remove(statements.size()-1);
			st.close();
		}
		conn.close();
	}
}
