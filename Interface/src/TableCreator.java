import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * Creates the table as described in the Diagram (might not be updated to the latest one)
 * @see https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1&title=erd.drawio#Uhttps%3A%2F%2Fraw.githubusercontent.com%2Fhungtr-uofa%2FCSC460_DMV_Database%2Fmaster%2Ferd.drawio
 * 
 * @author Hung Tran
 *
 */
public abstract class TableCreator implements AutoCloseable {
	protected Map<String, String> tableNameToTableFields;
	protected SQLQueryHelper helper;
	public TableCreator(Map<String, String> tableNameToFields, SQLQueryHelper helper) {
		tableNameToTableFields = tableNameToFields;
		this.helper = helper;
	}
	public TableCreator(SQLQueryHelper helper) {this(new HashMap<>(), helper);}
	/**
	 * Finds the content of this table
	 * @param tableName
	 * @return
	 */
	public String findTableContent(String tableName) {
		return tableNameToTableFields.get(tableName);
	}
	/**
	 * Adds a new table
	 * @param tableName
	 * @param content
	 */
	public void newTable(String tableName, String content) {
		tableNameToTableFields.put(tableName, content);
	}
	public Map<String, Failed<Table>> createAll() {
		Map<String, Failed<Table>> retval = new HashMap<>();
		for(var e: tableNameToTableFields.entrySet()) {
			String tableName = e.getKey();
			String tableContent = e.getValue();
			int queryErr = helper.newTable(tableName, tableContent);
			Failed<Table> tab;
			if(queryErr != 0) {
				System.err.println("Failed to create "+tableName+" errcode: "+queryErr);
				tab = Failed.err(queryErr);
			} else {
				
			}
		}
	}
	public void close() throws SQLException {
		helper.close();
	}
}
