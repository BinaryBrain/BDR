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

/**
 * @author Simon Baehler, Sacha Bron
 */
public class BDR_Labo5_1 {
	/**
	 * retourne l'object choisie parmi les résultat de la requete
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

			// Exercie 1
			System.out.println("--- Exercice 1 ---");
			rs = stmt.executeQuery("SELECT * FROM film LIMIT 10");
			System.out.println("Les résultats sont :");

			while (rs.next()) {
				for (int i = 1; i < rs.getMetaData().getColumnCount(); i++) {
					String col = rs.getMetaData().getColumnName(i);
					String title = rs.getString(col);

					String separator = (i > 1) ? " | " : "";

					System.out.print(separator + title);
				}

				System.out.println();
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
