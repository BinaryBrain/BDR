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

/**
 * @author Simon Baehler, Sacha Bron
 */
public class BDR_Labo5_4 {
	/**
	 * retourne l'object choisie parmi les résultat de la requete
	 */
	public static void main(String[] args) {
		Connection conn = null;
		Statement stmt = null;
		String url = "jdbc:mysql://localhost:3306/sakila";
		String utilisateur = "root";
		String motDePasse = "";
		
		try {
			conn = DriverManager.getConnection(url, utilisateur, motDePasse);
			stmt = conn.createStatement();

			// Exercie 4
			System.out.println("--- Exercice 4 ---");
			try {
				String catName = "";
				BufferedReader bufferRead = new BufferedReader(
						new InputStreamReader(System.in));
				System.out.println("Entez un nom de catégorie:");
				catName = bufferRead.readLine();
				String sql = "{CALL NBRFILM_C(?)}";
				CallableStatement callNombreFilm = conn.prepareCall(sql);
				callNombreFilm.setString(1, catName);
				callNombreFilm.execute();
				System.out.println(callNombreFilm.getInt(2));

				Statement stmtrs = conn.createStatement();

				ResultSet rsFilm = stmtrs.executeQuery("SELECT * FROM category");
				System.out.println("les résultats sont:");
				
				while (rsFilm.next()) {
					String name = rsFilm.getString("name");
					callNombreFilm = conn.prepareCall(sql);
					callNombreFilm.setString(1, name);
					callNombreFilm.execute();
					
					System.out.println(name);
					System.out.println(callNombreFilm.getInt(2));
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
