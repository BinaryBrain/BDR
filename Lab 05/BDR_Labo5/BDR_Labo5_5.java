/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BDR_Labo5;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.*;
import java.io.*;
import java.util.LinkedList;
import java.util.*;

/**
 * @author Simon Baehler, Sacha Bron
 */
public class BDR_Labo5_5 {
	/**
	 * retourne l'object choisie parmi les r�sultat de la requete
	 */
	public static void main(String[] args) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String url = "jdbc:mysql://localhost:3306/sakila";
		String utilisateur = "root";
		String motDePasse = "";
		
		try {
			conn = DriverManager.getConnection(url, utilisateur, motDePasse);
			stmt = conn.createStatement();

			// Exercice 5
			System.out.println("\n --- Exercice 5 ---");
			String sqlDropView = " DROP VIEW IF EXISTS revenu_par_localite";
			Statement stDropView = conn.createStatement();
			stDropView.executeUpdate(sqlDropView);

			String sqlCreateView = "CREATE VIEW revenu_par_localite AS \n"
					+ "SELECT ci.city,A.postal_code,CO.country,SUM(amount) \n"
					+ "	FROM payment AS P \n" + "	INNER JOIN rental AS R \n"
					+ "		ON R.rental_id = P.rental_id \n"
					+ "	INNER JOIN customer AS C \n"
					+ "		ON P.customer_id = C.customer_id \n"
					+ "	INNER JOIN address AS A \n"
					+ "		ON a.address_id = C.address_id \n"
					+ "	INNER JOIN city as Ci \n"
					+ "		ON Ci.city_id = A.city_id \n"
					+ "	INNER JOIN country AS CO \n"
					+ "		ON Co.country_id = Ci.country_id \n"
					+ "	group by ci.city";

			Statement stCreateView = conn.createStatement();
			stCreateView.executeUpdate(sqlCreateView);

			try {
				String country = "";
				String sqlRevenuContry;
				BufferedReader bufferRead = new BufferedReader(
						new InputStreamReader(System.in));
				System.out.println("Entez un nom de pays:");
				country = bufferRead.readLine();
				sqlRevenuContry = "SELECT * FROM `revenu_par_localite` where `country` = '"
						+ country + "'";
				ResultSet revenueRS = stmt.executeQuery(sqlRevenuContry);

				System.out.println("les r�sultats sont :\n");
				while (revenueRS.next()) {
					for (int i = 1; i < revenueRS.getMetaData()
							.getColumnCount(); i++) {
						String col = revenueRS.getMetaData().getColumnName(i);
						String title = revenueRS.getString(col);
						System.out.print(title + " ");
					}
					System.out.println();
				}

			} catch (IOException e) {
				e.printStackTrace();
			}

		} catch (SQLException ex) {
			ex.printStackTrace();

		} finally {
			// Step 5: Always free resources
			try {
				if (stmt != null) {
					stmt.close(); // This closes ResultSet too
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}
	}

}
