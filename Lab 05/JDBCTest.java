import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

// use JDK 6 and above
public class JDBCTest {
	
	public static void main(String[] args) {
		
		Connection conn = null;
		Statement  stmt = null;
		
		try {
			// Step 1: Allocate a database "Connection" object
			// TO
			conn = DriverManager.getConnection("TO COMPLETE");
 
			// Step 2: Allocate a "Statement" object in the Connection
			// TO COMPLETE
			
			// Step 3: Execute a SQL SELECT query, the query result
			// is returned in a "ResultSet" object.
			// TO COMPLETE	
 
			// Step 4: Process the ResultSet by scrolling the cursor forward via next().
			// For each row, retrieve the contents of the cells with getXxx(columnName).
			// TO COMPLETE
			
			// code to read from console 
			/*
			try {
				System.out.println("Enter something here:");
				BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
				String test = bufferRead.readLine();
				System.out.println("You entered " + test);
			}			
			catch(IOException e)
			{
				e.printStackTrace();
			}
		    */
		    		    
		} catch(SQLException ex) {
			ex.printStackTrace();
			
		} finally {
			// Step 5: Always free resources
			try {
				if (stmt != null) stmt.close();  // This closes ResultSet too
				if (conn != null) conn.close();
			} catch(SQLException ex) {
				ex.printStackTrace();
			}
		}
	}
}